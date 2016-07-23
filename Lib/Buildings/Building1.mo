within Lib.Buildings;

/*
<DOC>
//Lib.Buildings.Wall wall_n(rect = Lib.Geom.Rect(x1 = 0, y1 = Ly, z1 = 0, x2 = Lx, y2 = Ly, z2 = H_eaves), A = Lx * H_eaves, d = d_wall, U = U_wall);
  //Lib.Buildings.Wall wall_e(rect = Lib.Geom.Rect(x1 = Lx, y1 = 0, z1 = 0, x2 = Lx, y2 = Ly, z2 = H_eaves), A = Ly * H_eaves, d = d_wall, U = U_wall);
  //Lib.Buildings.Wall wall_s(rect = Lib.Geom.Rect(x1 = 0, y1 = 0, z1 = 0, x2 = Lx, y2 = 0, z2 = H_eaves), A = Lx * H_eaves, d = d_wall, U = U_wall);
  //Lib.Buildings.Wall wall_w(rect = Lib.Geom.Rect(x1 = 0, y1 = 0, z1 = 0, x2 = 0, y2 = Ly, z2 = H_eaves), A = Ly * H_eaves, d = d_wall, U = U_wall);
  //Lib.Buildings.Wall wall_n2();
  //Lib.Buildings.Wall wall_s2();
  //Lib.Buildings.Roof roof_e(A = Ly * sqrt((H_ridge - H_eaves) ^ 2 + (Lx / 2) ^ 2), U = 2.03);
  //Lib.Buildings.Roof roof_w(A = Ly * sqrt((H_ridge - H_eaves) ^ 2 + (Lx / 2) ^ 2), U = 2.03);
  //
  //Lib.Thermal.ConstantTemperature outside_temperature(T = 263.15);
</DOC>
*/

model Building1
  //parameters
  parameter Real Lx = 7.05 "Laenge x-Achse [m]";
  parameter Real Ly = 8.31 "Laenge y-Achse [m]";
  parameter Real Hz = 8 "Hoehe [m]";
  parameter Real H_stage = 2.5 "Geschosshoehe [m]";
  parameter Real H_ridge = 7.00 "First-Hoehe [m]";
  parameter Real H_eaves = 5.00 "Trauf-Hoehe [m]";
  parameter Real T_inside = 293.15 "inside temperature [K]";
  parameter Real d_wall = 0.36 "wall thickness [m]";
  parameter Real U_wall = 1.5 "wall's specific heat conductivity [W/(m2*K)]";
  parameter Real x_inside_walls = 0.05 "innerwall ratio [1]";
  parameter Real V = Lx * Ly * Hz "[m3]";
  parameter Real V_inside = V - (2 * Lx + 2 * Ly) * Hz * d_wall "[m3]";
  parameter Real V_inside_walls = x_inside_walls * V_inside "[m3]";
  parameter Real V_inside_air = (1 - x_inside_walls) * V_inside "[m3]";
  //components
  Lib.Buildings.Elements.Wall wall_n(A = Lx * H_eaves, d = d_wall, U = U_wall);
  Lib.Buildings.Elements.Wall wall_e(A = Ly * H_eaves, d = d_wall, U = U_wall);
  Lib.Buildings.Elements.Wall wall_s(A = Lx * H_eaves, d = d_wall, U = U_wall);
  Lib.Buildings.Elements.Wall wall_w(A = Ly * H_eaves, d = d_wall, U = U_wall);

  Lib.Buildings.Elements.Floor attic;
  Lib.Buildings.Elements.Floor upper_floor;
  Lib.Buildings.Elements.Floor ground_floor;
  Lib.Buildings.Elements.Floor basement;

  Lib.Thermal.Capacity inside_walls(V = V_inside_walls, rho = 1600, cp = 1.000, T_start = T_inside);
  Lib.Thermal.Capacity inside_air(V = V_inside_air, rho = 1.23, cp = 1.008, T_start = T_inside);

  Lib.Thermal.ConstantTemperature inside_temperature(T = T_inside);
  Lib.Thermal.TableTemperature outside_temperature;
  //connectors
  //variables
  Real Q_flow "Gesamtwaermefluss [kWh]";
  Real Q(start = 0);
  Real Q_kWh(start = 0);
  //eod
equation
  connect(outside_temperature.heatport, wall_n.outside_heatport);
  connect(outside_temperature.heatport, wall_e.outside_heatport);
  connect(outside_temperature.heatport, wall_s.outside_heatport);
  connect(outside_temperature.heatport, wall_w.outside_heatport);
  connect(inside_temperature.heatport, wall_n.inside_heatport);
  connect(inside_temperature.heatport, wall_e.inside_heatport);
  connect(inside_temperature.heatport, wall_s.inside_heatport);
  connect(inside_temperature.heatport, wall_w.inside_heatport);
  connect(inside_temperature.heatport, inside_walls.heatport);
  connect(inside_temperature.heatport, inside_air.heatport);
  Q_flow = wall_n.Q_flow + wall_e.Q_flow + wall_s.Q_flow + wall_w.Q_flow;
  der(Q) = Q_flow;
  Q_kWh = Q / 1000;
end Building1;