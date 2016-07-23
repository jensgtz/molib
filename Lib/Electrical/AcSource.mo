within Lib.Electrical;

model AcSource
  //parameters
  //components
  //connectors
  Lib.Electrical.Interfaces.AcPower ac "AC-Knoten";
  Lib.RealInput P_set "Soll-Leistung [W]";
  //variables
  //eod
equation
  ac.p = -P_set;
end AcSource;