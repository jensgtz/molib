within Lib.Electrical;

model AcDummy
  //parameters
  //components
  //connectors
  Lib.Electrical.Interfaces.AcPower ac "AC";
  //variables
  //eod
equation
  ac.p = 0;
end AcDummy;