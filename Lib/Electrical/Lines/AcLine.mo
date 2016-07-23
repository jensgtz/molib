within Lib.Electrical.Lines;

model AcLine
  Lib.Electrical.Interfaces.AcPower ac1;
  Lib.Electrical.Interfaces.AcPower ac2;
equation
  ac1.f = ac2.f;
  ac1.p + ac2.p = 0;
end AcLine;