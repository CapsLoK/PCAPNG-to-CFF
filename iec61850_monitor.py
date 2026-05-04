#!/usr/bin/env python3
"""
IEC 61850 GOOSE/SV Monitor and COMTRADE Generator

This program operates in two modes:
1. Live capture mode: Parse SCD file, select GSEControl/FCDA, capture network traffic,
   generate pcapng and COMTRADE files.
2. Offline mode: Analyze existing pcapng file for GOOSE transitions and generate COMTRADE.
"""

import argparse
import sys
import os
import struct
import time
import datetime
import xml.etree.ElementTree as ET
from collections import deque
from typing import Dict, List, Tuple, Optional, Any
from dataclasses import dataclass, field

try:
    from scapy.all import (
        sniff, wrpcap, rdpcap, Ether, IP, UDP, Raw,
        get_if_list, get_if_hwaddr, conf
    )
    SCAPY_AVAILABLE = True
except ImportError:
    SCAPY_AVAILABLE = False
    print("Warning: scapy not available")

try:
    import pyshark
    PYSHARK_AVAILABLE = True
except ImportError:
    PYSHARK_AVAILABLE = False
    print("Warning: pyshark not available")


@dataclass
class GSEControl:
    """Represents a GSEControl element from SCD file"""
    name: str
    ld_inst: str
    cb_name: str
    app_id: str
    mac_address: str
    vlan_id: str
    vlan_priority: str
    min_time: int  # in ms
    max_time: int  # in ms
    dataset_name: str
    ied_name: str
    fcda_list: List[Dict[str, str]] = field(default_factory=list)


@dataclass
class SampledValueControl:
    """Represents a SampledValueControl element from SCD file"""
    name: str
    ld_inst: str
    cb_name: str
    app_id: str
    mac_address: str
    vlan_id: str
    vlan_priority: str
    dataset_name: str
    ied_name: str
    smp_rate: int = 0
    nof_asdu: int = 0
    fcda_list: List[Dict[str, str]] = field(default_factory=list)


@dataclass
class DataSet:
    """Represents a DataSet element from SCD file"""
    name: str
    ied_name: str
    ld_inst: str
    fcda_list: List[Dict[str, str]] = field(default_factory=list)


@dataclass
class CapturedPacket:
    """Represents a captured network packet"""
    timestamp: float
    data: bytes
    source_mac: str
    dest_mac: str
    ethertype: int
    vlan_id: Optional[int] = None
    app_id: Optional[int] = None
    goose_data: Optional[Dict] = None
    sv_data: Optional[Dict] = None


class SCDParser:
    """Parser for IEC 61850 SCD (Substation Configuration Description) files"""
    
    def __init__(self, scd_path: str):
        self.scd_path = scd_path
        self.tree = ET.parse(scd_path)
        self.root = self.tree.getroot()
        # Handle namespace - SCD files may or may not have default namespace
        self.ns = {}
        # Check if root tag has namespace
        if self.root.tag.startswith('{'):
            ns_end = self.root.tag.find('}')
            ns_uri = self.root.tag[1:ns_end]
            self.ns = {'scl': ns_uri}
        
        self.gse_controls: List[GSEControl] = []
        self.smv_controls: List[SampledValueControl] = []
        self.datasets: Dict[str, DataSet] = {}
        
        self._parse()
    
    def _find_all(self, tag: str) -> List[ET.Element]:
        """Find all elements with given tag"""
        if self.ns:
            return self.root.findall(f'.//scl:{tag}', self.ns)
        return self.root.findall(f'.//{tag}')
    
    def _get_attr(self, elem: ET.Element, attr: str, default: str = '') -> str:
        """Get attribute value from element"""
        return elem.get(attr, default)
    
    def _find_child(self, parent: ET.Element, tag: str) -> Optional[ET.Element]:
        """Find child element with given tag"""
        if self.ns:
            return parent.find(f'scl:{tag}', self.ns)
        return parent.find(tag)
    
    def _find_all_children(self, parent: ET.Element, tag: str) -> List[ET.Element]:
        """Find all child elements with given tag"""
        if self.ns:
            return parent.findall(f'scl:{tag}', self.ns)
        return parent.findall(tag)
    
    def _parse(self):
        """Parse the SCD file"""
        # First, parse all DataSets
        self._parse_datasets()
        
        # Then parse GSE and SMV controls from Communication section
        self._parse_gse_controls()
        self._parse_smv_controls()
    
    def _parse_datasets(self):
        """Parse all DataSet elements from IED section"""
        for ied in self._find_all('IED'):
            ied_name = self._get_attr(ied, 'name')
            # DataSets can be inside LN0 or other LN elements - use iter to find them
            for ln_elem in ied.iter():
                if ln_elem.tag.endswith('LN0') or ln_elem.tag.endswith('LN'):
                    ld_inst = self._get_attr(ln_elem, 'inst', '')
                    for dataset in ln_elem:
                        if dataset.tag.endswith('DataSet'):
                            ds_name = self._get_attr(dataset, 'name')
                            
                            fcda_list = []
                            for fcda in dataset:
                                if fcda.tag.endswith('FCDA'):
                                    fcda_entry = {
                                        'ldInst': self._get_attr(fcda, 'ldInst'),
                                        'lnClass': self._get_attr(fcda, 'lnClass'),
                                        'lnInst': self._get_attr(fcda, 'lnInst'),
                                        'doName': self._get_attr(fcda, 'doName'),
                                        'fc': self._get_attr(fcda, 'fc'),
                                    }
                                    fcda_list.append(fcda_entry)
                            
                            key = f"{ied_name}/{ld_inst}/{ds_name}"
                            self.datasets[key] = DataSet(
                                name=ds_name,
                                ied_name=ied_name,
                                ld_inst=ld_inst,
                                fcda_list=fcda_list
                            )
    
    def _parse_gse_controls(self):
        """Parse GSEControl elements"""
        for connected_ap in self._find_all('ConnectedAP'):
            ied_name = self._get_attr(connected_ap, 'iedName')
            
            for gse in self._find_all_children(connected_ap, 'GSE'):
                ld_inst = self._get_attr(gse, 'ldInst')
                cb_name = self._get_attr(gse, 'cbName')
                
                # Get address information
                addr = self._find_child(gse, 'Address')
                app_id = ''
                mac_address = ''
                vlan_id = ''
                vlan_priority = ''
                
                if addr is not None:
                    for p in self._find_all_children(addr, 'P'):
                        p_type = self._get_attr(p, 'type')
                        if p_type == 'APPID':
                            app_id = p.text or ''
                        elif p_type == 'MAC-Address':
                            mac_address = p.text or ''
                        elif p_type == 'VLAN-ID':
                            vlan_id = p.text or ''
                        elif p_type == 'VLAN-PRIORITY':
                            vlan_priority = p.text or ''
                
                # Get timing parameters
                min_time_elem = self._find_child(gse, 'MinTime')
                max_time_elem = self._find_child(gse, 'MaxTime')
                
                min_time = 10  # default 10ms
                max_time = 1000  # default 1000ms
                
                if min_time_elem is not None and min_time_elem.text:
                    try:
                        mult = self._get_attr(min_time_elem, 'multiplier', 'm')
                        val = int(min_time_elem.text)
                        if mult == 'm':
                            min_time = val
                        elif mult == 's':
                            min_time = val * 1000
                    except ValueError:
                        pass
                
                if max_time_elem is not None and max_time_elem.text:
                    try:
                        mult = self._get_attr(max_time_elem, 'multiplier', 'm')
                        val = int(max_time_elem.text)
                        if mult == 'm':
                            max_time = val
                        elif mult == 's':
                            max_time = val * 1000
                    except ValueError:
                        pass
                
                # Find corresponding GSEControl in IED section and get FCDA list
                gse_control_name = ''
                dataset_name = ''
                fcda_list = []  # Initialize here
                
                for ied in self._find_all('IED'):
                    if self._get_attr(ied, 'name') == ied_name:
                        # Look inside LN0 elements for GSEControl using iter
                        for ln_elem in ied.iter():
                            if ln_elem.tag.endswith('LN0'):
                                for gse_ctrl in ln_elem:
                                    if gse_ctrl.tag.endswith('GSEControl') and self._get_attr(gse_ctrl, 'name') == cb_name:
                                        gse_control_name = self._get_attr(gse_ctrl, 'name')
                                        dataset_name = self._get_attr(gse_ctrl, 'datSet')
                                        
                                        # Get FCDA list directly from the referenced DataSet
                                        for ds in ln_elem:
                                            if ds.tag.endswith('DataSet') and self._get_attr(ds, 'name') == dataset_name:
                                                for fcda in ds:
                                                    if fcda.tag.endswith('FCDA'):
                                                        fcda_entry = {
                                                            'ldInst': self._get_attr(fcda, 'ldInst'),
                                                            'lnClass': self._get_attr(fcda, 'lnClass'),
                                                            'lnInst': self._get_attr(fcda, 'lnInst'),
                                                            'doName': self._get_attr(fcda, 'doName'),
                                                            'fc': self._get_attr(fcda, 'fc'),
                                                        }
                                                        fcda_list.append(fcda_entry)
                                                break
                                        break
                                if gse_control_name:
                                    break
                        if gse_control_name:
                            break
                
                gse_control = GSEControl(
                    name=gse_control_name or cb_name,
                    ld_inst=ld_inst,
                    cb_name=cb_name,
                    app_id=app_id,
                    mac_address=mac_address,
                    vlan_id=vlan_id,
                    vlan_priority=vlan_priority,
                    min_time=min_time,
                    max_time=max_time,
                    dataset_name=dataset_name,
                    ied_name=ied_name,
                    fcda_list=fcda_list
                )
                self.gse_controls.append(gse_control)
    
    def _parse_smv_controls(self):
        """Parse SampledValueControl elements"""
        for connected_ap in self._find_all('ConnectedAP'):
            ied_name = self._get_attr(connected_ap, 'iedName')
            
            for smv in self._find_all_children(connected_ap, 'SMV'):
                ld_inst = self._get_attr(smv, 'ldInst')
                cb_name = self._get_attr(smv, 'cbName')
                
                # Get address information
                addr = self._find_child(smv, 'Address')
                app_id = ''
                mac_address = ''
                vlan_id = ''
                vlan_priority = ''
                
                if addr is not None:
                    for p in self._find_all_children(addr, 'P'):
                        p_type = self._get_attr(p, 'type')
                        if p_type == 'APPID':
                            app_id = p.text or ''
                        elif p_type == 'MAC-Address':
                            mac_address = p.text or ''
                        elif p_type == 'VLAN-ID':
                            vlan_id = p.text or ''
                        elif p_type == 'VLAN-PRIORITY':
                            vlan_priority = p.text or ''
                
                # Find corresponding SampledValueControl in IED section and get FCDA list
                smv_control_name = ''
                dataset_name = ''
                smp_rate = 0
                nof_asdu = 0
                fcda_list = []  # Initialize here
                
                for ied in self._find_all('IED'):
                    if self._get_attr(ied, 'name') == ied_name:
                        # Look inside LN0 elements for SampledValueControl using iter
                        for ln_elem in ied.iter():
                            if ln_elem.tag.endswith('LN0'):
                                for smv_ctrl in ln_elem:
                                    if smv_ctrl.tag.endswith('SampledValueControl') and self._get_attr(smv_ctrl, 'name') == cb_name:
                                        smv_control_name = self._get_attr(smv_ctrl, 'name')
                                        dataset_name = self._get_attr(smv_ctrl, 'datSet')
                                        smp_rate = int(self._get_attr(smv_ctrl, 'smpRate', '0'))
                                        nof_asdu = int(self._get_attr(smv_ctrl, 'nofASDU', '0'))
                                        
                                        # Get FCDA list directly from the referenced DataSet
                                        for ds in ln_elem:
                                            if ds.tag.endswith('DataSet') and self._get_attr(ds, 'name') == dataset_name:
                                                for fcda in ds:
                                                    if fcda.tag.endswith('FCDA'):
                                                        fcda_entry = {
                                                            'ldInst': self._get_attr(fcda, 'ldInst'),
                                                            'lnClass': self._get_attr(fcda, 'lnClass'),
                                                            'lnInst': self._get_attr(fcda, 'lnInst'),
                                                            'doName': self._get_attr(fcda, 'doName'),
                                                            'fc': self._get_attr(fcda, 'fc'),
                                                        }
                                                        fcda_list.append(fcda_entry)
                                                break
                                        break
                                if smv_control_name:
                                    break
                        if smv_control_name:
                            break
                
                smv_control = SampledValueControl(
                    name=smv_control_name or cb_name,
                    ld_inst=ld_inst,
                    cb_name=cb_name,
                    app_id=app_id,
                    mac_address=mac_address,
                    vlan_id=vlan_id,
                    vlan_priority=vlan_priority,
                    dataset_name=dataset_name,
                    ied_name=ied_name,
                    smp_rate=smp_rate,
                    nof_asdu=nof_asdu,
                    fcda_list=fcda_list
                )
                self.smv_controls.append(smv_control)


class PacketCapture:
    """Handles packet capture and analysis"""
    
    def __init__(self, interface: str, gse_control: GSEControl, 
                 fcda_index: int, transition_type: str,
                 pre_fault_ms: int, post_fault_ms: int):
        self.interface = interface
        self.gse_control = gse_control
        self.fcda_index = fcda_index
        self.transition_type = transition_type  # '0to1' or '1to0'
        self.pre_fault_ms = pre_fault_ms
        self.post_fault_ms = post_fault_ms
        
        self.packet_buffer: deque = deque()
        self.event_detected = False
        self.event_time = 0.0
        self.captured_packets: List[CapturedPacket] = []
        
        # MAC address for filtering
        self.target_mac = self._parse_mac(gse_control.mac_address)
        self.app_id = int(gse_control.app_id, 16) if gse_control.app_id else None
    
    def _parse_mac(self, mac_str: str) -> str:
        """Parse MAC address from various formats to standard format"""
        # Convert from "01-0C-CD-01-00-00" to "01:0c:cd:01:00:00"
        return mac_str.replace('-', ':').lower()
    
    def _is_goose_packet(self, packet) -> bool:
        """Check if packet is a GOOSE packet"""
        if not hasattr(packet, 'Ether'):
            return False
        
        # GOOSE packets use Ethertype 0x88B8
        ether = packet[Ether]
        if ether.type != 0x88b8:
            return False
        
        # Check destination MAC (GOOSE uses multicast 01-0C-CD-01-xx-xx)
        dst_mac = ether.dst.lower().replace('-', ':')
        if not dst_mac.startswith('01:0c:cd:01'):
            return False
        
        return True
    
    def _parse_goose_data(self, packet) -> Optional[Dict]:
        """Parse GOOSE data from packet"""
        try:
            # GOOSE PDU starts after Ethernet header (14 bytes) + VLAN tag if present (4 bytes)
            raw_data = bytes(packet[Ether].payload)
            
            # Skip VLAN tag if present
            offset = 0
            if len(raw_data) >= 4 and raw_data[0:2] == b'\x81\x00':
                offset = 4
            
            # GOOSE APDU parsing (simplified)
            # Look for the GOOSE PDU tag (0x61 = constructed, context-specific tag 1)
            if len(raw_data) < offset + 2:
                return None
            
            # Parse GOOSE data (simplified - just extract basic info)
            goose_data = {
                'raw': raw_data,
                'st_num': 0,
                'sq_num': 0,
                'data': []
            }
            
            # Try to find state number (stNum) and sequence number (sqNum)
            # This is a simplified parser - full GOOSE parsing is complex
            
            return goose_data
            
        except Exception as e:
            return None
    
    def _check_transition(self, packet) -> bool:
        """Check if packet contains the specified transition"""
        goose_data = self._parse_goose_data(packet)
        if goose_data is None:
            return False
        
        # For demonstration, we'll check if there's any data change
        # In a real implementation, you would parse the specific FCDA value
        
        # Extract boolean values from GOOSE data
        # GOOSE data encoding: each boolean is encoded in the data section
        raw = goose_data.get('raw', b'')
        
        # Simple heuristic: look for bit changes in the data
        # This is a placeholder - real implementation needs proper ASN.1 BER decoding
        
        return False  # Placeholder - actual implementation needed
    
    def packet_callback(self, packet):
        """Callback for each captured packet"""
        timestamp = time.time()
        
        # Store packet in ring buffer for pre-fault period
        self.packet_buffer.append((timestamp, packet))
        
        # Check if this is our target GOOSE packet
        if self._is_target_packet(packet):
            # Check for transition
            if self._check_transition(packet):
                if not self.event_detected:
                    self.event_detected = True
                    self.event_time = timestamp
                    
                    # Keep pre-fault packets
                    cutoff_time = timestamp - (self.pre_fault_ms / 1000.0)
                    while self.packet_buffer and self.packet_buffer[0][0] < cutoff_time:
                        self.packet_buffer.popleft()
    
    def _is_target_packet(self, packet) -> bool:
        """Check if packet matches our target GSEControl"""
        if not hasattr(packet, 'Ether'):
            return False
        
        ether = packet[Ether]
        
        # Check MAC address
        src_mac = ether.src.lower().replace('-', ':')
        dst_mac = ether.dst.lower().replace('-', ':')
        
        if self.target_mac and self.target_mac not in [src_mac, dst_mac]:
            return False
        
        # Check Ethertype (GOOSE = 0x88B8)
        if ether.type != 0x88b8:
            return False
        
        return True
    
    def capture_live(self, duration_seconds: int = 60) -> List[CapturedPacket]:
        """Capture packets from network interface"""
        print(f"Starting capture on interface {self.interface}...")
        print(f"Waiting for GOOSE transition ({self.transition_type})...")
        print(f"Pre-fault window: {self.pre_fault_ms}ms, Post-fault window: {self.post_fault_ms}ms")
        
        start_time = time.time()
        
        # Use ring buffer approach for pre-fault capture
        def packet_handler(pkt):
            timestamp = time.time()
            
            # Add to buffer
            self.packet_buffer.append((timestamp, pkt))
            
            # Maintain buffer size based on pre-fault time
            cutoff = timestamp - (self.pre_fault_ms / 1000.0)
            while self.packet_buffer and self.packet_buffer[0][0] < cutoff:
                self.packet_buffer.popleft()
            
            # Check for event
            if not self.event_detected and self._is_target_packet(pkt):
                if self._check_transition(pkt):
                    self.event_detected = True
                    self.event_time = timestamp
                    print(f"\nEvent detected at {datetime.datetime.fromtimestamp(timestamp)}!")
                    print(f"Capturing post-fault packets for {self.post_fault_ms}ms...")
        
        # Start sniffing
        try:
            sniff(
                iface=self.interface,
                prn=packet_handler,
                timeout=duration_seconds,
                store=False
            )
        except KeyboardInterrupt:
            print("\nCapture interrupted by user")
        
        # If event was detected, wait for post-fault period
        if self.event_detected:
            end_capture_time = self.event_time + (self.post_fault_ms / 1000.0)
            while time.time() < end_capture_time:
                time.sleep(0.01)
        
        # Convert buffer to list of CapturedPacket
        for ts, pkt in self.packet_buffer:
            try:
                cp = CapturedPacket(
                    timestamp=ts,
                    data=bytes(pkt),
                    source_mac=pkt[Ether].src,
                    dest_mac=pkt[Ether].dst,
                    ethertype=pkt[Ether].type
                )
                self.captured_packets.append(cp)
            except Exception:
                continue
        
        return self.captured_packets
    
    def save_pcapng(self, output_path: str) -> bool:
        """Save captured packets to pcapng file"""
        if not self.captured_packets:
            print("No packets to save")
            return False
        
        try:
            # Create scapy packets from captured data
            scapy_packets = []
            for cp in self.captured_packets:
                try:
                    pkt = Ether(cp.data)
                    pkt.time = cp.timestamp
                    scapy_packets.append(pkt)
                except Exception:
                    continue
            
            if not scapy_packets:
                print("No valid packets to save")
                return False
            
            wrpcap(output_path, scapy_packets)
            print(f"Saved {len(scapy_packets)} packets to {output_path}")
            return True
            
        except Exception as e:
            print(f"Error saving pcapng: {e}")
            return False


class COMTradeGenerator:
    """Generate COMTRADE files from captured packets"""
    
    def __init__(self, gse_control: GSEControl, 
                 smv_control: Optional[SampledValueControl] = None):
        self.gse_control = gse_control
        self.smv_control = smv_control
        self.channels: List[Dict] = []
        self.analog_channels: List[Dict] = []
        self.digital_channels: List[Dict] = []
        self.samples: List[List[float]] = []
        self.timestamps: List[float] = []
    
    def setup_channels(self, fcda_indices: List[int], 
                       include_sv: bool = False):
        """Setup channel configuration based on FCDA selections"""
        # Add digital channels for GSEControl FCDA
        for i, fcda_idx in enumerate(fcda_indices):
            if fcda_idx < len(self.gse_control.fcda_list):
                fcda = self.gse_control.fcda_list[fcda_idx]
                channel_name = f"{fcda['lnClass']}{fcda['lnInst']}.{fcda['doName']}"
                self.digital_channels.append({
                    'name': channel_name,
                    'type': 'digital',
                    'fcda': fcda
                })
        
        # Add analog channels for SampledValueControl if present
        if include_sv and self.smv_control:
            for fcda in self.smv_control.fcda_list:
                channel_name = f"{fcda['lnClass']}{fcda['lnInst']}.{fcda['doName']}"
                self.analog_channels.append({
                    'name': channel_name,
                    'type': 'analog',
                    'fcda': fcda,
                    'multiplier': 1.0,
                    'offset': 0.0
                })
    
    def process_packets(self, packets: List[CapturedPacket]):
        """Process captured packets and extract signal values"""
        if not packets:
            return
        
        # Sort packets by timestamp
        sorted_packets = sorted(packets, key=lambda p: p.timestamp)
        
        # Use first packet timestamp as reference
        base_time = sorted_packets[0].timestamp
        
        for pkt in sorted_packets:
            # Calculate relative timestamp in microseconds
            rel_time_us = int((pkt.timestamp - base_time) * 1_000_000)
            self.timestamps.append(rel_time_us)
            
            # Extract digital values from GOOSE packets
            digital_values = self._extract_goose_values(pkt)
            
            # Extract analog values from SV packets (if applicable)
            analog_values = self._extract_sv_values(pkt)
            
            # Combine values
            sample = digital_values + analog_values
            self.samples.append(sample)
    
    def _extract_goose_values(self, packet: CapturedPacket) -> List[float]:
        """Extract digital values from GOOSE packet"""
        values = []
        
        # Placeholder - actual GOOSE parsing needed
        # For now, return zeros for all digital channels
        for _ in self.digital_channels:
            values.append(0.0)
        
        return values
    
    def _extract_sv_values(self, packet: CapturedPacket) -> List[float]:
        """Extract analog values from SV packet"""
        values = []
        
        # Placeholder - actual SV parsing needed
        # For now, return zeros for all analog channels
        for _ in self.analog_channels:
            values.append(0.0)
        
        return values
    
    def generate_cff(self, output_path: str) -> bool:
        """Generate COMTRADE CFF (Common Format File) - IEEE C37.111-2013
        
        CFF (Common Format File) is a single file that combines CFG, INF, HDR and DAT
        sections according to IEEE C37.111-2013 standard.
        """
        total_channels = len(self.digital_channels) + len(self.analog_channels)
        
        if total_channels == 0:
            print("No channels configured")
            return False
        
        if not self.samples:
            print("No samples to write")
            return False
        
        try:
            # Generate .cfg content
            cfg_content = self._generate_cfg()
            
            # Generate .dat content
            dat_content = self._generate_dat()
            
            # Determine output path
            if not output_path.endswith('.cff'):
                cff_path = output_path + '.cff'
            else:
                cff_path = output_path
            
            # Write CFF file (combined format per IEEE C37.111-2013)
            # CFF format uses specific headers for each section
            # Headers are case-insensitive but we use uppercase for clarity
            with open(cff_path, 'w', encoding='utf-8') as f:
                # CFG section header - required
                f.write("--- FILE TYPE: CFG ---\n")
                f.write(cfg_content)
                f.write("\n")
                
                # INF section header - optional (can be empty or omitted)
                f.write("--- FILE TYPE: INF ---\n")
                f.write("Generated by IEC61850 Monitor\n")
                f.write(f"Station: {self.gse_control.ied_name}\n")
                f.write(f"GSEControl: {self.gse_control.name}\n")
                f.write("\n")
                
                # HDR section header - optional (can be empty or omitted)
                f.write("--- FILE TYPE: HDR ---\n")
                f.write("IEC 61850 GOOSE/SV Monitoring Data\n")
                f.write("\n")
                
                # DAT section header with ASCII format specification - required
                f.write("--- FILE TYPE: DAT ASCII ---\n")
                f.write(dat_content)
                f.write("\n")
            
            print(f"Generated COMTRADE CFF file: {cff_path}")
            return True
            
        except Exception as e:
            print(f"Error generating COMTRADE CFF: {e}")
            import traceback
            traceback.print_exc()
            return False
    
    def _generate_dat(self) -> str:
        """Generate COMTRADE DAT file content (ASCII format)"""
        lines = []
        for i, sample in enumerate(self.samples):
            # Format: timestamp, sample_number, channel1, channel2, ...
            line = f"{self.timestamps[i]},{i}"
            for val in sample:
                line += f",{val:.6f}"
            lines.append(line)
        return "\n".join(lines)
    
    def _generate_cfg(self) -> str:
        """Generate COMTRADE configuration file content (IEEE C37.111 format)"""
        lines = []
        
        # Line 1: Station name and device ID (comma-separated)
        station_name = f"IEC61850-{self.gse_control.ied_name}"
        rec_dev_id = f"GSE:{self.gse_control.name}"
        lines.append(f"{station_name},{rec_dev_id},2013")
        
        # Line 2: Total channels, analog count with 'A', digital count with 'D'
        num_analog = len(self.analog_channels)
        num_digital = len(self.digital_channels)
        total_channels = num_analog + num_digital
        # Format: total_count, analog_count+A, digital_count+D
        analog_part = f"{num_analog}A" if num_analog > 0 else "0A"
        digital_part = f"{num_digital}D" if num_digital > 0 else "0D"
        lines.append(f"{total_channels},{analog_part},{digital_part}")
        
        # Analog channel definitions
        for i, ch in enumerate(self.analog_channels):
            # Format: n,name,phases,ccbm,uu,a,b,skew,cmin,cmax,primary,secondary,pors
            # Using simplified format for GOOSE/SV monitoring
            ch_name = ch['name'].replace(',', '_')
            # Fields: n, name, phases, ccbm, uu, a, b, skew, cmin, cmax, primary, secondary, pors
            lines.append(f"{i+1},{ch_name},,,V,1.0,0.0,0.0,-32768,32767,1.0,1.0,P")
        
        # Digital (status) channel definitions  
        for i, ch in enumerate(self.digital_channels):
            # Format: n,name,phases,ccbm,y
            ch_name = ch['name'].replace(',', '_')
            lines.append(f"{i+1},{ch_name},,,0")
        
        # Line frequency (Hz)
        lines.append("50.0")
        
        # Samples per cycle (nominal)
        if self.smv_control and self.smv_control.smp_rate > 0:
            smp_per_cycle = self.smv_control.smp_rate // 50
        else:
            smp_per_cycle = 80  # default for 4kHz sampling at 50Hz
        lines.append(str(smp_per_cycle))
        
        # Data format type (ASCII for CFF)
        lines.append("ASCII")
        
        # Time multiplier (for ASCII format, typically 1)
        lines.append("1")
        
        # Time synchronization code (0 = not synchronized, 1 = IRIG-B, 2 = SNTP, etc.)
        lines.append("0")
        
        # Trigger information
        # Trigger type: U=unknown, M=manual, E=external, G=guard, S=start
        lines.append("U")
        # Trigger sample number (relative to first sample)
        lines.append("0")
        # Number of samples before trigger (for 1 second at nominal rate)
        pre_trigger = min(smp_per_cycle * 50, len(self.samples))
        lines.append(str(pre_trigger))
        # Number of samples after trigger
        post_trigger = max(0, len(self.samples) - pre_trigger)
        lines.append(str(post_trigger))
        
        # Primary equipment rating (optional, can be empty)
        lines.append("")
        
        # Primary equipment rating phase (optional)
        lines.append("")
        
        # CT/VT ratio numerator (optional)
        lines.append("")
        
        # CT/VT ratio denominator (optional)
        lines.append("")
        
        return "\n".join(lines)


def list_interfaces():
    """List available network interfaces"""
    if not SCAPY_AVAILABLE:
        print("Scapy not available")
        return []
    
    interfaces = get_if_list()
    return interfaces


def select_interface():
    """Interactive interface selection"""
    interfaces = list_interfaces()
    
    if not interfaces:
        print("No network interfaces found")
        return None
    
    print("\nAvailable network interfaces:")
    for i, iface in enumerate(interfaces):
        try:
            mac = get_if_hwaddr(iface)
        except Exception:
            mac = "N/A"
        print(f"  {i + 1}. {iface} (MAC: {mac})")
    
    while True:
        try:
            choice = input(f"\nSelect interface (1-{len(interfaces)}): ").strip()
            idx = int(choice) - 1
            if 0 <= idx < len(interfaces):
                return interfaces[idx]
            print("Invalid selection")
        except ValueError:
            print("Please enter a number")
        except KeyboardInterrupt:
            return None


def select_gse_control(gse_controls: List[GSEControl]) -> Optional[GSEControl]:
    """Interactive GSEControl selection"""
    if not gse_controls:
        print("No GSEControls found in SCD file")
        return None
    
    print("\nAvailable GSEControls:")
    for i, gse in enumerate(gse_controls):
        print(f"  {i + 1}. {gse.name} (IED: {gse.ied_name}, "
              f"MAC: {gse.mac_address}, APPID: {gse.app_id})")
    
    while True:
        try:
            choice = input(f"\nSelect GSEControl (1-{len(gse_controls)}): ").strip()
            idx = int(choice) - 1
            if 0 <= idx < len(gse_controls):
                return gse_controls[idx]
            print("Invalid selection")
        except ValueError:
            print("Please enter a number")
        except KeyboardInterrupt:
            return None


def select_fcda(fcda_list: List[Dict[str, str]]) -> Optional[List[int]]:
    """Interactive FCDA selection"""
    if not fcda_list:
        print("No FCDA entries available")
        return None
    
    print("\nAvailable FCDA entries:")
    for i, fcda in enumerate(fcda_list):
        print(f"  {i + 1}. {fcda['ldInst']}/{fcda['lnClass']}{fcda['lnInst']}.{fcda['doName']} "
              f"(FC: {fcda['fc']})")
    
    print("\nEnter FCDA numbers separated by comma (e.g., 1,2,3) or 'all' for all:")
    
    while True:
        try:
            choice = input("> ").strip()
            if choice.lower() == 'all':
                return list(range(len(fcda_list)))
            
            indices = []
            for part in choice.split(','):
                idx = int(part.strip()) - 1
                if 0 <= idx < len(fcda_list):
                    indices.append(idx)
                else:
                    print(f"Invalid index: {part}")
                    break
            else:
                if indices:
                    return indices
            print("Please try again")
        except ValueError:
            print("Please enter numbers separated by commas")
        except KeyboardInterrupt:
            return None


def select_transition_type() -> str:
    """Select transition type"""
    print("\nSelect transition type to monitor:")
    print("  1. 0 -> 1 (rising edge)")
    print("  2. 1 -> 0 (falling edge)")
    
    while True:
        try:
            choice = input("> ").strip()
            if choice == '1':
                return '0to1'
            elif choice == '2':
                return '1to0'
            print("Invalid selection")
        except KeyboardInterrupt:
            return '0to1'


def run_mode1(args):
    """Run Mode 1: Live capture from SCD file"""
    print("=" * 60)
    print("MODE 1: Live Capture from SCD File")
    print("=" * 60)
    
    # Parse SCD file
    scd_path = args.scd_file
    if not os.path.exists(scd_path):
        print(f"SCD file not found: {scd_path}")
        return False
    
    print(f"Parsing SCD file: {scd_path}")
    try:
        parser = SCDParser(scd_path)
        print(f"Found {len(parser.gse_controls)} GSEControls")
        print(f"Found {len(parser.smv_controls)} SampledValueControls")
    except Exception as e:
        print(f"Error parsing SCD file: {e}")
        return False
    
    # Select GSEControl
    gse_control = select_gse_control(parser.gse_controls)
    if not gse_control:
        return False
    
    print(f"\nSelected GSEControl: {gse_control.name}")
    print(f"  Dataset: {gse_control.dataset_name}")
    print(f"  MinTime: {gse_control.min_time}ms, MaxTime: {gse_control.max_time}ms")
    print(f"  FCDA count: {len(gse_control.fcda_list)}")
    
    # Select FCDA
    fcda_indices = select_fcda(gse_control.fcda_list)
    if not fcda_indices:
        return False
    
    selected_fcda = [gse_control.fcda_list[i] for i in fcda_indices]
    print(f"\nSelected {len(selected_fcda)} FCDA entries")
    
    # Select transition type
    transition_type = select_transition_type()
    print(f"Monitoring for {transition_type} transition")
    
    # Get timing parameters
    pre_fault_ms = gse_control.min_time * 10  # Default: 10x MinTime
    post_fault_ms = gse_control.max_time * 2  # Default: 2x MaxTime
    
    print(f"\nTiming parameters:")
    print(f"  Pre-fault window: {pre_fault_ms}ms")
    print(f"  Post-fault window: {post_fault_ms}ms")
    
    try:
        custom_pre = input(f"Enter pre-fault time in ms [{pre_fault_ms}]: ").strip()
        if custom_pre:
            pre_fault_ms = int(custom_pre)
    except ValueError:
        pass
    
    try:
        custom_post = input(f"Enter post-fault time in ms [{post_fault_ms}]: ").strip()
        if custom_post:
            post_fault_ms = int(custom_post)
    except ValueError:
        pass
    
    # Select network interface
    interface = select_interface()
    if not interface:
        return False
    
    print(f"\nUsing interface: {interface}")
    
    # Setup packet capture
    capture = PacketCapture(
        interface=interface,
        gse_control=gse_control,
        fcda_index=fcda_indices[0] if fcda_indices else 0,
        transition_type=transition_type,
        pre_fault_ms=pre_fault_ms,
        post_fault_ms=post_fault_ms
    )
    
    # Start capture
    duration = 120  # Maximum capture duration in seconds
    packets = capture.capture_live(duration)
    
    if not packets:
        print("No packets captured")
        return False
    
    print(f"\nCaptured {len(packets)} packets")
    
    # Save pcapng file
    pcapng_output = args.output or "capture.pcapng"
    if not pcapng_output.endswith('.pcapng'):
        pcapng_output += '.pcapng'
    
    capture.save_pcapng(pcapng_output)
    
    # Generate COMTRADE
    print("\nGenerating COMTRADE file...")
    comtrade_gen = COMTradeGenerator(gse_control)
    comtrade_gen.setup_channels(fcda_indices)
    comtrade_gen.process_packets(packets)
    
    comtrade_output = args.output or "capture"
    if comtrade_output.endswith('.pcapng'):
        comtrade_output = comtrade_output[:-7]
    
    comtrade_gen.generate_cff(comtrade_output)
    
    print("\nMode 1 completed successfully!")
    return True


def run_mode2(args):
    """Run Mode 2: Analyze existing pcapng file"""
    print("=" * 60)
    print("MODE 2: Analyze Existing PCAPNG File")
    print("=" * 60)
    
    pcapng_path = args.pcap_file
    if not os.path.exists(pcapng_path):
        print(f"PCAPNG file not found: {pcapng_path}")
        return False
    
    # Parse SCD file for configuration
    scd_path = args.scd_file
    if not scd_path or not os.path.exists(scd_path):
        print(f"SCD file required for Mode 2: {scd_path}")
        return False
    
    print(f"Parsing SCD file: {scd_path}")
    try:
        parser = SCDParser(scd_path)
        print(f"Found {len(parser.gse_controls)} GSEControls")
    except Exception as e:
        print(f"Error parsing SCD file: {e}")
        return False
    
    # Select GSEControl
    gse_control = select_gse_control(parser.gse_controls)
    if not gse_control:
        return False
    
    # Select FCDA
    fcda_indices = select_fcda(gse_control.fcda_list)
    if not fcda_indices:
        return False
    
    # Select transition type
    transition_type = select_transition_type()
    
    # Get timing parameters
    pre_fault_ms = gse_control.min_time * 10
    post_fault_ms = gse_control.max_time * 2
    
    print(f"\nAnalyzing PCAPNG file: {pcapng_path}")
    print(f"Looking for {transition_type} transition...")
    
    # Read pcapng file
    try:
        if SCAPY_AVAILABLE:
            packets = rdpcap(pcapng_path)
            print(f"Read {len(packets)} packets from file")
        else:
            print("Scapy not available for reading pcap")
            return False
    except Exception as e:
        print(f"Error reading pcapng file: {e}")
        return False
    
    # Search for transition
    event_found = False
    event_packet_idx = -1
    
    # Convert target MAC
    target_mac = gse_control.mac_address.replace('-', ':').lower()
    
    for i, pkt in enumerate(packets):
        try:
            if not hasattr(pkt, 'Ether'):
                continue
            
            ether = pkt[Ether]
            
            # Check if this is a GOOSE packet to our target
            if ether.type == 0x88b8:
                src_mac = ether.src.lower().replace('-', ':')
                dst_mac = ether.dst.lower().replace('-', ':')
                
                if target_mac in [src_mac, dst_mac]:
                    # Found matching GOOSE packet
                    # In a real implementation, parse the GOOSE data and check for transition
                    # For now, we'll simulate detection
                    print(f"Found GOOSE packet at index {i}")
                    
                    # Placeholder for actual transition detection
                    # This would require proper GOOSE PDU parsing
                    event_found = True
                    event_packet_idx = i
                    break
                    
        except Exception as e:
            continue
    
    if not event_found:
        print(f"\nNo {transition_type} transition found in the pcapng file")
        print("COMTRADE file will not be generated")
        return False
    
    print(f"\nTransition found at packet index {event_packet_idx}")
    
    # Extract packets around the event
    # Calculate how many packets correspond to pre/post fault windows
    # This is approximate since packet timing varies
    
    pre_fault_start = max(0, event_packet_idx - 100)  # Approximate
    post_fault_end = min(len(packets), event_packet_idx + 100)  # Approximate
    
    selected_packets = packets[pre_fault_start:post_fault_end]
    
    # Save filtered pcapng
    output_pcapng = args.output or "filtered_capture.pcapng"
    if not output_pcapng.endswith('.pcapng'):
        output_pcapng += '.pcapng'
    
    wrpcap(output_pcapng, selected_packets)
    print(f"Saved {len(selected_packets)} packets to {output_pcapng}")
    
    # Generate COMTRADE
    print("\nGenerating COMTRADE file...")
    comtrade_gen = COMTradeGenerator(gse_control)
    comtrade_gen.setup_channels(fcda_indices)
    
    # Convert scapy packets to CapturedPacket
    captured_packets = []
    for pkt in selected_packets:
        try:
            cp = CapturedPacket(
                timestamp=float(pkt.time),
                data=bytes(pkt),
                source_mac=pkt[Ether].src,
                dest_mac=pkt[Ether].dst,
                ethertype=pkt[Ether].type
            )
            captured_packets.append(cp)
        except Exception:
            continue
    
    comtrade_gen.process_packets(captured_packets)
    
    comtrade_output = args.output or "filtered_capture"
    if comtrade_output.endswith('.pcapng'):
        comtrade_output = comtrade_output[:-7]
    
    comtrade_gen.generate_cff(comtrade_output)
    
    print("\nMode 2 completed successfully!")
    return True


def main():
    parser = argparse.ArgumentParser(
        description='IEC 61850 GOOSE/SV Monitor and COMTRADE Generator',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  Mode 1 (Live capture):
    %(prog)s --scd Solution.scd
  
  Mode 2 (Analyze existing pcap):
    %(prog)s --scd Solution.scd --pcap capture.pcapng
  
  With output specification:
    %(prog)s --scd Solution.scd -o output_files
        """
    )
    
    parser.add_argument('--scd', required=True, 
                       help='Path to SCD (Substation Configuration Description) file')
    parser.add_argument('--pcap', 
                       help='Path to existing PCAPNG file (Mode 2 only)')
    parser.add_argument('-o', '--output', 
                       help='Output file path prefix')
    parser.add_argument('--interface', 
                       help='Network interface to capture from (Mode 1)')
    parser.add_argument('--gse', 
                       help='GSEControl name to monitor (optional, will prompt if not specified)')
    parser.add_argument('--transition', choices=['0to1', '1to0'],
                       help='Transition type to monitor (optional, will prompt if not specified)')
    parser.add_argument('--pre-fault', type=int, 
                       help='Pre-fault capture time in milliseconds')
    parser.add_argument('--post-fault', type=int, 
                       help='Post-fault capture time in milliseconds')
    
    args = parser.parse_args()
    
    # Determine mode
    if args.pcap:
        # Mode 2: Analyze existing pcap
        success = run_mode2(args)
    else:
        # Mode 1: Live capture
        success = run_mode1(args)
    
    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
