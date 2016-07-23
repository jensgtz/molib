within Lib.Electrical.Loads;

model ConstantLoad
  parameter Real P "power [W]";
  Lib.Electrical.Interfaces.AcPower ac;
equation
  ac.p = P;
end ConstantLoad;