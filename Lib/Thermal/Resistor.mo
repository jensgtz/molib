within Lib.Thermal;

model Resistor
  extends Lib.Thermal.TwoPort;
  //parameters
  parameter Real R = 1 "Waermeleitwiderstand / thermal resistance [K/W]";
  //components
  //connectors
  //variables
  //eod
equation
  dT = R * Q_flow;
end Resistor;