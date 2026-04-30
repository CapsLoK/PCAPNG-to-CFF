<?xml version="1.0" encoding="utf-8"?>
<SCL xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" version="2007" revision="B" xmlns="http://www.iec.ch/61850/2003/SCL">
  <Header id="ID" version="1" revision="1">
    <History>
      <Hitem version="1" revision="01" when="2026-04-27T14:35:50" who="MachineName: DESKTOP-747VBQN, UserName: Shmelev, Version: 2.16.17.19(Debug);2026.03.03T18:54:37;master;62cbf410d1d5e89fce036116ab8b952a7cfc3eb5;" />
      <Hitem version="1" revision="02" when="2026-04-28T11:01:14" who="MachineName: DESKTOP-747VBQN, UserName: Shmelev, Version: 2.16.17.19(Debug);2026.03.03T18:54:37;master;62cbf410d1d5e89fce036116ab8b952a7cfc3eb5;" />
      <Hitem version="1" revision="03" when="2026-04-28T11:40:50" who="MachineName: DESKTOP-747VBQN, UserName: Shmelev, Version: 2.16.17.19(Debug);2026.03.03T18:54:37;master;62cbf410d1d5e89fce036116ab8b952a7cfc3eb5;" />
    </History>
  </Header>
  <Communication>
    <SubNetwork name="SubNetwork1" type="8-MMS">
      <ConnectedAP iedName="B0001" apName="AP1">
        <Address>
          <P type="IP">172.16.4.41</P>
          <P type="IP-SUBNET">255.255.248.0</P>
          <P type="IP-GATEWAY">10.10.11.254</P>
          <P type="OSI-PSEL">00000001</P>
          <P type="OSI-SSEL">0001</P>
          <P type="OSI-TSEL">0001</P>
        </Address>
        <GSE ldInst="LD1" cbName="G1">
          <Address>
            <P type="APPID">0001</P>
            <P type="MAC-Address">01-0C-CD-01-00-00</P>
            <P type="VLAN-ID">002</P>
            <P type="VLAN-PRIORITY">4</P>
          </Address>
          <MinTime unit="s" multiplier="m">10</MinTime>
          <MaxTime unit="s" multiplier="m">1000</MaxTime>
        </GSE>
        <GSE ldInst="LD1" cbName="G2">
          <Address>
            <P type="APPID">0002</P>
            <P type="MAC-Address">01-0C-CD-01-00-01</P>
            <P type="VLAN-ID">002</P>
            <P type="VLAN-PRIORITY">4</P>
          </Address>
          <MinTime unit="s" multiplier="m">10</MinTime>
          <MaxTime unit="s" multiplier="m">1000</MaxTime>
        </GSE>
        <SMV ldInst="LD1" cbName="S1">
          <Address>
            <P type="APPID">4000</P>
            <P type="MAC-Address">01-0C-CD-04-00-01</P>
            <P type="VLAN-ID">005</P>
            <P type="VLAN-PRIORITY">4</P>
          </Address>
        </SMV>
      </ConnectedAP>
      <ConnectedAP iedName="B0002" apName="AP1">
        <Address>
          <P type="IP">172.16.4.42</P>
          <P type="IP-SUBNET">255.255.248.0</P>
          <P type="IP-GATEWAY">10.10.11.254</P>
          <P type="OSI-PSEL">00000001</P>
          <P type="OSI-SSEL">0001</P>
          <P type="OSI-TSEL">0001</P>
        </Address>
        <GSE ldInst="LD1" cbName="G_goose12">
          <Address>
            <P type="APPID">0003</P>
            <P type="MAC-Address">01-0C-CD-01-00-02</P>
            <P type="VLAN-ID">002</P>
            <P type="VLAN-PRIORITY">4</P>
          </Address>
          <MinTime unit="s" multiplier="m">10</MinTime>
          <MaxTime unit="s" multiplier="m">1000</MaxTime>
        </GSE>
      </ConnectedAP>
      <ConnectedAP iedName="B0003" apName="AP1">
        <Address>
          <P type="IP">172.16.4.43</P>
          <P type="IP-SUBNET">255.255.248.0</P>
          <P type="IP-GATEWAY">10.10.11.254</P>
          <P type="OSI-PSEL">00000001</P>
          <P type="OSI-SSEL">0001</P>
          <P type="OSI-TSEL">0001</P>
        </Address>
        <GSE ldInst="LD1" cbName="G_goose12">
          <Address>
            <P type="APPID">0004</P>
            <P type="MAC-Address">01-0C-CD-01-00-03</P>
            <P type="VLAN-ID">002</P>
            <P type="VLAN-PRIORITY">4</P>
          </Address>
          <MinTime unit="s" multiplier="m">10</MinTime>
          <MaxTime unit="s" multiplier="m">1000</MaxTime>
        </GSE>
      </ConnectedAP>
    </SubNetwork>
  </Communication>
  <IED desc="B0001" name="B0001" type="0107.010 (Осциллограф)" manufacturer="NPP Bresler" configVersion="1.0" originalSclVersion="2007" originalSclRevision="B">
    <Services nameLength="64">
      <DynAssociation max="5" />
      <SettingGroups />
      <GetDirectory />
      <GetDataObjectDefinition />
      <DataObjectDirectory />
      <GetDataSetValue />
      <DataSetDirectory />
      <ConfDataSet max="50" maxAttributes="150" />
      <DynDataSet max="10" maxAttributes="50" />
      <ReadWrite />
      <ConfReportControl max="100" bufMode="both" bufConf="true" />
      <GetCBValues />
      <ReportSettings cbName="Conf" datSet="Dyn" rptID="Dyn" optFields="Dyn" bufTime="Dyn" trgOps="Dyn" intgPd="Dyn" resvTms="true" owner="true" />
      <GSESettings cbName="Conf" datSet="Conf" appID="Conf" />
      <SMVSettings cbName="Conf" datSet="Conf" svID="Conf" optFields="Conf">
        <SmpRate>96</SmpRate>
      </SMVSettings>
      <GOOSE max="100" />
      <SMVsc max="6" />
      <FileHandling />
      <ConfLNs fixPrefix="true" fixLnInst="true" />
      <ClientServices goose="true" sv="true" supportsLdName="true" maxGOOSE="100">
        <TimeSyncProt />
      </ClientServices>
      <ConfLdName />
      <SupSubscription maxGo="100" maxSv="100" />
    </Services>
    <AccessPoint name="AP1">
      <Server>
        <Authentication />
        <LDevice inst="LD1">
          <LN0 desc="Системные функции" lnType="LLN0" lnClass="LLN0" inst="">
            <DataSet name="DS_goose12">
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind1" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind2" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind3" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind4" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind5" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind6" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind7" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind8" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind9" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind10" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind11" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind12" fc="ST" />
            </DataSet>
            <DataSet name="DS_gooseLog87">
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="2" doName="Ind1" fc="ST" />
            </DataSet>
            <DataSet name="DS_sv">
              <FCDA ldInst="LD1" lnClass="TCTR" lnInst="1" doName="AmpSv" fc="MX" />
              <FCDA ldInst="LD1" lnClass="TVTR" lnInst="1" doName="VolSv" fc="MX" />
            </DataSet>
            <DataSet name="DS_mms">
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind1" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind2" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind3" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind4" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind5" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind6" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind7" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind8" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind9" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind10" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind11" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind12" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="2" doName="Ind1" fc="ST" />
            </DataSet>
            <ReportControl name="M1" datSet="DS_mms" intgPd="1000" rptID="B0001LD1/LLN0.M1" confRev="1" buffered="true" bufTime="200">
              <TrgOps dchg="true" qchg="true" />
              <OptFields timeStamp="true" reasonCode="true" entryID="true" configRef="true" />
              <RptEnabled max="5" />
            </ReportControl>
            <Inputs>
              <ExtRef desc="B0002LD1/GGIO1.Ind1 (B0002 - 1 - D1)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind1" intAddr="-g 3584 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0002LD1/GGIO1.Ind2 (B0002 - 2 - D2)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind2" intAddr="-g 3585 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0002LD1/GGIO1.Ind3 (B0002 - 3 - D3)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind3" intAddr="-g 3586 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0002LD1/GGIO1.Ind4 (B0002 - 4 - D4)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind4" intAddr="-g 3587 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0002LD1/GGIO1.Ind5 (B0002 - 5 - D5)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind5" intAddr="-g 3588 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0002LD1/GGIO1.Ind6 (B0002 - 6 - D6)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind6" intAddr="-g 3589 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0002LD1/GGIO1.Ind7 (B0002 - 7 - D7)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind7" intAddr="-g 3590 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0002LD1/GGIO1.Ind8 (B0002 - 8 - D8)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind8" intAddr="-g 3591 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0002LD1/GGIO1.Ind9 (B0002 - 9 - D9)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind9" intAddr="-g 3592 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0002LD1/GGIO1.Ind10 (B0002 - 10 - D10)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind10" intAddr="-g 3593 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0002LD1/GGIO1.Ind11 (B0002 - 11 - D11)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind11" intAddr="-g 3594 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0002LD1/GGIO1.Ind12 (B0002 - 12 - D12)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind12" intAddr="-g 3595 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0003LD1/GGIO1.Ind1 (B0003 - 1 - D1)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind1" intAddr="-g 3596 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0003LD1/GGIO1.Ind2 (B0003 - 2 - D2)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind2" intAddr="-g 3597 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0003LD1/GGIO1.Ind3 (B0003 - 3 - D3)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind3" intAddr="-g 3598 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0003LD1/GGIO1.Ind4 (B0003 - 4 - D4)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind4" intAddr="-g 3599 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0003LD1/GGIO1.Ind5 (B0003 - 5 - D5)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind5" intAddr="-g 3600 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0003LD1/GGIO1.Ind6 (B0003 - 6 - D6)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind6" intAddr="-g 3601 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0003LD1/GGIO1.Ind7 (B0003 - 7 - D7)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind7" intAddr="-g 3602 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0003LD1/GGIO1.Ind8 (B0003 - 8 - D8)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind8" intAddr="-g 3603 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0003LD1/GGIO1.Ind9 (B0003 - 9 - D9)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind9" intAddr="-g 3604 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0003LD1/GGIO1.Ind10 (B0003 - 10 - D10)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind10" intAddr="-g 3605 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0003LD1/GGIO1.Ind11 (B0003 - 11 - D11)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind11" intAddr="-g 3606 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0003LD1/GGIO1.Ind12 (B0003 - 12 - D12)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind12" intAddr="-g 3607 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
            </Inputs>
            <GSEControl name="G1" datSet="DS_goose12" confRev="1" appID="B0001LD1/LLN0.G1" />
            <GSEControl name="G2" datSet="DS_gooseLog87" confRev="1" appID="B0001LD1/LLN0.G2" />
            <SampledValueControl name="S1" datSet="DS_sv" confRev="1" smvID="B0001LD1/LLN0.S1" smpRate="80" nofASDU="1">
              <SmvOpts />
            </SampledValueControl>
            <SettingControl numOfSGs="1" />
          </LN0>
          <LN desc="Информация о физическом устройстве" lnType="LPHD" lnClass="LPHD" inst="1" />
          <LN desc="DIN12_Универсальное отображение входных/выходных данных" lnType="GGIO_1" lnClass="GGIO" inst="1">
            <DOI desc="1 - D1" name="Ind1">
              <DAI name="stVal" sAddr="-d 1024" />
              <DAI name="q" sAddr="-d 1024" />
              <DAI name="t" sAddr="-d 1024" />
              <DAI name="dU">
                <Val>1 - D1</Val>
              </DAI>
            </DOI>
            <DOI desc="2 - D2" name="Ind2">
              <DAI name="stVal" sAddr="-d 1025" />
              <DAI name="q" sAddr="-d 1025" />
              <DAI name="t" sAddr="-d 1025" />
              <DAI name="dU">
                <Val>2 - D2</Val>
              </DAI>
            </DOI>
            <DOI desc="3 - D3" name="Ind3">
              <DAI name="stVal" sAddr="-d 1026" />
              <DAI name="q" sAddr="-d 1026" />
              <DAI name="t" sAddr="-d 1026" />
              <DAI name="dU">
                <Val>3 - D3</Val>
              </DAI>
            </DOI>
            <DOI desc="4 - D4" name="Ind4">
              <DAI name="stVal" sAddr="-d 1027" />
              <DAI name="q" sAddr="-d 1027" />
              <DAI name="t" sAddr="-d 1027" />
              <DAI name="dU">
                <Val>4 - D4</Val>
              </DAI>
            </DOI>
            <DOI desc="5 - D5" name="Ind5">
              <DAI name="stVal" sAddr="-d 1028" />
              <DAI name="q" sAddr="-d 1028" />
              <DAI name="t" sAddr="-d 1028" />
              <DAI name="dU">
                <Val>5 - D5</Val>
              </DAI>
            </DOI>
            <DOI desc="6 - D6" name="Ind6">
              <DAI name="stVal" sAddr="-d 1029" />
              <DAI name="q" sAddr="-d 1029" />
              <DAI name="t" sAddr="-d 1029" />
              <DAI name="dU">
                <Val>6 - D6</Val>
              </DAI>
            </DOI>
            <DOI desc="7 - D7" name="Ind7">
              <DAI name="stVal" sAddr="-d 1030" />
              <DAI name="q" sAddr="-d 1030" />
              <DAI name="t" sAddr="-d 1030" />
              <DAI name="dU">
                <Val>7 - D7</Val>
              </DAI>
            </DOI>
            <DOI desc="8 - D8" name="Ind8">
              <DAI name="stVal" sAddr="-d 1031" />
              <DAI name="q" sAddr="-d 1031" />
              <DAI name="t" sAddr="-d 1031" />
              <DAI name="dU">
                <Val>8 - D8</Val>
              </DAI>
            </DOI>
            <DOI desc="9 - D9" name="Ind9">
              <DAI name="stVal" sAddr="-d 1032" />
              <DAI name="q" sAddr="-d 1032" />
              <DAI name="t" sAddr="-d 1032" />
              <DAI name="dU">
                <Val>9 - D9</Val>
              </DAI>
            </DOI>
            <DOI desc="10 - D10" name="Ind10">
              <DAI name="stVal" sAddr="-d 1033" />
              <DAI name="q" sAddr="-d 1033" />
              <DAI name="t" sAddr="-d 1033" />
              <DAI name="dU">
                <Val>10 - D10</Val>
              </DAI>
            </DOI>
            <DOI desc="11 - D11" name="Ind11">
              <DAI name="stVal" sAddr="-d 1034" />
              <DAI name="q" sAddr="-d 1034" />
              <DAI name="t" sAddr="-d 1034" />
              <DAI name="dU">
                <Val>11 - D11</Val>
              </DAI>
            </DOI>
            <DOI desc="12 - D12" name="Ind12">
              <DAI name="stVal" sAddr="-d 1035" />
              <DAI name="q" sAddr="-d 1035" />
              <DAI name="t" sAddr="-d 1035" />
              <DAI name="dU">
                <Val>12 - D12</Val>
              </DAI>
            </DOI>
          </LN>
          <LN desc="DIN1_Универсальное отображение входных/выходных данных - Копия 1" lnType="GGIO_2" lnClass="GGIO" inst="2">
            <DOI desc="87 - Log87" name="Ind1">
              <DAI name="stVal" sAddr="-d 1878" />
              <DAI name="q" sAddr="-d 1878" />
              <DAI name="t" sAddr="-d 1878" />
              <DAI name="dU">
                <Val>87 - Log87</Val>
              </DAI>
            </DOI>
          </LN>
          <LN desc="Регистрация аварийных событий" lnType="RDRE" lnClass="RDRE" inst="1" />
          <LN desc="Трансформатор тока" lnType="TCTR" lnClass="TCTR" inst="1">
            <DOI desc="5 - Ia" name="AmpSv">
              <SDI name="instMag">
                <DAI name="i" sAddr="-a 5" />
              </SDI>
              <DAI name="q" sAddr="-a 5" />
              <DAI name="dU">
                <Val>5 - Ia</Val>
              </DAI>
            </DOI>
          </LN>
          <LN desc="Трансформатор напряжения" lnType="TVTR" lnClass="TVTR" inst="1">
            <DOI desc="1 - Ua" name="VolSv">
              <SDI name="instMag">
                <DAI name="i" sAddr="-a 1" />
              </SDI>
              <DAI name="q" sAddr="-a 1" />
              <DAI name="dU">
                <Val>1 - Ua</Val>
              </DAI>
            </DOI>
          </LN>
        </LDevice>
      </Server>
    </AccessPoint>
    <AccessPoint name="AP3">
      <ServerAt apName="AP1" />
    </AccessPoint>
  </IED>
  <IED desc="B0002" name="B0002" type="0107.010 (Осциллограф)" manufacturer="NPP Bresler" configVersion="1.0" originalSclVersion="2007" originalSclRevision="B">
    <Services nameLength="64">
      <DynAssociation max="5" />
      <SettingGroups />
      <GetDirectory />
      <GetDataObjectDefinition />
      <DataObjectDirectory />
      <GetDataSetValue />
      <DataSetDirectory />
      <ConfDataSet max="50" maxAttributes="150" />
      <DynDataSet max="10" maxAttributes="50" />
      <ReadWrite />
      <ConfReportControl max="100" bufMode="both" bufConf="true" />
      <GetCBValues />
      <ReportSettings cbName="Conf" datSet="Dyn" rptID="Dyn" optFields="Dyn" bufTime="Dyn" trgOps="Dyn" intgPd="Dyn" resvTms="true" owner="true" />
      <GSESettings cbName="Conf" datSet="Conf" appID="Conf" />
      <SMVSettings cbName="Conf" datSet="Conf" svID="Conf" optFields="Conf">
        <SmpRate>96</SmpRate>
      </SMVSettings>
      <GOOSE max="100" />
      <SMVsc max="6" />
      <FileHandling />
      <ConfLNs fixPrefix="true" fixLnInst="true" />
      <ClientServices goose="true" sv="true" supportsLdName="true" maxGOOSE="100">
        <TimeSyncProt />
      </ClientServices>
      <ConfLdName />
      <SupSubscription maxGo="100" maxSv="100" />
    </Services>
    <AccessPoint name="AP1">
      <Server>
        <Authentication />
        <LDevice inst="LD1">
          <LN0 desc="Системные функции" lnType="LLN0" lnClass="LLN0" inst="">
            <DataSet name="DS_goose12">
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind1" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind2" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind3" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind4" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind5" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind6" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind7" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind8" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind9" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind10" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind11" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind12" fc="ST" />
            </DataSet>
            <DataSet name="DS_mms">
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind1" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind2" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind3" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind4" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind5" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind6" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind7" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind8" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind9" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind10" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind11" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind12" fc="ST" />
            </DataSet>
            <ReportControl name="M1" datSet="DS_mms" intgPd="1000" rptID="B0002LD1/LLN0.M1" confRev="1" buffered="true" bufTime="200">
              <TrgOps dchg="true" qchg="true" />
              <OptFields timeStamp="true" reasonCode="true" entryID="true" configRef="true" />
              <RptEnabled max="5" />
            </ReportControl>
            <Inputs>
              <ExtRef desc="B0001LD1/GGIO1.Ind1 (B0001 - 1 - D1)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind1" intAddr="-g 3584 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0001LD1/GGIO1.Ind2 (B0001 - 2 - D2)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind2" intAddr="-g 3585 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0001LD1/GGIO1.Ind3 (B0001 - 3 - D3)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind3" intAddr="-g 3586 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0001LD1/GGIO1.Ind4 (B0001 - 4 - D4)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind4" intAddr="-g 3587 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0001LD1/GGIO1.Ind5 (B0001 - 5 - D5)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind5" intAddr="-g 3588 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0001LD1/GGIO1.Ind6 (B0001 - 6 - D6)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind6" intAddr="-g 3589 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0001LD1/GGIO1.Ind7 (B0001 - 7 - D7)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind7" intAddr="-g 3590 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0001LD1/GGIO1.Ind8 (B0001 - 8 - D8)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind8" intAddr="-g 3591 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0001LD1/GGIO1.Ind9 (B0001 - 9 - D9)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind9" intAddr="-g 3592 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0001LD1/GGIO1.Ind10 (B0001 - 10 - D10)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind10" intAddr="-g 3593 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0001LD1/GGIO1.Ind11 (B0001 - 11 - D11)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind11" intAddr="-g 3594 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0001LD1/GGIO1.Ind12 (B0001 - 12 - D12)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind12" intAddr="-g 3595 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0003LD1/GGIO1.Ind1 (B0003 - 1 - D1)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind1" intAddr="-g 3596 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0003LD1/GGIO1.Ind2 (B0003 - 2 - D2)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind2" intAddr="-g 3597 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0003LD1/GGIO1.Ind3 (B0003 - 3 - D3)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind3" intAddr="-g 3598 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0003LD1/GGIO1.Ind4 (B0003 - 4 - D4)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind4" intAddr="-g 3599 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0003LD1/GGIO1.Ind5 (B0003 - 5 - D5)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind5" intAddr="-g 3600 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0003LD1/GGIO1.Ind6 (B0003 - 6 - D6)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind6" intAddr="-g 3601 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0003LD1/GGIO1.Ind7 (B0003 - 7 - D7)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind7" intAddr="-g 3602 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0003LD1/GGIO1.Ind8 (B0003 - 8 - D8)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind8" intAddr="-g 3603 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0003LD1/GGIO1.Ind9 (B0003 - 9 - D9)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind9" intAddr="-g 3604 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0003LD1/GGIO1.Ind10 (B0003 - 10 - D10)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind10" intAddr="-g 3605 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0003LD1/GGIO1.Ind11 (B0003 - 11 - D11)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind11" intAddr="-g 3606 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0003LD1/GGIO1.Ind12 (B0003 - 12 - D12)" iedName="B0003" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind12" intAddr="-g 3607 -scb B0003LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0001LD1/GGIO2.Ind1 (B0001 - 87 - Log87)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="2" doName="Ind1" intAddr="-g 3608 -scb B0001LD1/LLN0$GO$G2" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G2" />
            </Inputs>
            <GSEControl name="G_goose12" datSet="DS_goose12" confRev="1" appID="B0002LD1/LLN0.G1" />
            <SettingControl numOfSGs="1" />
          </LN0>
          <LN desc="Информация о физическом устройстве" lnType="LPHD" lnClass="LPHD" inst="1" />
          <LN desc="Трансформатор напряжения" lnType="TVTR" lnClass="TVTR" inst="1">
            <DOI desc="1 - Ua" name="VolSv">
              <SDI name="instMag">
                <DAI name="i" sAddr="-a 1" />
              </SDI>
              <DAI name="q" sAddr="-a 1" />
              <DAI name="dU">
                <Val>1 - Ua</Val>
              </DAI>
            </DOI>
          </LN>
          <LN desc="DIN12_Универсальное отображение входных/выходных данных" lnType="GGIO_1" lnClass="GGIO" inst="1">
            <DOI desc="1 - D1" name="Ind1">
              <DAI name="stVal" sAddr="-d 1024" />
              <DAI name="q" sAddr="-d 1024" />
              <DAI name="t" sAddr="-d 1024" />
              <DAI name="dU">
                <Val>1 - D1</Val>
              </DAI>
            </DOI>
            <DOI desc="2 - D2" name="Ind2">
              <DAI name="stVal" sAddr="-d 1025" />
              <DAI name="q" sAddr="-d 1025" />
              <DAI name="t" sAddr="-d 1025" />
              <DAI name="dU">
                <Val>2 - D2</Val>
              </DAI>
            </DOI>
            <DOI desc="3 - D3" name="Ind3">
              <DAI name="stVal" sAddr="-d 1026" />
              <DAI name="q" sAddr="-d 1026" />
              <DAI name="t" sAddr="-d 1026" />
              <DAI name="dU">
                <Val>3 - D3</Val>
              </DAI>
            </DOI>
            <DOI desc="4 - D4" name="Ind4">
              <DAI name="stVal" sAddr="-d 1027" />
              <DAI name="q" sAddr="-d 1027" />
              <DAI name="t" sAddr="-d 1027" />
              <DAI name="dU">
                <Val>4 - D4</Val>
              </DAI>
            </DOI>
            <DOI desc="5 - D5" name="Ind5">
              <DAI name="stVal" sAddr="-d 1028" />
              <DAI name="q" sAddr="-d 1028" />
              <DAI name="t" sAddr="-d 1028" />
              <DAI name="dU">
                <Val>5 - D5</Val>
              </DAI>
            </DOI>
            <DOI desc="6 - D6" name="Ind6">
              <DAI name="stVal" sAddr="-d 1029" />
              <DAI name="q" sAddr="-d 1029" />
              <DAI name="t" sAddr="-d 1029" />
              <DAI name="dU">
                <Val>6 - D6</Val>
              </DAI>
            </DOI>
            <DOI desc="7 - D7" name="Ind7">
              <DAI name="stVal" sAddr="-d 1030" />
              <DAI name="q" sAddr="-d 1030" />
              <DAI name="t" sAddr="-d 1030" />
              <DAI name="dU">
                <Val>7 - D7</Val>
              </DAI>
            </DOI>
            <DOI desc="8 - D8" name="Ind8">
              <DAI name="stVal" sAddr="-d 1031" />
              <DAI name="q" sAddr="-d 1031" />
              <DAI name="t" sAddr="-d 1031" />
              <DAI name="dU">
                <Val>8 - D8</Val>
              </DAI>
            </DOI>
            <DOI desc="9 - D9" name="Ind9">
              <DAI name="stVal" sAddr="-d 1032" />
              <DAI name="q" sAddr="-d 1032" />
              <DAI name="t" sAddr="-d 1032" />
              <DAI name="dU">
                <Val>9 - D9</Val>
              </DAI>
            </DOI>
            <DOI desc="10 - D10" name="Ind10">
              <DAI name="stVal" sAddr="-d 1033" />
              <DAI name="q" sAddr="-d 1033" />
              <DAI name="t" sAddr="-d 1033" />
              <DAI name="dU">
                <Val>10 - D10</Val>
              </DAI>
            </DOI>
            <DOI desc="11 - D11" name="Ind11">
              <DAI name="stVal" sAddr="-d 1034" />
              <DAI name="q" sAddr="-d 1034" />
              <DAI name="t" sAddr="-d 1034" />
              <DAI name="dU">
                <Val>11 - D11</Val>
              </DAI>
            </DOI>
            <DOI desc="12 - D12" name="Ind12">
              <DAI name="stVal" sAddr="-d 1035" />
              <DAI name="q" sAddr="-d 1035" />
              <DAI name="t" sAddr="-d 1035" />
              <DAI name="dU">
                <Val>12 - D12</Val>
              </DAI>
            </DOI>
          </LN>
          <LN desc="Регистрация аварийных событий" lnType="RDRE" lnClass="RDRE" inst="1" />
        </LDevice>
      </Server>
    </AccessPoint>
    <AccessPoint name="AP3">
      <ServerAt apName="AP1" />
    </AccessPoint>
  </IED>
  <IED desc="B0003" name="B0003" type="0107.010 (Осциллограф)" manufacturer="NPP Bresler" configVersion="1.0" originalSclVersion="2007" originalSclRevision="B">
    <Services nameLength="64">
      <DynAssociation max="5" />
      <SettingGroups />
      <GetDirectory />
      <GetDataObjectDefinition />
      <DataObjectDirectory />
      <GetDataSetValue />
      <DataSetDirectory />
      <ConfDataSet max="50" maxAttributes="150" />
      <DynDataSet max="10" maxAttributes="50" />
      <ReadWrite />
      <ConfReportControl max="100" bufMode="both" bufConf="true" />
      <GetCBValues />
      <ReportSettings cbName="Conf" datSet="Dyn" rptID="Dyn" optFields="Dyn" bufTime="Dyn" trgOps="Dyn" intgPd="Dyn" resvTms="true" owner="true" />
      <GSESettings cbName="Conf" datSet="Conf" appID="Conf" />
      <SMVSettings cbName="Conf" datSet="Conf" svID="Conf" optFields="Conf">
        <SmpRate>96</SmpRate>
      </SMVSettings>
      <GOOSE max="100" />
      <SMVsc max="6" />
      <FileHandling />
      <ConfLNs fixPrefix="true" fixLnInst="true" />
      <ClientServices goose="true" sv="true" supportsLdName="true" maxGOOSE="100">
        <TimeSyncProt />
      </ClientServices>
      <ConfLdName />
      <SupSubscription maxGo="100" maxSv="100" />
    </Services>
    <AccessPoint name="AP1">
      <Server>
        <Authentication />
        <LDevice inst="LD1">
          <LN0 desc="Системные функции" lnType="LLN0" lnClass="LLN0" inst="">
            <DataSet name="DS_goose12">
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind1" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind2" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind3" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind4" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind5" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind6" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind7" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind8" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind9" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind10" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind11" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind12" fc="ST" />
            </DataSet>
            <DataSet name="DS_mms">
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind1" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind2" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind3" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind4" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind5" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind6" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind7" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind8" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind9" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind10" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind11" fc="ST" />
              <FCDA ldInst="LD1" lnClass="GGIO" lnInst="1" doName="Ind12" fc="ST" />
            </DataSet>
            <ReportControl name="M1" datSet="DS_mms" intgPd="1000" rptID="B0003LD1/LLN0.M1" confRev="1" buffered="true" bufTime="200">
              <TrgOps dchg="true" qchg="true" />
              <OptFields timeStamp="true" reasonCode="true" entryID="true" configRef="true" />
              <RptEnabled max="5" />
            </ReportControl>
            <Inputs>
              <ExtRef desc="B0001LD1/GGIO1.Ind1 (B0001 - 1 - D1)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind1" intAddr="-g 3584 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0001LD1/GGIO1.Ind2 (B0001 - 2 - D2)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind2" intAddr="-g 3585 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0001LD1/GGIO1.Ind3 (B0001 - 3 - D3)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind3" intAddr="-g 3586 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0001LD1/GGIO1.Ind4 (B0001 - 4 - D4)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind4" intAddr="-g 3587 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0001LD1/GGIO1.Ind5 (B0001 - 5 - D5)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind5" intAddr="-g 3588 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0001LD1/GGIO1.Ind6 (B0001 - 6 - D6)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind6" intAddr="-g 3589 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0001LD1/GGIO1.Ind7 (B0001 - 7 - D7)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind7" intAddr="-g 3590 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0001LD1/GGIO1.Ind8 (B0001 - 8 - D8)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind8" intAddr="-g 3591 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0001LD1/GGIO1.Ind9 (B0001 - 9 - D9)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind9" intAddr="-g 3592 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0001LD1/GGIO1.Ind10 (B0001 - 10 - D10)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind10" intAddr="-g 3593 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0001LD1/GGIO1.Ind11 (B0001 - 11 - D11)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind11" intAddr="-g 3594 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0001LD1/GGIO1.Ind12 (B0001 - 12 - D12)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind12" intAddr="-g 3595 -scb B0001LD1/LLN0$GO$G1" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G1" />
              <ExtRef desc="B0002LD1/GGIO1.Ind1 (B0002 - 1 - D1)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind1" intAddr="-g 3596 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0002LD1/GGIO1.Ind2 (B0002 - 2 - D2)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind2" intAddr="-g 3597 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0002LD1/GGIO1.Ind3 (B0002 - 3 - D3)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind3" intAddr="-g 3598 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0002LD1/GGIO1.Ind4 (B0002 - 4 - D4)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind4" intAddr="-g 3599 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0002LD1/GGIO1.Ind5 (B0002 - 5 - D5)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind5" intAddr="-g 3600 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0002LD1/GGIO1.Ind6 (B0002 - 6 - D6)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind6" intAddr="-g 3601 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0002LD1/GGIO1.Ind7 (B0002 - 7 - D7)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind7" intAddr="-g 3602 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0002LD1/GGIO1.Ind8 (B0002 - 8 - D8)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind8" intAddr="-g 3603 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0002LD1/GGIO1.Ind9 (B0002 - 9 - D9)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind9" intAddr="-g 3604 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0002LD1/GGIO1.Ind10 (B0002 - 10 - D10)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind10" intAddr="-g 3605 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0002LD1/GGIO1.Ind11 (B0002 - 11 - D11)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind11" intAddr="-g 3606 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0002LD1/GGIO1.Ind12 (B0002 - 12 - D12)" iedName="B0002" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="1" doName="Ind12" intAddr="-g 3607 -scb B0002LD1/LLN0$GO$G_goose12" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G_goose12" />
              <ExtRef desc="B0001LD1/GGIO2.Ind1 (B0001 - 87 - Log87)" iedName="B0001" ldInst="LD1" prefix="" lnClass="GGIO" lnInst="2" doName="Ind1" intAddr="-g 3608 -scb B0001LD1/LLN0$GO$G2" serviceType="GOOSE" srcLDInst="LD1" srcLNClass="LLN0" srcCBName="G2" />
            </Inputs>
            <GSEControl name="G_goose12" datSet="DS_goose12" confRev="1" appID="B0003LD1/LLN0.G1" />
            <SettingControl numOfSGs="1" />
          </LN0>
          <LN desc="Информация о физическом устройстве" lnType="LPHD" lnClass="LPHD" inst="1" />
          <LN desc="Регистрация аварийных событий" lnType="RDRE" lnClass="RDRE" inst="1" />
          <LN desc="Трансформатор напряжения" lnType="TVTR" lnClass="TVTR" inst="1">
            <DOI desc="1 - Ua" name="VolSv">
              <SDI name="instMag">
                <DAI name="i" sAddr="-a 1" />
              </SDI>
              <DAI name="q" sAddr="-a 1" />
              <DAI name="dU">
                <Val>1 - Ua</Val>
              </DAI>
            </DOI>
          </LN>
          <LN desc="DIN12_Универсальное отображение входных/выходных данных" lnType="GGIO_1" lnClass="GGIO" inst="1">
            <DOI desc="1 - D1" name="Ind1">
              <DAI name="stVal" sAddr="-d 1024" />
              <DAI name="q" sAddr="-d 1024" />
              <DAI name="t" sAddr="-d 1024" />
              <DAI name="dU">
                <Val>1 - D1</Val>
              </DAI>
            </DOI>
            <DOI desc="2 - D2" name="Ind2">
              <DAI name="stVal" sAddr="-d 1025" />
              <DAI name="q" sAddr="-d 1025" />
              <DAI name="t" sAddr="-d 1025" />
              <DAI name="dU">
                <Val>2 - D2</Val>
              </DAI>
            </DOI>
            <DOI desc="3 - D3" name="Ind3">
              <DAI name="stVal" sAddr="-d 1026" />
              <DAI name="q" sAddr="-d 1026" />
              <DAI name="t" sAddr="-d 1026" />
              <DAI name="dU">
                <Val>3 - D3</Val>
              </DAI>
            </DOI>
            <DOI desc="4 - D4" name="Ind4">
              <DAI name="stVal" sAddr="-d 1027" />
              <DAI name="q" sAddr="-d 1027" />
              <DAI name="t" sAddr="-d 1027" />
              <DAI name="dU">
                <Val>4 - D4</Val>
              </DAI>
            </DOI>
            <DOI desc="5 - D5" name="Ind5">
              <DAI name="stVal" sAddr="-d 1028" />
              <DAI name="q" sAddr="-d 1028" />
              <DAI name="t" sAddr="-d 1028" />
              <DAI name="dU">
                <Val>5 - D5</Val>
              </DAI>
            </DOI>
            <DOI desc="6 - D6" name="Ind6">
              <DAI name="stVal" sAddr="-d 1029" />
              <DAI name="q" sAddr="-d 1029" />
              <DAI name="t" sAddr="-d 1029" />
              <DAI name="dU">
                <Val>6 - D6</Val>
              </DAI>
            </DOI>
            <DOI desc="7 - D7" name="Ind7">
              <DAI name="stVal" sAddr="-d 1030" />
              <DAI name="q" sAddr="-d 1030" />
              <DAI name="t" sAddr="-d 1030" />
              <DAI name="dU">
                <Val>7 - D7</Val>
              </DAI>
            </DOI>
            <DOI desc="8 - D8" name="Ind8">
              <DAI name="stVal" sAddr="-d 1031" />
              <DAI name="q" sAddr="-d 1031" />
              <DAI name="t" sAddr="-d 1031" />
              <DAI name="dU">
                <Val>8 - D8</Val>
              </DAI>
            </DOI>
            <DOI desc="9 - D9" name="Ind9">
              <DAI name="stVal" sAddr="-d 1032" />
              <DAI name="q" sAddr="-d 1032" />
              <DAI name="t" sAddr="-d 1032" />
              <DAI name="dU">
                <Val>9 - D9</Val>
              </DAI>
            </DOI>
            <DOI desc="10 - D10" name="Ind10">
              <DAI name="stVal" sAddr="-d 1033" />
              <DAI name="q" sAddr="-d 1033" />
              <DAI name="t" sAddr="-d 1033" />
              <DAI name="dU">
                <Val>10 - D10</Val>
              </DAI>
            </DOI>
            <DOI desc="11 - D11" name="Ind11">
              <DAI name="stVal" sAddr="-d 1034" />
              <DAI name="q" sAddr="-d 1034" />
              <DAI name="t" sAddr="-d 1034" />
              <DAI name="dU">
                <Val>11 - D11</Val>
              </DAI>
            </DOI>
            <DOI desc="12 - D12" name="Ind12">
              <DAI name="stVal" sAddr="-d 1035" />
              <DAI name="q" sAddr="-d 1035" />
              <DAI name="t" sAddr="-d 1035" />
              <DAI name="dU">
                <Val>12 - D12</Val>
              </DAI>
            </DOI>
          </LN>
        </LDevice>
      </Server>
    </AccessPoint>
    <AccessPoint name="AP3">
      <ServerAt apName="AP1" />
    </AccessPoint>
  </IED>
  <DataTypeTemplates>
    <LNodeType id="LLN0" desc="Системные функции" lnClass="LLN0">
      <DO desc="Информация о логическом узле" name="NamPlt" type="LPL0" />
      <DO desc="Индикация поведения" name="Beh" type="ENS_Beh" />
      <DO desc="Индикация исправности" name="Health" type="ENS_Health" />
      <DO desc="Положение ключа режима управления (ИСТИНА - местное)" name="LocKey" type="SPS" />
      <DO desc="Поведение местного управления" name="Loc" type="SPS" />
      <DO desc="Режим работы" name="Mod" type="ENC_Mod" />
      <DO desc="Полномочия переключения на станционном уровне" name="LocSta" type="SPC" />
      <DO desc="Сброс светодиодов" name="LEDRs" type="SPC" transient="true" />
    </LNodeType>
    <LNodeType id="LPHD" desc="Информация о физическом устройстве" lnClass="LPHD">
      <DO desc="Информация о физическом устройстве" name="PhyNam" type="DPL" />
      <DO desc="Контроль исправности устройства" name="PhyHealth" type="ENS_Health" />
      <DO desc="Индикация логического узла-прокси" name="Proxy" type="SPS" />
      <DO desc="Число включений устройства" name="NumPwrUp" type="INS" />
      <DO desc="Число программных перезагрузок" name="WrmStr" type="INS" />
      <DO desc="Число срабатываний реле готовности устройства" name="WacTrg" type="INS" />
      <DO desc="Индикация наличия оперативного питания " name="PwrUp" type="SPS" />
      <DO desc="Индикация потери оперативного питания" name="PwrDn" type="SPS" />
      <DO desc="Неисправность цепей оперативного питания" name="PwrSupAlm" type="SPS" />
      <DO desc="Отказ источника питания" name="PwrFail" type="SPS_PrivateDataNs_1" />
      <DO desc="Исправность ОЗУ" name="RAMHealth" type="ENS_Health_PrivateDataNs" />
      <DO desc="Исправность ПЗУ" name="ROMHealth" type="ENS_Health_PrivateDataNs" />
      <DO desc="Отказ АЦП" name="AdcFail" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ ЦП" name="CPUFail" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ встроенного ПО" name="FWFail" type="SPS_PrivateDataNs_1" />
      <DO desc="Температурный режим ИЭУ" name="TmpHealth" type="ENS_Health_PrivateDataNs" />
      <DO desc="Отказ 1 модуля аналоговых входов" name="AIunitSt1" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 2 модуля аналоговых входов" name="AIunitSt2" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 3 модуля аналоговых входов" name="AIunitSt3" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 4 модуля аналоговых входов" name="AIunitSt4" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 5 модуля аналоговых входов" name="AIunitSt5" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 6 модуля аналоговых входов" name="AIunitSt6" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 7 модуля аналоговых входов" name="AIunitSt7" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 8 модуля аналоговых входов" name="AIunitSt8" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 9 модуля аналоговых входов" name="AIunitSt9" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 10 модуля аналоговых входов" name="AIunitSt10" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 11 модуля аналоговых входов" name="AIunitSt11" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 12 модуля аналоговых входов" name="AIunitSt12" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 13 модуля аналоговых входов" name="AIunitSt13" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 14 модуля аналоговых входов" name="AIunitSt14" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 15 модуля аналоговых входов" name="AIunitSt15" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 16 модуля аналоговых входов" name="AIunitSt16" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 1 модуля дискретных/релейных входов выходов" name="DIOunitSt1" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 2 модуля дискретных/релейных входов выходов" name="DIOunitSt2" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 3 модуля дискретных/релейных входов выходов" name="DIOunitSt3" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 4 модуля дискретных/релейных входов выходов" name="DIOunitSt4" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 5 модуля дискретных/релейных входов выходов" name="DIOunitSt5" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 6 модуля дискретных/релейных входов выходов" name="DIOunitSt6" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 7 модуля дискретных/релейных входов выходов" name="DIOunitSt7" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 8 модуля дискретных/релейных входов выходов" name="DIOunitSt8" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 9 модуля дискретных/релейных входов выходов" name="DIOunitSt9" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 10 модуля дискретных/релейных входов выходов" name="DIOunitSt10" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 11 модуля дискретных/релейных входов выходов" name="DIOunitSt11" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 12 модуля дискретных/релейных входов выходов" name="DIOunitSt12" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 13 модуля дискретных/релейных входов выходов" name="DIOunitSt13" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 14 модуля дискретных/релейных входов выходов" name="DIOunitSt14" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 15 модуля дискретных/релейных входов выходов" name="DIOunitSt15" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ 16 модуля дискретных/релейных входов выходов" name="DIOunitSt16" type="SPS_PrivateDataNs_1" />
      <DO desc="Отказ вспомогательного модуля" name="AuxIOUnitSt1" type="SPS_PrivateDataNs_1" />
      <DO desc="Установлено подключение через сервисный порт" name="SrvConn" type="SPS_PrivateDataNs_1" />
      <DO desc="Ошибка авторизации" name="CybSecEvt" type="SPS_PrivateDataNs_1" />
      <DO desc="Ошибка конфигурации" name="CRFail" type="SPS_PrivateDataNs_1" />
      <DO desc="Конфигурация изменена" name="CRChg" type="SPS_PrivateDataNs_1" />
      <DO desc="Сброс статистических данных устройства" name="RsStat" type="SPC" transient="true" />
      <DO desc="Перевод в режим симуляции для получения GOOSE и SV от испытательных систем" name="Sim" type="SPC" />
    </LNodeType>
    <LNodeType id="GGIO_1" desc="DIN12_Универсальное отображение входных/выходных данных" lnClass="GGIO">
      <DO desc="Информация о логическом узле" name="NamPlt" type="LPL" />
      <DO desc="Индикация поведения" name="Beh" type="ENS_Beh" />
      <DO desc="Индикация исправности" name="Health" type="ENS_Health" />
      <DO desc="Однопозиционный дискретный вход" name="Ind1" type="SPS" />
      <DO desc="Однопозиционный дискретный вход" name="Ind2" type="SPS" />
      <DO desc="Однопозиционный дискретный вход" name="Ind3" type="SPS" />
      <DO desc="Однопозиционный дискретный вход" name="Ind4" type="SPS" />
      <DO desc="Однопозиционный дискретный вход" name="Ind5" type="SPS" />
      <DO desc="Однопозиционный дискретный вход" name="Ind6" type="SPS" />
      <DO desc="Однопозиционный дискретный вход" name="Ind7" type="SPS" />
      <DO desc="Однопозиционный дискретный вход" name="Ind8" type="SPS" />
      <DO desc="Однопозиционный дискретный вход" name="Ind9" type="SPS" />
      <DO desc="Однопозиционный дискретный вход" name="Ind10" type="SPS" />
      <DO desc="Однопозиционный дискретный вход" name="Ind11" type="SPS" />
      <DO desc="Однопозиционный дискретный вход" name="Ind12" type="SPS" />
      <DO desc="Режим работы" name="Mod" type="ENC_Mod_St" />
    </LNodeType>
    <LNodeType id="GGIO_2" desc="DIN1_Универсальное отображение входных/выходных данных - Копия 1" lnClass="GGIO">
      <DO desc="Информация о логическом узле" name="NamPlt" type="LPL" />
      <DO desc="Индикация поведения" name="Beh" type="ENS_Beh" />
      <DO desc="Индикация исправности" name="Health" type="ENS_Health" />
      <DO desc="Однопозиционный дискретный вход" name="Ind1" type="SPS" />
      <DO desc="Режим работы" name="Mod" type="ENC_Mod_St" />
    </LNodeType>
    <LNodeType id="RDRE" desc="Регистрация аварийных событий" lnClass="RDRE">
      <DO desc="Информация о логическом узле" name="NamPlt" type="LPL" />
      <DO desc="Индикация поведения" name="Beh" type="ENS_Beh" />
      <DO desc="Индикация исправности" name="Health" type="ENS_Health" />
      <DO desc="Регистрация событий завершена" name="RcdMade" type="SPS" />
      <DO desc="Номер КЗ" name="FltNum" type="INS" />
      <DO desc="Номер КЗЗ" name="GriFltNum" type="INS" />
      <DO desc="Пуск записи" name="RcdStr" type="SPS" />
      <DO desc="Использование памяти в процентах" name="MemUsed" type="INS" />
      <DO desc="Количество сохраненных осциллограмм" name="RcdCnt" type="INS_PrivateDataNs" />
      <DO desc="Циклическая запись" name="CircRec" type="SPS_PrivateDataNs_2" />
      <DO desc="Внешний пуск" name="RcdTrg" type="SPC" />
      <DO desc="Очистка памяти (удалить все содержимое памяти)" name="MemClr" type="SPC" transient="true" />
      <DO desc="Режим работы" name="Mod" type="ENC_Mod_St" />
      <DO desc="Режим пуска записи (автоматический пуск по заданным условиям, внешний пуск, оба)" name="TrgMod" type="ENG_SP_TriggerSourceKind" />
      <DO desc="Уровень переполнения памяти, %" name="MemFull" type="ING_SG" />
      <DO desc="Режим работы при переполнении памяти (останов записи, перезапись)" name="RcdMod" type="ENG_SP_RecordingModeKind" />
    </LNodeType>
    <LNodeType id="TCTR" desc="Трансформатор тока" lnClass="TCTR">
      <DO desc="Информация о логическом узле" name="NamPlt" type="LPL" />
      <DO desc="Режим работы относительно устройства" name="Beh" type="ENS_Beh" />
      <DO desc="Состояние работы" name="Health" type="ENS_Health" />
      <DO desc="Ток (Sampled value)" name="AmpSv" type="SAV_Amp" />
      <DO desc="Режим работы" name="Mod" type="ENC_Mod" />
    </LNodeType>
    <LNodeType id="TVTR" desc="Трансформатор напряжения" lnClass="TVTR">
      <DO desc="Информация о логическом узле" name="NamPlt" type="LPL" />
      <DO desc="Режим работы относительно устройства" name="Beh" type="ENS_Beh" />
      <DO desc="Состояние работы" name="Health" type="ENS_Health" />
      <DO desc="Напряжение (Sampled value)" name="VolSv" type="SAV_Vol" />
      <DO desc="Режим работы" name="Mod" type="ENC_Mod" />
    </LNodeType>
    <DOType id="LPL0" cdc="LPL">
      <DA name="vendor" bType="VisString255" valKind="RO" fc="DC">
        <Val>NPP Bresler</Val>
      </DA>
      <DA name="swRev" bType="VisString255" valKind="RO" fc="DC">
        <Val>v3</Val>
      </DA>
      <DA name="dU" bType="Unicode255" valKind="RO" fc="DC" />
      <DA name="configRev" bType="VisString255" valKind="RO" fc="DC">
        <Val>1</Val>
      </DA>
      <DA name="ldNs" bType="VisString255" valKind="RO" fc="EX">
        <Val>IEC 61850-7-4:2007A</Val>
      </DA>
    </DOType>
    <DOType id="ENS_Beh" cdc="ENS">
      <DA name="stVal" bType="Enum" type="BehaviourModeKind" dchg="true" fc="ST" />
      <DA name="q" bType="Quality" qchg="true" fc="ST" />
      <DA name="t" bType="Timestamp" fc="ST" />
      <DA name="dU" bType="Unicode255" valKind="RO" fc="DC" />
    </DOType>
    <DOType id="ENS_Health" cdc="ENS">
      <DA name="stVal" bType="Enum" type="HealthKind" dchg="true" fc="ST" />
      <DA name="q" bType="Quality" qchg="true" fc="ST" />
      <DA name="t" bType="Timestamp" fc="ST" />
      <DA name="dU" bType="Unicode255" valKind="RO" fc="DC" />
    </DOType>
    <DOType id="SPS" cdc="SPS">
      <DA name="stVal" bType="BOOLEAN" dchg="true" fc="ST" />
      <DA name="q" bType="Quality" qchg="true" fc="ST" />
      <DA name="t" bType="Timestamp" fc="ST" />
      <DA name="dU" bType="Unicode255" valKind="RO" fc="DC" />
    </DOType>
    <DOType id="ENC_Mod" cdc="ENC">
      <DA name="Oper" bType="Struct" type="OperateEnumMod" fc="CO" />
      <DA name="stVal" bType="Enum" type="BehaviourModeKind" dchg="true" fc="ST" />
      <DA name="q" bType="Quality" qchg="true" fc="ST" />
      <DA name="t" bType="Timestamp" fc="ST" />
      <DA name="ctlModel" bType="Enum" valKind="RO" type="CtlModelKind" dchg="true" fc="CF">
        <Val>direct-with-enhanced-security</Val>
      </DA>
      <DA name="dU" bType="Unicode255" valKind="RO" fc="DC" />
    </DOType>
    <DOType id="SPC" cdc="SPC">
      <DA name="Oper" bType="Struct" type="Operate" fc="CO" />
      <DA name="stVal" bType="BOOLEAN" dchg="true" fc="ST" />
      <DA name="q" bType="Quality" qchg="true" fc="ST" />
      <DA name="t" bType="Timestamp" fc="ST" />
      <DA name="ctlModel" bType="Enum" valKind="RO" type="CtlModelKind" dchg="true" fc="CF">
        <Val>direct-with-enhanced-security</Val>
      </DA>
      <DA name="dU" bType="Unicode255" valKind="RO" fc="DC" />
    </DOType>
    <DOType id="DPL" cdc="DPL">
      <DA name="vendor" bType="VisString255" valKind="RO" fc="DC">
        <Val>NPP Bresler</Val>
      </DA>
      <DA name="serNum" bType="VisString255" valKind="RO" fc="DC" />
      <DA name="model" bType="VisString255" valKind="RO" fc="DC" />
      <DA name="location" bType="VisString255" valKind="RO" fc="DC" />
      <DA name="name" bType="VisString64" valKind="RO" fc="DC" />
      <DA name="dU" bType="Unicode255" valKind="RO" fc="DC" />
    </DOType>
    <DOType id="INS" cdc="INS">
      <DA name="stVal" bType="INT32" dchg="true" fc="ST" />
      <DA name="q" bType="Quality" qchg="true" fc="ST" />
      <DA name="t" bType="Timestamp" fc="ST" />
      <DA name="dU" bType="Unicode255" valKind="RO" fc="DC" />
    </DOType>
    <DOType id="SPS_PrivateDataNs_1" cdc="SPS">
      <DA name="stVal" bType="BOOLEAN" dchg="true" fc="ST" />
      <DA name="q" bType="Quality" qchg="true" fc="ST" />
      <DA name="t" bType="Timestamp" fc="ST" />
      <DA name="dU" bType="Unicode255" valKind="RO" fc="DC" />
      <DA name="dataNs" bType="VisString255" valKind="RO" fc="EX">
        <Val>RU61850:2017A</Val>
      </DA>
    </DOType>
    <DOType id="ENS_Health_PrivateDataNs" cdc="ENS">
      <DA name="stVal" bType="Enum" type="HealthKind" dchg="true" fc="ST" />
      <DA name="q" bType="Quality" qchg="true" fc="ST" />
      <DA name="t" bType="Timestamp" fc="ST" />
      <DA name="dU" bType="Unicode255" valKind="RO" fc="DC" />
      <DA name="dataNs" bType="VisString255" valKind="RO" fc="EX">
        <Val>RU61850:2017A</Val>
      </DA>
    </DOType>
    <DOType id="LPL" cdc="LPL">
      <DA name="vendor" bType="VisString255" valKind="RO" fc="DC">
        <Val>NPP Bresler</Val>
      </DA>
      <DA name="swRev" bType="VisString255" valKind="RO" fc="DC">
        <Val>v3</Val>
      </DA>
      <DA name="dU" bType="Unicode255" valKind="RO" fc="DC" />
      <DA name="configRev" bType="VisString255" valKind="RO" fc="DC">
        <Val>1</Val>
      </DA>
    </DOType>
    <DOType id="ENC_Mod_St" cdc="ENC">
      <DA name="stVal" bType="Enum" type="BehaviourModeKind" dchg="true" fc="ST" />
      <DA name="q" bType="Quality" qchg="true" fc="ST" />
      <DA name="t" bType="Timestamp" fc="ST" />
      <DA name="ctlModel" bType="Enum" valKind="RO" type="CtlModelKind" dchg="true" fc="CF">
        <Val>status-only</Val>
      </DA>
      <DA name="dU" bType="Unicode255" valKind="RO" fc="DC" />
    </DOType>
    <DOType id="INS_PrivateDataNs" cdc="INS">
      <DA name="stVal" bType="INT32" dchg="true" fc="ST" />
      <DA name="q" bType="Quality" qchg="true" fc="ST" />
      <DA name="t" bType="Timestamp" fc="ST" />
      <DA name="dU" bType="Unicode255" valKind="RO" fc="DC" />
      <DA name="dataNs" bType="VisString255" valKind="RO" fc="EX">
        <Val>NPP_BRESLER_1:2016</Val>
      </DA>
    </DOType>
    <DOType id="SPS_PrivateDataNs_2" cdc="SPS">
      <DA name="stVal" bType="BOOLEAN" dchg="true" fc="ST" />
      <DA name="q" bType="Quality" qchg="true" fc="ST" />
      <DA name="t" bType="Timestamp" fc="ST" />
      <DA name="dU" bType="Unicode255" valKind="RO" fc="DC" />
      <DA name="dataNs" bType="VisString255" valKind="RO" fc="EX">
        <Val>NPP_BRESLER_1:2016</Val>
      </DA>
    </DOType>
    <DOType id="ENG_SP_TriggerSourceKind" cdc="ENG">
      <DA name="setVal" bType="Enum" valKind="RO" type="TriggerSourceKind" dchg="true" fc="SP" />
      <DA name="dU" bType="Unicode255" valKind="RO" fc="DC" />
    </DOType>
    <DOType id="ING_SG" cdc="ING">
      <DA name="setVal" bType="INT32" valKind="RO" fc="SG" />
      <DA name="dU" bType="Unicode255" valKind="RO" fc="DC" />
    </DOType>
    <DOType id="ENG_SP_RecordingModeKind" cdc="ENG">
      <DA name="setVal" bType="Enum" valKind="RO" type="RecordingModeKind" dchg="true" fc="SP" />
      <DA name="dU" bType="Unicode255" valKind="RO" fc="DC" />
    </DOType>
    <DOType id="SAV_Amp" cdc="SAV">
      <DA name="instMag" bType="Struct" type="AnalogueValueSAV" fc="MX" />
      <DA name="q" bType="Quality" qchg="true" fc="MX" />
      <DA name="units" bType="Struct" valKind="RO" type="Unit_A" dchg="true" fc="CF" />
      <DA name="sVC" bType="Struct" valKind="RO" type="ScaledValueConfigSAVAmp" dchg="true" fc="CF" />
      <DA name="dU" bType="Unicode255" valKind="RO" fc="DC" />
    </DOType>
    <DOType id="SAV_Vol" cdc="SAV">
      <DA name="instMag" bType="Struct" type="AnalogueValueSAV" fc="MX" />
      <DA name="q" bType="Quality" qchg="true" fc="MX" />
      <DA name="units" bType="Struct" valKind="RO" type="Unit_V" dchg="true" fc="CF" />
      <DA name="sVC" bType="Struct" valKind="RO" type="ScaledValueConfigSAVVol" dchg="true" fc="CF" />
      <DA name="dU" bType="Unicode255" valKind="RO" fc="DC" />
    </DOType>
    <DAType id="OperateEnumMod">
      <BDA name="ctlVal" bType="Enum" type="BehaviourModeKind" />
      <BDA name="origin" bType="Struct" type="Originator" />
      <BDA name="ctlNum" bType="INT8U" />
      <BDA name="T" bType="Timestamp" />
      <BDA name="Test" bType="BOOLEAN" />
      <BDA name="Check" bType="Check" />
      <ProtNs>IEC 61850-8-1:2003</ProtNs>
    </DAType>
    <DAType id="Originator">
      <BDA name="orCat" bType="Enum" type="OriginatorCategoryKind" />
      <BDA name="orIdent" bType="Octet64" />
    </DAType>
    <DAType id="Operate">
      <BDA name="ctlVal" bType="BOOLEAN" />
      <BDA name="origin" bType="Struct" type="Originator" />
      <BDA name="ctlNum" bType="INT8U" />
      <BDA name="T" bType="Timestamp" />
      <BDA name="Test" bType="BOOLEAN" />
      <BDA name="Check" bType="Check" />
      <ProtNs>IEC 61850-8-1:2003</ProtNs>
    </DAType>
    <DAType id="AnalogueValueSAV">
      <BDA name="i" bType="INT32" />
    </DAType>
    <DAType id="Unit_A">
      <BDA name="SIUnit" bType="Enum" valKind="RO" type="SIUnitKind">
        <Val>A</Val>
      </BDA>
    </DAType>
    <DAType id="ScaledValueConfigSAVAmp">
      <BDA name="scaleFactor" bType="FLOAT32" valKind="RO">
        <Val>0.001</Val>
      </BDA>
      <BDA name="offset" bType="FLOAT32" valKind="RO">
        <Val>0</Val>
      </BDA>
    </DAType>
    <DAType id="Unit_V">
      <BDA name="SIUnit" bType="Enum" valKind="RO" type="SIUnitKind">
        <Val>V</Val>
      </BDA>
    </DAType>
    <DAType id="ScaledValueConfigSAVVol">
      <BDA name="scaleFactor" bType="FLOAT32" valKind="RO">
        <Val>0.01</Val>
      </BDA>
      <BDA name="offset" bType="FLOAT32" valKind="RO">
        <Val>0</Val>
      </BDA>
    </DAType>
    <EnumType id="BehaviourModeKind">
      <EnumVal ord="1">on</EnumVal>
      <EnumVal ord="2">blocked</EnumVal>
      <EnumVal ord="3">test</EnumVal>
      <EnumVal ord="4">test/blocked</EnumVal>
      <EnumVal ord="5">off</EnumVal>
    </EnumType>
    <EnumType id="HealthKind">
      <EnumVal ord="1">Ok</EnumVal>
      <EnumVal ord="2">Warning</EnumVal>
      <EnumVal ord="3">Alarm</EnumVal>
    </EnumType>
    <EnumType id="OriginatorCategoryKind">
      <EnumVal ord="0">not-supported</EnumVal>
      <EnumVal ord="1">bay-control</EnumVal>
      <EnumVal ord="2">station-control</EnumVal>
      <EnumVal ord="3">remote-control</EnumVal>
      <EnumVal ord="4">automatic-bay</EnumVal>
      <EnumVal ord="5">automatic-station</EnumVal>
      <EnumVal ord="6">automatic-remote</EnumVal>
      <EnumVal ord="7">maintenance</EnumVal>
      <EnumVal ord="8">process</EnumVal>
    </EnumType>
    <EnumType id="CtlModelKind">
      <EnumVal ord="0">status-only</EnumVal>
      <EnumVal ord="1">direct-with-normal-security</EnumVal>
      <EnumVal ord="2">sbo-with-normal-security</EnumVal>
      <EnumVal ord="3">direct-with-enhanced-security</EnumVal>
      <EnumVal ord="4">sbo-with-enhanced-security</EnumVal>
    </EnumType>
    <EnumType id="TriggerSourceKind">
      <EnumVal ord="1">Internal</EnumVal>
      <EnumVal ord="2">External</EnumVal>
      <EnumVal ord="3">Both</EnumVal>
    </EnumType>
    <EnumType id="RecordingModeKind">
      <EnumVal ord="1">Overwrite existing values</EnumVal>
      <EnumVal ord="2">Stop when full or saturated</EnumVal>
    </EnumType>
    <EnumType id="SIUnitKind">
      <EnumVal ord="1" />
      <EnumVal ord="2">m</EnumVal>
      <EnumVal ord="3">kg</EnumVal>
      <EnumVal ord="4">s</EnumVal>
      <EnumVal ord="5">A</EnumVal>
      <EnumVal ord="6">K</EnumVal>
      <EnumVal ord="7">mol</EnumVal>
      <EnumVal ord="8">cd</EnumVal>
      <EnumVal ord="9">deg</EnumVal>
      <EnumVal ord="10">rad</EnumVal>
      <EnumVal ord="11">sr</EnumVal>
      <EnumVal ord="21">Gy</EnumVal>
      <EnumVal ord="22">Bq</EnumVal>
      <EnumVal ord="23">°C</EnumVal>
      <EnumVal ord="24">Sv</EnumVal>
      <EnumVal ord="25">F</EnumVal>
      <EnumVal ord="26">C</EnumVal>
      <EnumVal ord="27">S</EnumVal>
      <EnumVal ord="28">H</EnumVal>
      <EnumVal ord="29">V</EnumVal>
      <EnumVal ord="30">ohm</EnumVal>
      <EnumVal ord="31">J</EnumVal>
      <EnumVal ord="32">N</EnumVal>
      <EnumVal ord="33">Hz</EnumVal>
      <EnumVal ord="34">lx</EnumVal>
      <EnumVal ord="35">Lm</EnumVal>
      <EnumVal ord="36">Wb</EnumVal>
      <EnumVal ord="37">T</EnumVal>
      <EnumVal ord="38">W</EnumVal>
      <EnumVal ord="39">Pa</EnumVal>
      <EnumVal ord="41">m²</EnumVal>
      <EnumVal ord="42">m³</EnumVal>
      <EnumVal ord="43">m/s</EnumVal>
      <EnumVal ord="44">m/s²</EnumVal>
      <EnumVal ord="45">m³/s</EnumVal>
      <EnumVal ord="46">m/m³</EnumVal>
      <EnumVal ord="47">M</EnumVal>
      <EnumVal ord="48">kg/m³</EnumVal>
      <EnumVal ord="49">m²/s</EnumVal>
      <EnumVal ord="50">W/m K</EnumVal>
      <EnumVal ord="51">J/K</EnumVal>
      <EnumVal ord="52">ppm</EnumVal>
      <EnumVal ord="53">1/s</EnumVal>
      <EnumVal ord="54">rad/s</EnumVal>
      <EnumVal ord="61">VA</EnumVal>
      <EnumVal ord="62">Watts</EnumVal>
      <EnumVal ord="63">VAr</EnumVal>
      <EnumVal ord="64">phi</EnumVal>
      <EnumVal ord="65">cos(phi)</EnumVal>
      <EnumVal ord="66">Vs</EnumVal>
      <EnumVal ord="67">V²</EnumVal>
      <EnumVal ord="68">As</EnumVal>
      <EnumVal ord="69">A²</EnumVal>
      <EnumVal ord="70">A²t</EnumVal>
      <EnumVal ord="71">VAh</EnumVal>
      <EnumVal ord="72">Wh</EnumVal>
      <EnumVal ord="73">VArh</EnumVal>
      <EnumVal ord="74">V/Hz</EnumVal>
      <EnumVal ord="75">Hz/s</EnumVal>
      <EnumVal ord="76">char</EnumVal>
      <EnumVal ord="77">char/s</EnumVal>
      <EnumVal ord="78">kgm²</EnumVal>
      <EnumVal ord="79">dB</EnumVal>
      <EnumVal ord="80">J/Wh</EnumVal>
      <EnumVal ord="81">W/s</EnumVal>
      <EnumVal ord="82">l/s</EnumVal>
      <EnumVal ord="83">dBm</EnumVal>
      <EnumVal ord="84">h</EnumVal>
      <EnumVal ord="85">min</EnumVal>
    </EnumType>
  </DataTypeTemplates>
</SCL>