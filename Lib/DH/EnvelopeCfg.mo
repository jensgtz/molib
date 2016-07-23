within Lib.DH;

record EnvelopeCfg
  //parameters
  parameter Real L_x = 8.31 "x-Laenge (Ost-West) [m]";
  parameter Real L_y = 7.05 "y-Laenge (Nord-Sued) [m]";
  parameter Real L_xi = 7.05-0.38 "x-Innenmasz (Ost-West) [m]";
  parameter Real L_yi = 7.05-0.38 "y-Innenmasz (Nord-Sued) [m]";
  parameter Real H_r = 8.58 "Firsthoehe [m]";
  parameter Real H_e = 5.83 "Traufhoehe [m]";
  parameter Real H_bm = 2.30 "Hoehe KG [m]";
  parameter Real H_bm_i = 1.95 "Raumhoehe KG [m]";
  parameter Real H_gf_0 = 1.00 "Hoehe EG ueber Gelaende [m]";
  parameter Real H_gf = 3.15 "Geschosshoehe EG [m]";
  parameter Real H_gf_i = 2.80 "Raumhoehe EG [m]";
  parameter Real H_uf = 2.83 "Geschosshoehe OG [m]";
  parameter Real H_uf_i = 2.53 "Raumhoehe OG [m]";
  parameter Real D_roof = 0.20 "Staerke der Dachkonstruktion [m]";
  parameter Real phi_roof_deg = 32 " Dachneigung [deg]"; 
  parameter Real azimuth = 0 "Ausrichtung [deg]";
  //components
end EnvelopeCfg;