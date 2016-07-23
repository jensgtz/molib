within Lib.Buildings.Residential;

/*
<DOC>
Einfamilienhaus
- 2 Vollgeschosse (EG, OG)
- unbeheizter Keller
- unbeheizter Spitzboden
- Satteldach mit Ost- und West-Dachflaechen
</DOC>
*/

model EFH1
  //parameters
  parameter Real L_x = 8.31 "x-Laenge [m]";
  parameter Real L_y = 7.05 "y-Laenge [m]";
  parameter Real D_wb = 0.48 "d wall basement [m]";
  parameter Real D_wgf = 0.39 "d wall ground floor [m]";
  parameter Real D_wuf = 0.36 "d wall upper floor [m]";
  parameter Real D_wa = 0.36 "d wall attic [m]";
  parameter Real H_r = 8.58 "abs h ridge / Firsthoehe [m]";
  parameter Real H_e = 5.83 "abs h eaves / Traufhoehe [m]";
  parameter Real H_gf_0 = 1.00 "Hoehe EG ueber Gelaende [m]";
  parameter Real h_gf = 3.15 "EG Hoehe [m]";
  parameter Real h_gf_net = 2.80 "EG Hoehe, netto [m]";
  parameter Real h_uf = 2.83 "OG Hoehe [m]";
  parameter Real h_uf_net = 2.53 "OG Hoehe, netto [m]";
  //
  parameter Real h_r1 = H_r - H_e;
  parameter Real h_r2 = h_uf + h_gf + H_gf_0 - H_e;
  parameter Real l_r1 = sqrt((H_r-H_e)^2 + (L_x/2)^2);
  parameter Real l_r2 = l_r1 * h_r2 / h_r1;
  parameter Real l_r3 = (1 - l_r2/l_r1) * L_x;
  //
  parameter Real A_roof = 2 * l_r2 * L_y;
  parameter Real A_ceiling = l_r3 * L_y;
  parameter Real A_wall_uf = 2 * h_uf * (L_x + L_y);
  parameter Real A_wall_gf = 2 * h_gf * (L_x + L_y);
  parameter Real A_floor = L_x * L_y;
  //
  parameter Integer roof_cid = 17;
  parameter Integer ceiling_cid = 18;
  parameter Integer wall_uf_cid = 2;
  parameter Integer wall_gf_cid = 4;
  parameter Integer floor_cid = 20;

  //components
  Lib.Buildings.Elements.Roof roof(A=A_roof, construction_id=roof_cid);
  Lib.Buildings.Elements.Ceiling ceiling(A=A_ceiling, construction_id=ceiling_cid);
  Lib.Buildings.Elements.Wall wall_uf(A=A_wall_uf, construction_id=wall_uf_cid);
  Lib.Buildings.Elements.Wall wall_gf(A=A_wall_gf, construction_id=wall_gf_cid);
  Lib.Buildings.Elements.Floor floor(A=A_floor, construction_id=floor_cid);
  //
  Lib.Buildings.Elements.Windows win_gf_n(Azimuth=0, N=0, Ai=1.2, construction_id=14);
  Lib.Buildings.Elements.Windows win_gf_e(Azimuth=90, N=0, Ai=1.2, construction_id=14);
  Lib.Buildings.Elements.Windows win_gf_s(Azimuth=180, N=0, Ai=1.2, construction_id=14);
  Lib.Buildings.Elements.Windows win_gf_w(Azimuth=270, N=0, Ai=1.2, construction_id=14);
  Lib.Buildings.Elements.Windows widows_gf(N=4, Ai=1.2, construction_id=14);
  //
  Lib.Thermal.ConstantTemperature cellar_temp(T=283.15);
  Lib.Thermal.ConstantTemperature inner_temp(T=293.15);

  //connectors
  Lib.Thermal.Interfaces.HeatPort hp_int;
  Lib.Thermal.Interfaces.HeatPort hp_ext;

  //variables
  Real Q_flow;
  Real Q_balance(start=0, fixed=true) "heat balance [kWh]";
  Real Q_heating(start=0, fixed=true);
  Real Q_cooling(start=0, fixed=true);

  //eod

equation
  connect(hp_int, floor.hp1);
  connect(hp_int, wall_gf.hp1);
  connect(hp_int, wall_uf.hp1);
  connect(hp_int, ceiling.hp1);
  connect(hp_int, roof.hp1);
  //
  connect(floor.hp2, cellar_temp.hp);
  connect(wall_gf.hp2, hp_ext);
  connect(wall_uf.hp2, hp_ext);
  connect(ceiling.hp2, hp_ext);
  connect(roof.hp2, hp_ext);
  //
  connect(hp_int, inner_temp.hp);

  Q_flow = roof.Q_flow + ceiling.Q_flow + wall_uf.Q_flow + wall_gf.Q_flow + floor.Q_flow;
  der(Q_balance) = Q_flow / 1000;
  Q_heating = roof.Q_pos + ceiling.Q_pos + wall_uf.Q_pos + wall_gf.Q_pos + floor.Q_pos;
  Q_cooling = roof.Q_neg + ceiling.Q_neg + wall_uf.Q_neg + wall_gf.Q_neg + floor.Q_neg;
end EFH1;