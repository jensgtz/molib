within Lib.Thermal;

model TableTemperature
  //parameters
  parameter String tableName = "air_temperature";
  parameter String tablePath = "./data/TRY/TRY2010_04_Jahr/air_temperature.txt";
  parameter Real Offset = 273.15 "Offset [K]";
  //components
  Modelica.Blocks.Tables.CombiTable1D air_temperature(tableOnFile = true, tableName = tableName, fileName = tablePath, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative);
  //connectors
  Lib.Thermal.Interfaces.HeatPort hp;
  //variables
  Real T_deg "temperature [degC]";
  //eod
equation
  air_temperature.u[1] = time;
  T_deg = air_temperature.y[1];
  hp.T = Offset + T_deg;
end TableTemperature;