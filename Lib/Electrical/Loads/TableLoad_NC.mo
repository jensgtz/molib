within Lib.Electrical.Loads;

/*
<DOC>
VDI 4656:2013, S. 46 (Planung und Dimensionierung von Mikro-KWK-Anlagen)
- elektrischer Energiebedarf: 1750 kWh/Pers. bei 3 bis 6 Personen 
  -> 5250 kWh/a bei 3 Pers. und 7000 kWh/a bei 4 Pers.
</DOC>
*/

model TableLoad_NC

  //parameters
  parameter String tableName = "load" "Tabellenname";
  parameter String tablePath = "./data/2P1K-1000.mo.txt" "Dateipfad";
  parameter Real E_a = 1000 "Jahresenergieverbrauch [kWh]";
  parameter Real f = 1 "linearer Anpassungsfaktor der Leistng [1]";

  //components
  Modelica.Blocks.Tables.CombiTable1D load(tableOnFile = true, tableName = tableName, fileName = tablePath, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative) "Lastgang";

  //connectors
  Lib.Electrical.Interfaces.AcPower ac;

  //variables
  Real P_el "el. Leistung [W]";
  Real E_el(start=0, fixed=true) "el. Energie [kWh]";

  //eod

equation
  load.u[1] = time;
  P_el = max(0, f * (load.y[1] * E_a / 1000));
  der(E_el) = P_el / 1000;
  ac.p = P_el;

end TableLoad_NC;