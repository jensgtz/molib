within Lib.Buildings.HotWater;

/*
<DOC>
VDI 4656:2013 S.46:
- "Gemaesz den Angaben in VDI 4655 wird der jaehrli- 
   che thermische Energiebedarf zur Trinkwasserer- 
   waermung wie folgt angenommen: 
    • 500 kWh/Pers. im Einfamilienhaus 
    • 1000 kWh/WE im Mehrfamilienhaus"

VDI 4655:2008, S. 30 ff.
- Referenzlastprofile fuer zehn Typtagkategorien 
      http://ba.localhost/img/Documentation/Buildings/HotWater/TableLoad_VDI4655/Typtage%20-%20VDI%204655.png

DIN V 18599-10 - Nutzungsprofile Wohngebaeude:
- Q_a = [11 kWh/(m2*a)] * A_N (A_N ... Gebaeudenutzflaeche)


---VALID---
http://crm.saena.de/sites/default/files/civicrm/persist/contribute/files/05_Stromspeicherung_Foerderung.pdf#page=20&zoom=110,-178,533
</DOC>
*/

model TableLoad_VDI4655

  //parameters
  parameter String tablePath = "./data/TRY04_1500kWh_3Pers_HWLP.txt" "Datei-Pfad";
  parameter Boolean useHWS = true "zentrale Warmwasserversorgung nutzen ja/nein [-]";

  //calculated
  parameter Real f_hws = if useHWS then 1 else 0 "Nutzung der zentralen TWW-Versorgung [1]";
  parameter Real f_dhw = if not(useHWS) then 1 else 0 "Nutzung der dezentralen TWW-Versorgung [1]";

  //components
  Modelica.Blocks.Tables.CombiTable1D table(tableOnFile = true, tableName = "hwload", fileName = tablePath, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative) "Lastgang [W]"; 

  //connectors
  Lib.Thermal.Interfaces.HeatPort hp_dhw "dezentrale Warmwasserbereitung";
  Lib.Thermal.Interfaces.HeatPort hp_hws "Waermespeicher";

  //variables
  Real P_th "Nutzwaermestrom [W]";
  Real E_th(start=0, fixed=true) "Nutzwaerme [kWh]";

  //eod

equation
  table.u[1] = time;
  P_th = table.y[1];
  der(E_th) = P_th / 1000;
  hp_hws.Q_flow = f_hws * P_th;
  hp_dhw.Q_flow = f_dhw * P_th;

end TableLoad_VDI4655;