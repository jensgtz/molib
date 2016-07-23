within Lib.Buildings.Elements;

model Room
  //parameters
  parameter Real A = 10 "area [m2]";
  parameter Real H = 2.5 "height [m]";
  //components
  Lib.Buildings.Elements.Wall wall1();
  Lib.Buildings.Elements.Wall wall2();
  Lib.Buildings.Elements.Wall wall3();
  Lib.Buildings.Elements.Wall wall4();
  Lib.Buildings.Elements.Floor floor();
  Lib.Buildings.Elements.Ceiling ceiling();
  //connectors
  //variables
  Real Q_sum;
  //eod
equation
  Q_sum = time;
end Room;