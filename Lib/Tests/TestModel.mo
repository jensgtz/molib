within Lib.Tests;

model TestModel
  //parameters
  parameter Integer ID = 1 "TestID (Dummy) [-]";
  //components
  Lib.Meteo.SoilTemperature w(T_start=273.15);
  Lib.Thermal.ConstantTemperature t1(T=293.15);
  //connectors
  //variables
  //eod

equation
  connect(t1.hp, w.hp_air);

end TestModel;