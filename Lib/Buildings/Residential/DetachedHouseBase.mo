within Lib.Buildings.Residential;

model DetachedHouseBase
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
  //components
  //connectors
  //variables
  //eod
equation
end DetachedHouseBase;