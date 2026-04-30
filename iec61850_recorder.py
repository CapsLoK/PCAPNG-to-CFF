#!/usr/bin/env python3
"""
IEC 61850 GOOSE/SV Recorder and COMTRADE Converter

Программа для записи сетевых пакетов IEC 61850 (GOOSE и Sampled Values)
и конвертации в формат COMTRADE.

Режимы работы:
1. Режим реального времени (-m live или --mode live):
   - Парсинг SCD файла
   - Выбор FCDA для мониторинга
   - Выбор сетевого интерфейса
   - Ожидание изменений GOOSE и запись pcapng
   - Конвертация в COMTRADE

2. Режим обработки файла (-m file или --mode file):
   - Обработка существующего pcapng файла
   - Фильтрация по заданным параметрам
   - Конвертация в COMTRADE
"""

import argparse
import sys
import os
import struct
import xml.etree.ElementTree as ET
from datetime import datetime
from typing import Dict, List, Tuple, Optional, Any
from dataclasses import dataclass, field
import socket

try:
    from scapy.all import (
        rdpcap, wrpcap, sniff, Ether, Dot1Q, Raw,
        get_if_list, get_iface_raw_addr
    )
    SCAPY_AVAILABLE = True
except ImportError:
    SCAPY_AVAILABLE = False
    print("Warning: scapy not available. Live capture mode will not work.")


@dataclass
class GSEControl:
    """Представление GSEControl из SCD файла"""
    ied_name: str
    ld_inst: str
    cb_name: str
    app_id: str
    mac_address: str
    vlan_id: int
    vlan_priority: int
    min_time_ms: int = 0
    max_time_ms: int = 0
    dat_set: str = ""
    fcda_list: List[Dict] = field(default_factory=list)


@dataclass
class SampledValueControl:
    """Представление SampledValueControl из SCD файла"""
    ied_name: str
    ld_inst: str
    cb_name: str
    app_id: str
    mac_address: str
    vlan_id: int
    vlan_priority: int
    dat_set: str = ""
    smp_rate: int = 0
    nof_asdu: int = 0
    fcda_list: List[Dict] = field(default_factory=list)


@dataclass
class DataSet:
    """Представление DataSet из SCD файла"""
    ied_name: str
    ld_inst: str
    name: str
    fcda_list: List[Dict] = field(default_factory=list)


@dataclass
class CaptureConfig:
    """Конфигурация захвата"""
    goose_controls: List[GSEControl] = field(default_factory=list)
    smv_controls: List[SampledValueControl] = field(default_factory=list)
    monitored_fcdas: List[int] = field(default_factory=list)  # Индексы FCDA для мониторинга
    transition_type: str = "both"  # "0to1", "1to0", "both"
    pre_fault_ms: int = 100
    post_fault_ms: int = 500
    interface: str = ""
    input_pcap: str = ""


class SCDParser:
    """Парсер SCD файлов IEC 61850"""

    def __init__(self, scd_path: str):
        self.scd_path = scd_path
        self.tree = ET.parse(scd_path)
        self.root = self.tree.getroot()
        self.ns = {'scl': 'http://www.iec.ch/61850/2003/SCL'}
        self.gse_controls: List[GSEControl] = []
        self.smv_controls: List[SampledValueControl] = []
        self.data_sets: Dict[str, DataSet] = {}

    def parse(self):
        """Разбор SCD файла"""
        self._parse_communication()
        self._parse_ieds()
        return self

    def _parse_communication(self):
        """Раздел Communication - GSE и SMV настройки"""
        comm = self.root.find('scl:Communication', self.ns)
        if comm is None:
            return

        for sub_network in comm.findall('scl:SubNetwork', self.ns):
            for conn_ap in sub_network.findall('scl:ConnectedAP', self.ns):
                ied_name = conn_ap.get('iedName')

                # Парсинг GSE
                for gse in conn_ap.findall('scl:GSE', self.ns):
                    gse_control = self._parse_gse(gse, ied_name)
                    if gse_control:
                        self.gse_controls.append(gse_control)

                # Парсинг SMV
                for smv in conn_ap.findall('scl:SMV', self.ns):
                    smv_control = self._parse_smv(smv, ied_name)
                    if smv_control:
                        self.smv_controls.append(smv_control)

    def _parse_gse(self, gse_elem, ied_name: str) -> Optional[GSEControl]:
        """Парсинг элемента GSE"""
        ld_inst = gse_elem.get('ldInst')
        cb_name = gse_elem.get('cbName')

        addr = gse_elem.find('scl:Address', self.ns)
        if addr is None:
            return None

        app_id = self._get_p_value(addr, 'APPID', '0000')
        mac = self._get_p_value(addr, 'MAC-Address', '')
        vlan_id = int(self._get_p_value(addr, 'VLAN-ID', '0'))
        vlan_prio = int(self._get_p_value(addr, 'VLAN-PRIORITY', '4'))

        min_time = 0
        max_time = 0
        min_elem = gse_elem.find('scl:MinTime', self.ns)
        max_elem = gse_elem.find('scl:MaxTime', self.ns)
        if min_elem is not None:
            mult = min_elem.get('multiplier', '')
            val = float(min_elem.text or '0')
            if mult == 'm':
                min_time = int(val * 1000)
            elif mult == 's':
                min_time = int(val * 1000)
        if max_elem is not None:
            mult = max_elem.get('multiplier', '')
            val = float(max_elem.text or '0')
            if mult == 'm':
                max_time = int(val * 1000)
            elif mult == 's':
                max_time = int(val * 1000)

        return GSEControl(
            ied_name=ied_name,
            ld_inst=ld_inst,
            cb_name=cb_name,
            app_id=app_id,
            mac_address=mac.replace('-', ':').lower(),
            vlan_id=vlan_id,
            vlan_priority=vlan_prio,
            min_time_ms=min_time,
            max_time_ms=max_time
        )

    def _parse_smv(self, smv_elem, ied_name: str) -> Optional[SampledValueControl]:
        """Парсинг элемента SMV"""
        ld_inst = smv_elem.get('ldInst')
        cb_name = smv_elem.get('cbName')

        addr = smv_elem.find('scl:Address', self.ns)
        if addr is None:
            return None

        app_id = self._get_p_value(addr, 'APPID', '4000')
        mac = self._get_p_value(addr, 'MAC-Address', '')
        vlan_id = int(self._get_p_value(addr, 'VLAN-ID', '0'))
        vlan_prio = int(self._get_p_value(addr, 'VLAN-PRIORITY', '4'))

        smp_rate = 0
        nof_asdu = 0

        return SampledValueControl(
            ied_name=ied_name,
            ld_inst=ld_inst,
            cb_name=cb_name,
            app_id=app_id,
            mac_address=mac.replace('-', ':').lower(),
            vlan_id=vlan_id,
            vlan_priority=vlan_prio,
            smp_rate=smp_rate,
            nof_asdu=nof_asdu
        )

    def _get_p_value(self, addr_elem, p_type: str, default: str) -> str:
        """Получение значения P элемента по типу"""
        for p in addr_elem.findall('scl:P', self.ns):
            if p.get('type') == p_type:
                return p.text or default
        return default

    def _parse_ieds(self):
        """Раздел IED - DataSet и GSEControl/SmvControl"""
        for ied in self.root.findall('scl:IED', self.ns):
            ied_name = ied.get('name')

            access_point = ied.find('scl:AccessPoint', self.ns)
            if access_point is None:
                continue

            server = access_point.find('scl:Server', self.ns)
            if server is None:
                continue

            for ldevice in server.findall('scl:LDevice', self.ns):
                ld_inst = ldevice.get('inst')
                ln0 = ldevice.find('scl:LN0', self.ns)
                if ln0 is None:
                    continue

                # Парсинг DataSet
                for ds in ln0.findall('scl:DataSet', self.ns):
                    ds_name = ds.get('name')
                    key = f"{ied_name}{ld_inst}/{ds_name}"
                    dataset = DataSet(
                        ied_name=ied_name,
                        ld_inst=ld_inst,
                        name=ds_name
                    )

                    for fcda in ds.findall('scl:FCDA', self.ns):
                        fcda_dict = {
                            'ldInst': fcda.get('ldInst'),
                            'lnClass': fcda.get('lnClass'),
                            'lnInst': fcda.get('lnInst'),
                            'doName': fcda.get('doName'),
                            'fc': fcda.get('fc')
                        }
                        dataset.fcda_list.append(fcda_dict)

                    self.data_sets[key] = dataset

                # Связывание DataSet с GSEControl
                for gse_ctrl in ln0.findall('scl:GSEControl', self.ns):
                    cb_name = gse_ctrl.get('name')
                    dat_set = gse_ctrl.get('datSet')

                    # Найти соответствующий GSEControl в списке
                    for gc in self.gse_controls:
                        if gc.ied_name == ied_name and gc.cb_name == cb_name:
                            gc.dat_set = dat_set
                            ds_key = f"{ied_name}{ld_inst}/{dat_set}"
                            if ds_key in self.data_sets:
                                gc.fcda_list = self.data_sets[ds_key].fcda_list.copy()

                # Связывание DataSet с SampledValueControl
                for smv_ctrl in ln0.findall('scl:SampledValueControl', self.ns):
                    cb_name = smv_ctrl.get('name')
                    dat_set = smv_ctrl.get('datSet')
                    smp_rate = int(smv_ctrl.get('smpRate', '0'))
                    nof_asdu = int(smv_ctrl.get('nofASDU', '1'))

                    for sc in self.smv_controls:
                        if sc.ied_name == ied_name and sc.cb_name == cb_name:
                            sc.dat_set = dat_set
                            sc.smp_rate = smp_rate
                            sc.nof_asdu = nof_asdu
                            ds_key = f"{ied_name}{ld_inst}/{dat_set}"
                            if ds_key in self.data_sets:
                                sc.fcda_list = self.data_sets[ds_key].fcda_list.copy()

    def print_gse_controls(self):
        """Вывод списка GSEControl"""
        print("\n=== GSEControl ===")
        for i, gc in enumerate(self.gse_controls):
            print(f"{i + 1}. IED: {gc.ied_name}, LD: {gc.ld_inst}, CB: {gc.cb_name}")
            print(f"   MAC: {gc.mac_address}, VLAN: {gc.vlan_id}, APPID: {gc.app_id}")
            print(f"   DataSet: {gc.dat_set}")
            if gc.fcda_list:
                print("   FCDA:")
                for j, fcda in enumerate(gc.fcda_list):
                    print(f"      {j}: {fcda['lnClass']}{fcda['lnInst']}.{fcda['doName']}")
            print()

    def print_smv_controls(self):
        """Вывод списка SampledValueControl"""
        print("\n=== SampledValueControl ===")
        for i, sc in enumerate(self.smv_controls):
            print(f"{i + 1}. IED: {sc.ied_name}, LD: {sc.ld_inst}, CB: {sc.cb_name}")
            print(f"   MAC: {sc.mac_address}, VLAN: {sc.vlan_id}, APPID: {sc.app_id}")
            print(f"   DataSet: {sc.dat_set}, SampleRate: {sc.smp_rate}")
            if sc.fcda_list:
                print("   FCDA (аналоговые каналы):")
                for j, fcda in enumerate(sc.fcda_list):
                    print(f"      {j}: {fcda['lnClass']}{fcda['lnInst']}.{fcda['doName']}")
            print()


class GOOSEDecoder:
    """Декодер GOOSE пакетов"""

    @staticmethod
    def decode(raw_data: bytes) -> Dict:
        """
        Декодирование GOOSE APDU
        Формат ASN.1 BER кодирование
        """
        result = {
            'gocb_ref': '',
            'time_allowed_to_live': 0,
            'dataset': '',
            'go_id': '',
            't': 0,
            'st_num': 0,
            'sq_num': 0,
            'test': False,
            'conf_rev': 0,
            'nds_com': False,
            'num_dat_set_entries': 0,
            'all_data': [],
            'status': 'unknown'
        }

        try:
            offset = 0
            tag_map = {
                0x00: 'gocb_ref',
                0x01: 'time_allowed_to_live',
                0x02: 'dataset',
                0x03: 'go_id',
                0x04: 't',
                0x05: 'st_num',
                0x06: 'sq_num',
                0x07: 'test',
                0x08: 'conf_rev',
                0x09: 'nds_com',
                0x0A: 'num_dat_set_entries',
                0xAB: 'all_data'
            }

            while offset < len(raw_data):
                if offset + 2 > len(raw_data):
                    break

                tag = raw_data[offset]
                offset += 1

                # Длина
                length_byte = raw_data[offset]
                offset += 1

                if length_byte & 0x80:
                    num_len_bytes = length_byte & 0x7F
                    if num_len_bytes > 0:
                        length = int.from_bytes(raw_data[offset:offset + num_len_bytes], 'big')
                        offset += num_len_bytes
                    else:
                        length = 0
                else:
                    length = length_byte

                if offset + length > len(raw_data):
                    break

                value_bytes = raw_data[offset:offset + length]
                offset += length

                if tag in tag_map:
                    field_name = tag_map[tag]

                    if tag == 0x07:  # test - boolean
                        result[field_name] = bool(value_bytes[0]) if value_bytes else False
                    elif tag == 0x09:  # nds_com - boolean
                        result[field_name] = bool(value_bytes[0]) if value_bytes else False
                    elif tag in [0x05, 0x06, 0x08]:  # st_num, sq_num, conf_rev - int32u
                        if len(value_bytes) >= 4:
                            result[field_name] = struct.unpack('>I', value_bytes[:4])[0]
                    elif tag == 0x01:  # time_allowed_to_live - int32u
                        if len(value_bytes) >= 4:
                            result[field_name] = struct.unpack('>I', value_bytes[:4])[0]
                    elif tag == 0x04:  # t - utc_time (int64u)
                        if len(value_bytes) >= 8:
                            result[field_name] = struct.unpack('>Q', value_bytes[:8])[0]
                    elif tag == 0x0A:  # num_dat_set_entries - int32u
                        if len(value_bytes) >= 4:
                            result[field_name] = struct.unpack('>I', value_bytes[:4])[0]
                    elif tag in [0x00, 0x02, 0x03]:  # strings
                        result[field_name] = value_bytes.decode('utf-8', errors='ignore')
                    elif tag == 0xAB:  # all_data - последовательность данных
                        result[field_name] = GOOSEDecoder._decode_all_data(value_bytes)

            # Определение статуса по st_num
            if result['st_num'] > 0:
                result['status'] = 'valid'

        except Exception as e:
            result['error'] = str(e)

        return result

    @staticmethod
    def _decode_all_data(data: bytes) -> List[Dict]:
        """Декодирование последовательности данных доступа"""
        entries = []
        offset = 0

        while offset < len(data):
            if offset + 2 > len(data):
                break

            # Тег элемента данных (контекстно-специфичный)
            tag = data[offset]
            offset += 1

            # Длина
            length_byte = data[offset]
            offset += 1

            if length_byte & 0x80:
                num_len_bytes = length_byte & 0x7F
                if num_len_bytes > 0:
                    length = int.from_bytes(data[offset:offset + num_len_bytes], 'big')
                    offset += num_len_bytes
                else:
                    length = 0
            else:
                length = length_byte

            if offset + length > len(data):
                break

            value_bytes = data[offset:offset + length]
            offset += length

            entry = {
                'index': len(entries),
                'raw': value_bytes.hex(),
                'value': None,
                'type': 'unknown'
            }

            # Попытка определить тип данных
            if len(value_bytes) == 1:
                entry['value'] = value_bytes[0]
                entry['type'] = 'boolean/int8'
            elif len(value_bytes) == 2:
                entry['value'] = struct.unpack('>H', value_bytes)[0]
                entry['type'] = 'int16'
            elif len(value_bytes) == 4:
                entry['value'] = struct.unpack('>I', value_bytes)[0]
                entry['type'] = 'int32'
            elif len(value_bytes) == 8:
                entry['value'] = struct.unpack('>Q', value_bytes)[0]
                entry['type'] = 'int64'
            else:
                entry['type'] = 'binary'

            entries.append(entry)

        return entries


class SVDecoder:
    """Декодер Sampled Value пакетов (IEC 61850-9-2)"""

    @staticmethod
    def decode(raw_data: bytes) -> Dict:
        """
        Декодирование SV APDU (IEC 61850-9-2 LE или SE)
        Формат: APPID (2 байта) + длина (2 байта) + резерв (4 байта) + ASN.1
        
        Структура ASN.1 для IEC 61850-9-2:
        0x60 - Application, constructed, tag 0
        Длина
          0x80 - Context-specific, constructed, tag 0 (sv_id и др.)
        """
        result = {
            'sv_id': '',
            'smp_cnt': 0,
            'smp_synch': True,
            'data_set': [],
            'config_revision': 0,
            'smp_rate': 0
        }

        try:
            offset = 0
            
            # Пропускаем заголовок Ethernet протокола IEC 61850-9-2
            # Первые 4 байта: APPID (2) + длина (2)
            if len(raw_data) < 4:
                return result
                
            appid = int.from_bytes(raw_data[0:2], 'big')
            length = int.from_bytes(raw_data[2:4], 'big')
            offset = 4
            
            # Пропускаем 4 байта резерва (обычно 0x00000000)
            if offset + 4 <= len(raw_data):
                offset += 4
            
            # Теперь начинается ASN.1 структура
            # Ожидаем тег 0x60 (Application, constructed)
            if offset >= len(raw_data) or raw_data[offset] != 0x60:
                return result
            
            offset += 1  # пропускаем тег 0x60
            
            if offset >= len(raw_data):
                return result
                
            # Длина основного контейнера
            length_byte = raw_data[offset]
            offset += 1

            if length_byte & 0x80:
                num_len_bytes = length_byte & 0x7F
                if num_len_bytes > 0 and offset + num_len_bytes <= len(raw_data):
                    container_length = int.from_bytes(raw_data[offset:offset + num_len_bytes], 'big')
                    offset += num_len_bytes
                else:
                    return result
            else:
                container_length = length_byte

            # Декодирование элементов внутри последовательности
            seq_end = offset + container_length
            while offset < seq_end and offset < len(raw_data):
                tag = raw_data[offset]
                offset += 1

                if offset >= len(raw_data):
                    break

                length_byte = raw_data[offset]
                offset += 1

                if length_byte & 0x80:
                    num_len_bytes = length_byte & 0x7F
                    if num_len_bytes > 0 and offset + num_len_bytes <= len(raw_data):
                        elem_length = int.from_bytes(raw_data[offset:offset + num_len_bytes], 'big')
                        offset += num_len_bytes
                    else:
                        break
                else:
                    elem_length = length_byte

                if offset + elem_length > len(raw_data):
                    break

                value_bytes = raw_data[offset:offset + elem_length]
                offset += elem_length

                # Обработка конкретных тегов IEC 61850-9-2
                # Теги контекстно-специфичные [0]-[17]
                if tag == 0x80:  # [0] sv_id (VisibleString)
                    result['sv_id'] = value_bytes.decode('utf-8', errors='ignore')
                elif tag == 0x81:  # [1] smp_cnt (INT32U)
                    if len(value_bytes) >= 4:
                        result['smp_cnt'] = struct.unpack('>I', value_bytes[:4])[0]
                    elif len(value_bytes) > 0:
                        result['smp_cnt'] = int.from_bytes(value_bytes, 'big')
                elif tag == 0x82:  # [2] smp_synch (BOOLEAN)
                    result['smp_synch'] = bool(value_bytes[0]) if value_bytes else True
                elif tag == 0x83:  # [3] data_set (последовательность измерений)
                    result['data_set'] = SVDecoder._decode_measurements(value_bytes)
                elif tag == 0x85:  # [5] config_revision (INT32U)
                    if len(value_bytes) >= 4:
                        result['config_revision'] = struct.unpack('>I', value_bytes[:4])[0]
                elif tag == 0x86:  # [6] sampled rate
                    if len(value_bytes) >= 2:
                        result['smp_rate'] = struct.unpack('>H', value_bytes[:2])[0]

        except Exception as e:
            result['error'] = str(e)

        return result

    @staticmethod
    def _decode_measurements(data: bytes) -> List[Dict]:
        """Декодирование последовательности измерений"""
        measurements = []
        offset = 0

        while offset < len(data):
            if offset + 2 > len(data):
                break

            # Каждый элемент - это контекстно-специфичный тег
            tag = data[offset]
            offset += 1

            length_byte = data[offset]
            offset += 1

            if length_byte & 0x80:
                num_len_bytes = length_byte & 0x7F
                if num_len_bytes > 0:
                    length = int.from_bytes(data[offset:offset + num_len_bytes], 'big')
                    offset += num_len_bytes
                else:
                    break
            else:
                length = length_byte

            if offset + length > len(data):
                break

            value_bytes = data[offset:offset + length]
            offset += length

            measurement = {
                'index': len(measurements),
                'raw': value_bytes.hex()
            }

            # IEC 61850-9-2 использует 32-битные целые для значений
            if len(value_bytes) == 4:
                measurement['value'] = struct.unpack('>i', value_bytes)[0]
                measurement['type'] = 'INT32'
            elif len(value_bytes) == 8:
                # Качество + значение
                measurement['value'] = struct.unpack('>i', value_bytes[:4])[0]
                measurement['quality'] = struct.unpack('>I', value_bytes[4:8])[0]
                measurement['type'] = 'INT32_WITH_QUALITY'
            else:
                measurement['type'] = 'BINARY'

            measurements.append(measurement)

        return measurements


class PacketCapture:
    """Класс для захвата и анализа пакетов"""

    def __init__(self, config: CaptureConfig):
        self.config = config
        self.captured_packets = []
        self.goose_states: Dict[str, Dict] = {}  # Предыдущие состояния GOOSE
        self.trigger_time: Optional[float] = None
        self.pre_trigger_packets = []
        self.post_trigger_packets = []

    def get_available_interfaces(self) -> List[str]:
        """Получение списка доступных сетевых интерфейсов"""
        if not SCAPY_AVAILABLE:
            return []
        try:
            return get_if_list()
        except Exception:
            return []

    def filter_packet(self, packet) -> Tuple[bool, str]:
        """
        Фильтрация пакета по конфигурации
        Возвращает (is_match, packet_type)
        """
        if not packet.haslayer(Ether):
            return False, ''

        eth = packet[Ether]

        # Проверка VLAN
        if packet.haslayer(Dot1Q):
            vlan = packet[Dot1Q]
            vlan_id = vlan.vlan
        else:
            vlan_id = 0

        # Проверка на GOOSE (ethertype 0x88ba)
        is_goose = False
        is_smv = False

        if packet.haslayer(Dot1Q):
            eth_type = packet[Dot1Q].type
        else:
            eth_type = eth.type

        if eth_type == 0x88ba:
            # Различаем GOOSE и SV по MAC адресу назначения
            dst_mac = eth.dst.lower().replace('-', ':')
            if dst_mac.startswith('01:0c:cd:01'):
                is_goose = True
            elif dst_mac.startswith('01:0c:cd:04'):
                is_smv = True

        if not is_goose and not is_smv:
            return False, ''

        # Проверка по конфигурации GOOSE
        if is_goose:
            for gc in self.config.goose_controls:
                gc_mac = gc.mac_address.lower()
                if eth.dst.lower().replace('-', ':') == gc_mac:
                    if vlan_id == gc.vlan_id:
                        return True, 'goose'

        # Проверка по конфигурации SMV
        if is_smv:
            for sc in self.config.smv_controls:
                sc_mac = sc.mac_address.lower()
                if eth.dst.lower().replace('-', ':') == sc_mac:
                    if vlan_id == sc.vlan_id:
                        return True, 'smv'

        return False, ''

    def check_goose_transition(self, decoded: Dict) -> bool:
        """
        Проверка перехода состояния GOOSE
        """
        gocb_ref = decoded.get('gocb_ref', '')
        all_data = decoded.get('all_data', [])

        if not all_data:
            return False

        # Получаем предыдущее состояние
        prev_state = self.goose_states.get(gocb_ref, {})

        # Проверяем monitored_fcdas
        triggered = False
        for fcda_idx in self.config.monitored_fcdas:
            if fcda_idx < len(all_data):
                current_val = all_data[fcda_idx].get('value')
                prev_val = prev_state.get(f'fcda_{fcda_idx}')

                if current_val is not None and prev_val is not None:
                    # Проверка перехода
                    if self.config.transition_type == '0to1':
                        if prev_val == 0 and current_val == 1:
                            triggered = True
                    elif self.config.transition_type == '1to0':
                        if prev_val == 1 and current_val == 0:
                            triggered = True
                    elif self.config.transition_type == 'both':
                        if prev_val != current_val:
                            if (prev_val == 0 and current_val == 1) or \
                               (prev_val == 1 and current_val == 0):
                                triggered = True

        # Сохраняем текущее состояние
        self.goose_states[gocb_ref] = {
            f'fcda_{i}': d.get('value') for i, d in enumerate(all_data)
        }

        return triggered

    def process_packet(self, packet) -> bool:
        """
        Обработка одного пакета
        Возвращает True если был триггер
        """
        is_match, pkt_type = self.filter_packet(packet)
        if not is_match:
            return False

        timestamp = float(packet.time)

        if pkt_type == 'goose':
            if packet.haslayer(Raw):
                raw_data = bytes(packet[Raw])
                decoded = GOOSEDecoder.decode(raw_data)

                # Если ещё не было триггера, проверяем переходы
                if self.trigger_time is None:
                    if self.check_goose_transition(decoded):
                        self.trigger_time = timestamp
                        return True
                    else:
                        self.pre_trigger_packets.append((timestamp, packet, decoded))
                        # Ограничиваем размер буфера предтриггерных пакетов
                        max_pre = int(self.config.pre_fault_ms / 1000.0 * 1000)  # примерно
                        if len(self.pre_trigger_packets) > max_pre:
                            self.pre_trigger_packets.pop(0)
                else:
                    # После триггера
                    elapsed_ms = (timestamp - self.trigger_time) * 1000
                    if elapsed_ms <= self.config.post_fault_ms:
                        self.post_trigger_packets.append((timestamp, packet, decoded))
                    else:
                        # Запись завершена
                        return 'done'

        elif pkt_type == 'smv':
            if packet.haslayer(Raw):
                raw_data = bytes(packet[Raw])
                decoded = SVDecoder.decode(raw_data)

                if self.trigger_time is None:
                    self.pre_trigger_packets.append((timestamp, packet, decoded))
                else:
                    elapsed_ms = (timestamp - self.trigger_time) * 1000
                    if elapsed_ms <= self.config.post_fault_ms:
                        self.post_trigger_packets.append((timestamp, packet, decoded))
                    else:
                        return 'done'

        return False

    def capture_live(self, interface: str) -> bool:
        """
        Живой захват пакетов с интерфейса
        """
        if not SCAPY_AVAILABLE:
            print("Error: scapy not available")
            return False

        print(f"Starting capture on interface: {interface}")
        print(f"Waiting for GOOSE transition ({self.config.transition_type})...")
        print(f"Pre-fault: {self.config.pre_fault_ms}ms, Post-fault: {self.config.post_fault_ms}ms")

        self.pre_trigger_packets = []
        self.post_trigger_packets = []
        self.trigger_time = None
        self.goose_states = {}

        def packet_handler(pkt):
            result = self.process_packet(pkt)
            if result == 'done':
                raise StopIteration("Capture complete")

        try:
            sniff(
                iface=interface,
                prn=packet_handler,
                store=False,
                timeout=self.config.pre_fault_ms / 1000.0 + self.config.post_fault_ms / 1000.0 + 60
            )
        except StopIteration:
            pass
        except KeyboardInterrupt:
            print("\nCapture interrupted")

        return self.trigger_time is not None

    def capture_from_file(self, input_file: str, no_trigger: bool = False) -> bool:
        """
        Обработка пакетов из файла
        Если no_trigger=True, просто фильтруем пакеты без ожидания триггера
        """
        print(f"Reading packets from: {input_file}")

        # Используем PcapReader для потокового чтения (быстрее для больших файлов)
        try:
            from scapy.all import PcapReader
            packet_reader = PcapReader(input_file)
        except Exception as e:
            print(f"Error opening file: {e}")
            # Fallback to rdpcap for small files
            try:
                from scapy.all import rdpcap
                packets = rdpcap(input_file)
                return self._process_packet_list(packets, no_trigger)
            except Exception as e2:
                print(f"Error reading file: {e2}")
                return False

        print(f"Processing packets from file...")

        self.pre_trigger_packets = []
        self.post_trigger_packets = []
        self.trigger_time = None
        self.goose_states = {}

        packet_count = 0

        # Если режим без триггера - просто собираем все подходящие пакеты
        if no_trigger:
            for pkt in packet_reader:
                packet_count += 1
                is_match, pkt_type = self.filter_packet(pkt)
                if is_match:
                    timestamp = float(pkt.time)
                    decoded = {}
                    if pkt.haslayer(Raw):
                        raw_data = bytes(pkt[Raw])
                        if pkt_type == 'goose':
                            decoded = GOOSEDecoder.decode(raw_data)
                        elif pkt_type == 'smv':
                            decoded = SVDecoder.decode(raw_data)
                    self.pre_trigger_packets.append((timestamp, pkt, decoded))

                if packet_count % 10000 == 0:
                    print(f"Processed {packet_count} packets...")

            print(f"Total processed: {packet_count}, Found {len(self.pre_trigger_packets)} matching packets")
            return True

        # Режим с триггером
        for pkt in packet_reader:
            packet_count += 1
            result = self.process_packet(pkt)
            if result == 'done':
                print(f"Capture complete at packet {packet_count}")
                break

            if packet_count % 10000 == 0:
                print(f"Processed {packet_count} packets...")

        print(f"Total processed: {packet_count}")
        return True

    def _process_packet_list(self, packets: List, no_trigger: bool = False) -> bool:
        """Обработка списка пакетов (fallback для маленьких файлов)"""
        print(f"Total packets in file: {len(packets)}")

        self.pre_trigger_packets = []
        self.post_trigger_packets = []
        self.trigger_time = None
        self.goose_states = {}

        # Если режим без триггера - просто собираем все подходящие пакеты
        if no_trigger:
            for i, pkt in enumerate(packets):
                is_match, pkt_type = self.filter_packet(pkt)
                if is_match:
                    timestamp = float(pkt.time)
                    decoded = {}
                    if pkt.haslayer(Raw):
                        raw_data = bytes(pkt[Raw])
                        if pkt_type == 'goose':
                            decoded = GOOSEDecoder.decode(raw_data)
                        elif pkt_type == 'smv':
                            decoded = SVDecoder.decode(raw_data)
                    self.pre_trigger_packets.append((timestamp, pkt, decoded))

                if (i + 1) % 10000 == 0:
                    print(f"Processed {i + 1} packets...")

            print(f"Found {len(self.pre_trigger_packets)} matching packets")
            return True

        # Режим с триггером
        for i, pkt in enumerate(packets):
            result = self.process_packet(pkt)
            if result == 'done':
                print(f"Capture complete at packet {i}")
                break

            if (i + 1) % 10000 == 0:
                print(f"Processed {i + 1} packets...")

        return True

    def save_pcapng(self, output_file: str):
        """Сохранение захваченных пакетов в pcapng"""
        all_packets = [p[1] for p in self.pre_trigger_packets] + \
                      [p[1] for p in self.post_trigger_packets]

        if not all_packets:
            print("No packets to save")
            return

        try:
            wrpcap(output_file, all_packets)
            print(f"Saved {len(all_packets)} packets to {output_file}")
        except Exception as e:
            print(f"Error saving pcap: {e}")


class COMTradeGenerator:
    """Генератор файлов COMTRADE из захваченных данных"""

    def __init__(self, config: CaptureConfig, scd_parser: Optional[SCDParser] = None):
        self.config = config
        self.scd_parser = scd_parser

    def generate(self, packets_data: List[Tuple], output_base: str):
        """
        Генерация файлов COMTRADE (.cfg и .dat)
        packets_data: список кортежей (timestamp, packet, decoded_data)
        """
        if not packets_data:
            print("No data for COMTRADE generation")
            return

        # Разделение на GOOSE и SV
        goose_packets = [(t, p, d) for t, p, d in packets_data
                         if isinstance(d, dict) and 'st_num' in d]
        sv_packets = [(t, p, d) for t, p, d in packets_data
                      if isinstance(d, dict) and 'smp_cnt' in d]

        # Сбор аналоговых каналов из SV
        analog_channels = []
        analog_data = []

        if sv_packets and self.scd_parser:
            # Используем информацию из SCD о каналах SV
            for sc in self.scd_parser.smv_controls:
                for i, fcda in enumerate(sc.fcda_list):
                    channel_name = f"{sc.ied_name}_{sc.ld_inst}_{fcda['lnClass']}{fcda['lnInst']}.{fcda['doName']}"
                    analog_channels.append({
                        'name': channel_name,
                        'ln_class': fcda['lnClass'],
                        'unit': 'A' if fcda['lnClass'] == 'TCTR' else 'V'
                    })

            # Извлечение данных из SV пакетов
            if analog_channels:
                # Группировка по временным меткам
                sv_by_time = {}
                for ts, pkt, decoded in sv_packets:
                    smp_cnt = decoded.get('smp_cnt', 0)
                    if smp_cnt not in sv_by_time:
                        sv_by_time[smp_cnt] = {'ts': ts, 'values': {}}
                    for m in decoded.get('data_set', []):
                        idx = m.get('index', 0)
                        if idx < len(analog_channels):
                            sv_by_time[smp_cnt]['values'][idx] = m.get('value', 0)

                # Формирование матрицы данных
                for smp_cnt in sorted(sv_by_time.keys()):
                    row = [sv_by_time[smp_cnt]['values'].get(i, 0)
                           for i in range(len(analog_channels))]
                    analog_data.append(row)

        # Сбор дискретных каналов из GOOSE
        digital_channels = []
        digital_data = []

        if goose_packets and self.scd_parser:
            # Используем информацию из SCD о FCDA
            channel_map = {}  # map от индекса к имени канала
            for gc in self.scd_parser.gse_controls:
                for i, fcda in enumerate(gc.fcda_list):
                    channel_name = f"{gc.ied_name}_{gc.ld_inst}_{fcda['lnClass']}{fcda['lnInst']}.{fcda['doName']}"
                    channel_map[i] = channel_name

            # Создание каналов для всех возможных индексов
            max_idx = max(channel_map.keys()) if channel_map else -1
            for i in range(max_idx + 1):
                name = channel_map.get(i, f"GOOSE_BIT_{i}")
                digital_channels.append({'name': name, 'index': i})

            # Извлечение данных из GOOSE пакетов
            for ts, pkt, decoded in goose_packets:
                all_data = decoded.get('all_data', [])
                row = []
                for ch in digital_channels:
                    idx = ch['index']
                    if idx < len(all_data):
                        val = all_data[idx].get('value', 0)
                        # Преобразование в 0/1
                        row.append(1 if val else 0)
                    else:
                        row.append(0)
                digital_data.append((ts, row))

        # Если нет данных из SCD, создаём общие каналы
        if not analog_channels and sv_packets:
            # Создаём каналы по умолчанию
            for i in range(4):  # Предположим 4 канала
                analog_channels.append({'name': f'ANALOG_{i}', 'unit': ''})
            # Заполняем данными
            for ts, pkt, decoded in sv_packets:
                row = [m.get('value', 0) for m in decoded.get('data_set', [])[:4]]
                while len(row) < 4:
                    row.append(0)
                analog_data.append(row)

        if not digital_channels and goose_packets:
            # Создаём каналы по умолчанию
            for i in range(4):
                digital_channels.append({'name': f'DIGITAL_{i}', 'index': i})
            # Заполняем данными
            for ts, pkt, decoded in goose_packets:
                all_data = decoded.get('all_data', [])
                row = [1 if all_data[i].get('value', 0) else 0
                       for i in range(4)]
                digital_data.append((ts, row))

        # Генерация файлов
        self._write_cfg_file(
            output_base + '.cfg',
            analog_channels,
            digital_channels,
            packets_data
        )
        self._write_dat_file(
            output_base + '.dat',
            analog_data,
            digital_data,
            analog_channels,
            digital_channels
        )

        print(f"COMTRADE files generated: {output_base}.cfg, {output_base}.dat")

    def _write_cfg_file(self, filename: str, analog_ch: List, digital_ch: List,
                        packets_data: List[Tuple]):
        """Запись .cfg файла COMTRADE"""

        if not packets_data:
            return

        timestamps = [t for t, p, d in packets_data]
        start_time = min(timestamps) if timestamps else datetime.now().timestamp()
        start_dt = datetime.fromtimestamp(start_time)

        num_analog = len(analog_ch)
        num_digital = len(digital_ch)
        total_ch = num_analog + num_digital

        with open(filename, 'w') as f:
            # Заголовок
            f.write("TEST RECORD, IEC 61850 Capture\n")
            f.write(f"1\n")  # версия стандарта
            f.write(f"{total_ch},{num_analog},{num_digital}\n")  # количество каналов

            # Аналоговые каналы
            for ch in analog_ch:
                name = ch['name'][:20]  # ограничение длины имени
                unit = ch.get('unit', '')
                # Формат: имя, нормализация, мин, макс, единицы, масштаб, смещение
                f.write(f"{name},1,0,32767,{unit},1,0,A\n")

            # Дискретные каналы
            for ch in digital_ch:
                name = ch['name'][:20]
                f.write(f"{name},1,B\n")

            # Временные метки
            f.write(f"{start_dt.strftime('%d/%m/%Y,%H:%M:%S.%f')[:-3]}\n")  # время начала
            f.write(f"{start_dt.strftime('%d/%m/%Y,%H:%M:%S.%f')[:-3]}\n")  # время конца (будет обновлено)

            # Тип синхронизации
            f.write("LOCAL\n")

            # Частота дискретизации и количество выборок
            if analog_data := [d for d in packets_data if isinstance(d, tuple) and len(d) == 3 and 'smp_cnt' in d[2]]:
                f.write("50\n")  # частота сети Гц
                f.write(f"{len(analog_data)}\n")  # количество выборок
            else:
                f.write("50\n")
                f.write(f"{len(packets_data)}\n")

            # Кодировка
            f.write("ASCII\n")

            # Время срабатывания (относительно начала)
            f.write("0,0\n")  # секунды, микросекунды

            # Данные о триггере
            f.write("TRIGGER_TYPE,MANUAL\n")

            # Дополнительные данные
            f.write("END\n")

    def _write_dat_file(self, filename: str, analog_data: List[List],
                        digital_data: List[Tuple], analog_ch: List, digital_ch: List):
        """Запись .dat файла COMTRADE"""

        num_analog = len(analog_ch)
        num_digital = len(digital_ch)

        with open(filename, 'w') as f:
            # Номер выборки, относительное время, аналоговые, цифровые

            if digital_data:
                # Есть данные GOOSE с временными метками
                base_time = digital_data[0][0] if digital_data else 0

                for i, (ts, values) in enumerate(digital_data):
                    rel_time_us = int((ts - base_time) * 1_000_000)

                    # Аналоговые значения (если есть)
                    analog_vals = analog_data[i] if i < len(analog_data) else [0] * num_analog

                    # Цифровые значения как битовая маска
                    digital_mask = sum(1 << j for j, v in enumerate(values) if v)

                    # Формат: номер, время(мкс), A1, A2, ..., D
                    line = f"{i},{rel_time_us}"
                    for av in analog_vals:
                        line += f",{av}"
                    line += f",{digital_mask}"
                    f.write(line + "\n")
            else:
                # Только аналоговые данные или только GOOSE без точного времени
                for i, values in enumerate(analog_data):
                    rel_time_us = i * 100  # предположим 100 мкс между выборками
                    line = f"{i},{rel_time_us}"
                    for av in values:
                        line += f",{av}"
                    if num_digital > 0:
                        line += ",0"
                    f.write(line + "\n")


def interactive_mode():
    """Интерактивный режим для выбора параметров"""

    print("=" * 60)
    print("IEC 61850 GOOSE/SV Recorder")
    print("=" * 60)

    # Шаг 1: Выбор SCD файла
    scd_file = input("\nPath to SCD file: ").strip()
    if not os.path.exists(scd_file):
        print(f"Error: File {scd_file} not found")
        return

    # Парсинг SCD
    print(f"Parsing SCD file: {scd_file}")
    parser = SCDParser(scd_file).parse()

    parser.print_gse_controls()
    parser.print_smv_controls()

    # Шаг 2: Выбор GSEControl для мониторинга
    print("\nSelect GSEControl to monitor (comma-separated indices, or 'all'):")
    goose_selection = input("> ").strip()

    selected_goose = []
    if goose_selection.lower() == 'all':
        selected_goose = parser.gse_controls
    else:
        try:
            indices = [int(x.strip()) - 1 for x in goose_selection.split(',')]
            selected_goose = [parser.gse_controls[i] for i in indices if 0 <= i < len(parser.gse_controls)]
        except (ValueError, IndexError) as e:
            print(f"Invalid selection: {e}")
            return

    # Шаг 3: Выбор SampledValueControl
    print("\nSelect SampledValueControl to record (comma-separated indices, or 'all', or 'none'):")
    smv_selection = input("> ").strip()

    selected_smv = []
    if smv_selection.lower() == 'all':
        selected_smv = parser.smv_controls
    elif smv_selection.lower() != 'none':
        try:
            indices = [int(x.strip()) - 1 for x in smv_selection.split(',')]
            selected_smv = [parser.smv_controls[i] for i in indices if 0 <= i < len(parser.smv_controls)]
        except (ValueError, IndexError) as e:
            print(f"Invalid selection: {e}")
            return

    # Шаг 4: Выбор FCDA для мониторинга переходов
    if selected_goose:
        print("\nFCDA in selected GSEControl DataSets:")
        all_fcdas = []
        for gc in selected_goose:
            print(f"\n{gc.ied_name}/{gc.cb_name}:")
            for i, fcda in enumerate(gc.fcda_list):
                print(f"  {i}: {fcda['lnClass']}{fcda['lnInst']}.{fcda['doName']}")
                all_fcdas.append((gc, i, fcda))

        print("\nSelect FCDA indices to monitor for transitions (comma-separated):")
        fcda_selection = input("> ").strip()

        try:
            monitored_indices = [int(x.strip()) for x in fcda_selection.split(',')]
        except ValueError:
            print("Invalid selection")
            return
    else:
        monitored_indices = []

    # Шаг 5: Тип перехода
    print("\nTransition type to detect:")
    print("1. 0 -> 1")
    print("2. 1 -> 0")
    print("3. Both")
    transition_choice = input("> ").strip()

    transition_map = {'1': '0to1', '2': '1to0', '3': 'both'}
    transition_type = transition_map.get(transition_choice, 'both')

    # Шаг 6: Тайминги
    print("\nPre-fault time (ms) [default: 100]:")
    pre_fault = input("> ").strip()
    pre_fault_ms = int(pre_fault) if pre_fault else 100

    print("Post-fault time (ms) [default: 500]:")
    post_fault = input("> ").strip()
    post_fault_ms = int(post_fault) if post_fault else 500

    # Шаг 7: Выбор интерфейса
    if SCAPY_AVAILABLE:
        interfaces = get_if_list()
        print("\nAvailable network interfaces:")
        for i, iface in enumerate(interfaces):
            print(f"  {i + 1}: {iface}")

        print("\nSelect interface number:")
        iface_choice = input("> ").strip()
        try:
            interface = interfaces[int(iface_choice) - 1]
        except (ValueError, IndexError):
            print("Invalid selection")
            return
    else:
        interface = ""

    # Создание конфигурации
    config = CaptureConfig(
        goose_controls=selected_goose,
        smv_controls=selected_smv,
        monitored_fcdas=monitored_indices,
        transition_type=transition_type,
        pre_fault_ms=pre_fault_ms,
        post_fault_ms=post_fault_ms,
        interface=interface
    )

    # Запуск захвата
    capture = PacketCapture(config)

    print("\n" + "=" * 60)
    print("Starting capture...")
    print("=" * 60)

    if interface:
        success = capture.capture_live(interface)
    else:
        print("No interface selected, skipping live capture")
        success = False

    # Сохранение результатов
    if success or capture.pre_trigger_packets or capture.post_trigger_packets:
        output_pcap = "captured.pcapng"
        capture.save_pcapng(output_pcap)

        # Генерация COMTRADE
        print("\nGenerating COMTRADE files...")
        generator = COMTradeGenerator(config, parser)
        all_packets = capture.pre_trigger_packets + capture.post_trigger_packets
        generator.generate(all_packets, "output")

        print("\nDone!")
    else:
        print("\nNo data captured")


def main():
    parser = argparse.ArgumentParser(
        description='IEC 61850 GOOSE/SV Recorder and COMTRADE Converter',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  Interactive mode:
    python iec61850_recorder.py

  Live capture mode:
    python iec61850_recorder.py -m live -s Solution.scd -i eth0 --pre-fault 100 --post-fault 500

  File processing mode:
    python iec61850_recorder.py -m file -s Solution.scd -f capture.pcapng --output result

  With specific GSEControl:
    python iec61850_recorder.py -m live -s Solution.scd -g 0 -i eth0 --fcda 0,1 --transition both
        """
    )

    parser.add_argument('-m', '--mode', choices=['live', 'file', 'interactive'],
                        default='interactive', help='Operation mode')
    parser.add_argument('-s', '--scd', help='Path to SCD file')
    parser.add_argument('-i', '--interface', help='Network interface for live capture')
    parser.add_argument('-f', '--file', help='Input pcapng file for file mode')
    parser.add_argument('-o', '--output', default='output', help='Output file base name')
    parser.add_argument('-g', '--goose', type=int, nargs='+', help='GSEControl indices to monitor')
    parser.add_argument('--smv', type=int, nargs='+', help='SampledValueControl indices to record')
    parser.add_argument('--fcda', type=int, nargs='+', default=[], help='FCDA indices to monitor')
    parser.add_argument('--transition', choices=['0to1', '1to0', 'both'], default='both',
                        help='Transition type to detect')
    parser.add_argument('--pre-fault', type=int, default=100, help='Pre-fault time in ms')
    parser.add_argument('--post-fault', type=int, default=500, help='Post-fault time in ms')
    parser.add_argument('--no-trigger', action='store_true', help='File mode: collect all matching packets without waiting for trigger')

    args = parser.parse_args()

    # Интерактивный режим
    if args.mode == 'interactive' or not args.scd:
        interactive_mode()
        return

    # Проверка SCD файла
    if not os.path.exists(args.scd):
        print(f"Error: SCD file {args.scd} not found")
        sys.exit(1)

    # Парсинг SCD
    print(f"Parsing SCD file: {args.scd}")
    scd_parser = SCDParser(args.scd).parse()

    scd_parser.print_gse_controls()
    scd_parser.print_smv_controls()

    # Выбор GSEControl
    if args.goose is not None:
        selected_goose = [scd_parser.gse_controls[i] for i in args.goose
                         if 0 <= i < len(scd_parser.gse_controls)]
    else:
        selected_goose = scd_parser.gse_controls

    # Выбор SMV
    if args.smv is not None:
        selected_smv = [scd_parser.smv_controls[i] for i in args.smv
                       if 0 <= i < len(scd_parser.smv_controls)]
    else:
        selected_smv = scd_parser.smv_controls

    # Создание конфигурации
    config = CaptureConfig(
        goose_controls=selected_goose,
        smv_controls=selected_smv,
        monitored_fcdas=args.fcda,
        transition_type=args.transition,
        pre_fault_ms=args.pre_fault,
        post_fault_ms=args.post_fault,
        interface=args.interface or "",
        input_pcap=args.file or ""
    )

    capture = PacketCapture(config)

    if args.mode == 'live':
        if not args.interface:
            # Показать доступные интерфейсы
            if SCAPY_AVAILABLE:
                interfaces = capture.get_available_interfaces()
                print("\nAvailable interfaces:")
                for i, iface in enumerate(interfaces):
                    print(f"  {i + 1}: {iface}")
                print("\nPlease specify interface with -i option")
            else:
                print("scapy not available, cannot list interfaces")
            sys.exit(1)

        print(f"\nStarting live capture on {args.interface}...")
        success = capture.capture_live(args.interface)

        if success or capture.pre_trigger_packets or capture.post_trigger_packets:
            output_pcap = args.output + '.pcapng'
            capture.save_pcapng(output_pcap)

            # Генерация COMTRADE
            print("\nGenerating COMTRADE files...")
            generator = COMTradeGenerator(config, scd_parser)
            all_packets = capture.pre_trigger_packets + capture.post_trigger_packets
            generator.generate(all_packets, args.output)
        else:
            print("\nNo trigger detected")

    elif args.mode == 'file':
        if not args.file:
            print("Error: Input file (-f) required for file mode")
            sys.exit(1)

        print(f"\nProcessing file: {args.file}")
        capture.capture_from_file(args.file, no_trigger=args.no_trigger)

        if capture.pre_trigger_packets or capture.post_trigger_packets:
            output_pcap = args.output + '_filtered.pcapng'
            capture.save_pcapng(output_pcap)

            # Генерация COMTRADE
            print("\nGenerating COMTRADE files...")
            generator = COMTradeGenerator(config, scd_parser)
            all_packets = capture.pre_trigger_packets + capture.post_trigger_packets
            generator.generate(all_packets, args.output)
        else:
            print("\nNo matching packets found")


if __name__ == '__main__':
    main()
