within Lib.DH;

/*
<DOC>
azimuth: Ausrichtung / Abweichung von Nord im Uhrzeigersinn
  0deg: Nordwand (wall_n) zeit nach Norden
  90deg: Nordwand (wall_n) zeigt nach Osten usw.

hp_ext: Auszenluft-Knoten
</DOC>
*/

model Envelope2
  import Modelica.Math.tan;
  import Modelica.Math.sin;
  import Modelica.Constants.pi;

  //parameters
  parameter Real L_x = 8.31 "x-Laenge (Ost-West) [m]";
  parameter Real L_y = 7.05 "y-Laenge (Nord-Sued) [m]";
  parameter Real L_xi = 8.31 - 2*0.375 "x-Innenmasz (Ost-West) [m]";
  parameter Real L_yi = 7.05 - 2*0.375 "y-Innenmasz (Nord-Sued) [m]";
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
  parameter Real n_50_ur = 4 "nat. Luftwechsel, unsaniert [1/h]";
  //
  parameter Real H_uf_i2 = H_e - H_gf_0 - H_gf "Unterkante Dachschraege OG, rel. [m]";
  parameter Real L_uf_xi2 = L_xi - 2 * ((H_uf_i-H_uf_i2)/tan(phi_roof_deg / 180 * pi)) "x-Innenmasz ohne Dachschraege OG [m]";
  parameter Real L_at_x = (H_r - H_uf - H_gf - H_gf_0) / (H_r - H_e) * L_x "x-Auszenmasz SB-Unterkante [m]";
  parameter Real L_at_xi = L_at_x - 2 * (D_roof / sin(phi_roof_deg / 180 * pi)) "x-Innenmasz SB-Unterkante [m]";
  parameter Real H_at = H_r - H_uf - H_gf - H_gf_0 "Hoehe Spitzboden [m]";
  parameter Real H_at_i = H_at - (D_roof / sin(phi_roof_deg / 180 * pi)) "Innenhoehe SB [m]";
  //
  parameter Real X_refurb_building = (basement.X_refurb + groundfloor.X_refurb + upperfloor.X_refurb + attic.X_refurb) / 4 "Sanierungszustand Gebaeude [1]";
  parameter Real X_refurb_gfuf = (groundfloor.X_refurb + upperfloor.X_refurb) / 2 "Sanierungszustand EG und OG [1]";
  parameter Real X_refurb_gfuf_eff = (X_refurb_building + X_refurb_gfuf) / 2 "eff. Sanierungszustand EG+OG (Infiltration)[1]";
  //
  parameter Real A_HT =  attic.A_HT + upperfloor.A_HT + groundfloor.A_HT + basement.A_HT;
  parameter Real HT =  attic.HT + upperfloor.HT + groundfloor.HT + basement.HT;
  parameter Real H_T = HT / A_HT "spezifischer Transmissionswaermeverlust [W/(m2*K)]";
  //
  parameter Real A_ngf = basement.A_i_eff + groundfloor.A_i_eff + upperfloor.A_i_eff + attic.A_i_eff "Nettogrundflaeche [m2]";

  parameter Real A_ngf_h = groundfloor.A_i_eff + upperfloor.A_i_eff "Nettogrundflaeche, beheizt [m2]";
  parameter Real V_i_h = groundfloor.V_i_eff + upperfloor.V_i_eff "Nettoinnenvolumen, beheizt [m3]";
  parameter Real V_e = groundfloor.V_eff + upperfloor.V_eff "Gebaeudevolumen, beheizt [m3]";
  parameter Real A_n = 0.32 * V_e "Gebaeudenutzflaeche [m2]";
 
  //components
  Lib.Buildings.Floors.Attic2 attic(L_x=L_at_x, L_y=L_y, H=H_at, L_xi=L_at_xi, L_yi=L_yi, H_i=H_at_i, phi_roof_deg=phi_roof_deg, X_refurb_building=X_refurb_building, n_50_ur=n_50_ur) "Spitzboden";
  Lib.Buildings.Floors.UpperFloor2 upperfloor(L_x=L_x, L_y=L_y, H=H_uf, L_xi=L_xi, L_yi=L_yi, H_i=H_uf_i, L_xi2=L_uf_xi2, H_i2=H_uf_i2, X_refurb_building=X_refurb_building, n_50_ur=n_50_ur) "Obergeschoss";
  Lib.Buildings.Floors.GroundFloor2 groundfloor(L_x=L_x, L_y=L_y, H=H_gf, L_xi=L_xi, L_yi=L_yi, H_i=H_gf_i, X_refurb_building=X_refurb_building, n_50_ur=n_50_ur) "Erdgeschoss";
  Lib.Buildings.Floors.Basement2 basement(L_x=L_x, L_y=L_y, H=H_bm, L_xi=L_xi, L_yi=L_yi, H_i=H_bm_i, X_refurb_building=X_refurb_building, n_50_ur=n_50_ur) "Kellergeschoss";
  //
  Lib.Buildings.EnergyBalance.InternalHeatGains heatgains(A_ngf=A_ngf_h) "Waermegewinne";
  Lib.Buildings.Ventilation.NaturalVentilation nat_ventilation(V_i=V_i_h, n_50_ur=n_50_ur, X_refurb=X_refurb_gfuf_eff, n_min=0.5) "natuerliche Lueftung";

  //connectors
  Lib.Thermal.Interfaces.HeatPort hp_at "Spitzboden";
  Lib.Thermal.Interfaces.HeatPort hp_gfuf "beheizte Zone";
  Lib.Thermal.Interfaces.HeatPort hp_bm "Kellergeschoss";
  Lib.Thermal.Interfaces.HeatPort hp_ext "Auszenluft";
  Lib.Thermal.Interfaces.HeatPort hp_soil1 "Erdreich 1m";
  Lib.Thermal.Interfaces.HeatPort hp_soil2 "Erdreich 2m";
  Lib.RealOutput P_tsr_gfuf;
  Lib.RealOutput T_air_deg "Raumlufttemperatur EG+OG [degC]";
  Lib.RealOutput T_op_deg "Mittelwert operative Raumtemperatur EG und OG [degC]";
  Lib.RealInput x_air_ext "Wasserdampfgehalt Auszenluft [kg/kg]";
  Lib.RealInput n_vsys "Luftwechselrate Lueftungsanlage [1/h]";
  Lib.RealOutput n_nat "Luftwechselrate natuerliche Lueftung [1/h]";

  //variables
  Real TC_mean "Mittelwert der thermischen Behaglichkeit, aktuell [1]";
  Real TC_balance_mean "Mittelwert der kumulierten thermischen Behaglichkeit [1]";
  Real TC_final(start=0, fixed=true) "Mittelwert der thermischen Behaglichkeit, Simulation [1]";
  Real f_utgs(start=0) "Faktor zur Ermittlung der Uebergradstunden [1]";
  Real utgs(start=0, fixed=true) "Uebergradstunden bezogen auf 20degC [Kh]";
  //
  Real Qf_roof_ls "WV Dach [W]";
  Real Q_roof_ls(start=0, fixed=true) "WV Dach [kWh]";
  Real Q_roof_w(start=0, fixed=true) "WG Dach [kWh]";
  Real Qf_wall_ls "WV AW [W]";
  Real Q_wall_ls(start=0, fixed=true) "WV AW [kWh]";
  Real Q_wall_w(start=0, fixed=true) "WG AW [kWh]";
  Real Qf_win_ls "WV WIN [W]";
  Real Q_win_ls(start=0, fixed=true) "WV WIN [kWh]";
  Real Q_win_w(start=0, fixed=true) "WG WIN [kWh]";
  Real Qf_bfloor_ls "WV KGB [W]";
  Real Q_bfloor_ls(start=0, fixed=true) "WV KGB [kWh]";
  Real Q_bfloor_w(start=0, fixed=true) "WG KGB [kWh]";
  Real Qf_cc_ls "WVH gesamt [W]";
  Real Q_cc_ls "WVH gesamt [kWh]";
  Real Q_cc_w "WGH gesamt [kWh]";
  Real Q_cc "WBH gesamt [kWh]";
  Real Qf_vent "WB nat. Lueftung [W]";
  Real Q_vent "WB nat. Lueftung [kWh]";
  Real Qf_sol "solare WG [W]";
  Real Q_sol(start=0, fixed=true) "solare WG [kWh]";

  //eod

equation
  // Spitzboden
  connect(attic.hp_ext, hp_ext);
  connect(attic.hp_int, hp_at);
  connect(attic.x_air_ext, x_air_ext);

  // Obergeschoss
  connect(upperfloor.hp_top, attic.hp_bottom);
  connect(upperfloor.hp_ext, hp_ext);
  connect(upperfloor.hp_int, hp_gfuf);
  connect(upperfloor.x_air_ext, x_air_ext);

  // Erdgeschoss
  connect(groundfloor.hp_top, upperfloor.hp_bottom);
  connect(groundfloor.hp_ext, hp_ext);
  connect(groundfloor.hp_int, hp_gfuf);
  connect(groundfloor.x_air_ext, x_air_ext);

  // Kellergeschoss
  connect(basement.hp_top, groundfloor.hp_bottom);
  connect(basement.hp_ext, hp_ext);
  connect(basement.hp_int, hp_bm);
  connect(basement.hp_soil1, hp_soil1);
  connect(basement.hp_soil2, hp_soil2);
  connect(basement.x_air_ext, x_air_ext);

  // innere Waermegewinne
  P_tsr_gfuf = groundfloor.P_tsr + upperfloor.P_tsr;
  connect(heatgains.P_tsr, P_tsr_gfuf);
  connect(heatgains.hp, hp_gfuf);

  // Waermeverluste durch nat. Belueftung
  connect(nat_ventilation.hp_int, hp_gfuf);
  connect(nat_ventilation.hp_ext, hp_ext);
  connect(nat_ventilation.x_air_ext, x_air_ext);
  connect(nat_ventilation.n_vsys, n_vsys);
  connect(nat_ventilation.n_nat, n_nat);

  // Bewertung der Behaglichkeit  
  TC_mean = (groundfloor.th_comfort.TC + upperfloor.th_comfort.TC) / 2;
  TC_balance_mean = (groundfloor.th_comfort.TC_balance + upperfloor.th_comfort.TC_balance) / 2;

  // sonstiges
  T_air_deg = hp_gfuf.T - 273.15;
  T_op_deg = (groundfloor.T_op_deg + upperfloor.T_op_deg) / 2;

  // Uebergradstunden
  when {T_op_deg > 27, T_op_deg <= 27} then
    f_utgs = if T_op_deg > 27 then 1 else 0;
  end when;
  der(utgs) = f_utgs * (T_op_deg - 27);

  // Vergleichswerte EVEBI
  // Dach
  Qf_roof_ls = upperfloor.roof.P_out + attic.roof.P_out;
  der(Q_roof_ls) = Qf_roof_ls / 1000;
  der(Q_roof_w) = (upperfloor.roof.P_in + attic.roof.P_in) / 1000;

  // Auszenwaende
  Qf_wall_ls = basement.wall_soil.P_out + basement.wall.P_out + groundfloor.wall.P_out + upperfloor.wall.P_out + attic.wall.P_out;
  der(Q_wall_ls) = Qf_wall_ls / 1000;
  der(Q_wall_w) = (basement.wall_soil.P_in + basement.wall.P_in + groundfloor.wall.P_in + upperfloor.wall.P_in + attic.wall.P_in) / 1000;

  // Fenster und Auszentuer
  Qf_win_ls = basement.win.P_out + groundfloor.win.P_out + upperfloor.win.P_out + groundfloor.door.P_out;
  der(Q_win_ls) = Qf_win_ls / 1000;
  der(Q_win_w) = (basement.win.P_in + groundfloor.win.P_in + upperfloor.win.P_in + groundfloor.door.P_in) / 1000;

  // Kellerboden
  Qf_bfloor_ls = basement.floor.P_out;
  der(Q_bfloor_ls) = Qf_bfloor_ls / 1000;
  der(Q_bfloor_w) = basement.floor.P_in / 1000;

  // WL/WUe Gesamt
  Qf_cc_ls = Qf_roof_ls + Qf_wall_ls + Qf_win_ls + Qf_bfloor_ls;
  Q_cc_ls = Q_roof_ls + Q_wall_ls + Q_win_ls + Q_bfloor_ls;
  Q_cc_w = Q_roof_w + Q_wall_w + Q_win_w + Q_bfloor_w;
  Q_cc = Q_cc_ls - Q_cc_w;

  // Lueftung (Bilanz, keine separaten Verluste und Gewinne)
  Qf_vent = nat_ventilation.P_th_loss + basement.nat_ventilation.P_th_loss + attic.nat_ventilation.P_th_loss;
  Q_vent = nat_ventilation.E_th_loss + basement.nat_ventilation.E_th_loss + attic.nat_ventilation.E_th_loss;

  // solare Waermegewinne
  Qf_sol = basement.P_tsr + groundfloor.P_tsr + upperfloor.P_tsr;
  der(Q_sol) = Qf_sol / 1000;

algorithm
  when terminal() then
    TC_final := (groundfloor.th_comfort.TC_final + upperfloor.th_comfort.TC_final) / 2;
  end when;

end Envelope2;