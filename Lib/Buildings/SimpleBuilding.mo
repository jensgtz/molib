within Lib.Buildings;

model SimpleBuilding
  //parameters
  parameter Real L = 10;
  parameter Real B = 10;
  parameter Real H = 5;
  parameter Real T_i = 20;
  parameter Real T_a = 8.5;
  //components
  Lib.Buildings.Elements.Wall n_wall(A=B*H);
  Lib.Buildings.Elements.Wall e_wall(A=L*H);
  Lib.Buildings.Elements.Wall s_wall(A=B*H);
  Lib.Buildings.Elements.Wall w_wall(A=L*H);
  //connectors
  //variables
  Real Q_dot;
  Real Q_sum(start=0);
  //eod
equation
  Q_dot = (n_wall.A*n_wall.U+ e_wall.A*e_wall.U+ s_wall.A*s_wall.U+ w_wall.A*w_wall.U) * (T_i - T_a);
  der(Q_sum) = Q_dot;
end SimpleBuilding;