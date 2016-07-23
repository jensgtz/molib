within Lib.Buildings.Residential;

model Test1
  //parameters
  parameter Real R_cond_wall = wall.R_cond;
  //components
  Lib.Buildings.Elements.Wall wall(A=100);
  Lib.Thermal.TableTemperature ext;
  Lib.Thermal.ConstantTemperature int(T=293.15);
  //connectors
  //variables
  Real Q(start=0, fixed=true) "heat [kWh]";
  //eod
equation
  connect(int.hp, wall.hp1);
  connect(wall.hp2, ext.hp);
  der(Q) = abs(wall.hp1.Q_flow / 1000);
end Test1;