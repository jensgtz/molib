within Lib.Buildings;

model StdBuilding
  //parameters
  parameter Real A = 1 "area [m2]";
  //components
  Lib.Buildings.Elements.Room room1();
  Lib.Buildings.Elements.Room room2();
  Lib.Buildings.Elements.Room room3();
  //connectors
  //variables
  Real Q_sum "heat [kWh]";
  Real y;
  //eod
equation
  Q_sum = room1.Q_sum + room2.Q_sum + room3.Q_sum;
  y = time;
end StdBuilding;