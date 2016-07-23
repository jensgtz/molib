within Lib.Thermal;

model ConstantTemperature
  //parameters
  parameter Real T = 293.15 "temperature [K]";
  parameter Real T_deg = T - 273.15 "temperature [degC]";
  //components
  //connectors
  Lib.Thermal.Interfaces.HeatPort hp;
  //variables
  //eod
equation
  hp.T = T;
end ConstantTemperature;