within Lib.Meteo;

/*
<DOC>
Wasserdampfgehalt / Mischungsverhaeltnis (TRY-Datenquelle)

TRY: [g/kg]
output: [kg/kg]
</DOC>
*/

model TRY_AbsHumidity
  //parameters
  parameter String tableName = "abs_humidity";
  parameter String tablePath = "./data/TRY/TRY2010_04_Jahr/abs_humidity.txt";
  //components
  Modelica.Blocks.Tables.CombiTable1D abs_humidity(tableOnFile = true, tableName = tableName, fileName = tablePath, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative);
  //connectors
  Lib.RealOutput x_air "abs. Luftfeuchte [kg/kg]";
  //variables
  //eod
equation
  abs_humidity.u[1] = time;
  x_air = abs_humidity.y[1] / 1000;
end TRY_AbsHumidity;