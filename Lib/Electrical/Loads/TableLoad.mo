within Lib.Electrical.Loads;

/*
<DOC>
TODO: clock / utc / synchron !!!
</DOC>
*/

model TableLoad
  extends Lib.Electrical.EMS_Device;

  //parameters
  parameter String tableName = "load" "Tabellenname";
  parameter String tablePath = "./data/2P1K-1000.mo.txt" "Dateipfad";
  parameter Real E_a = 1000 "Jahresenergieverbrauch [kWh]";

  //components
  Modelica.Blocks.Tables.CombiTable1D load(tableOnFile = true, tableName = tableName, fileName = tablePath, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative) "Lastgang";

  //connectors

  //variables

  //eod

equation
  load.u[1] = time;
  P_el = load.y[1] * E_a / 1000;

  //EMS
  P_el_pos = 0;
  P_el_neg = 0;
  K_el_pos = 1;
  K_el_neg = 1;
 
end TableLoad;