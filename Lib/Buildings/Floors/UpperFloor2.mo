within Lib.Buildings.Floors;

/*
<DOC>
Obergeschoss bestehend aus:
- 2 Dachschraegen
- 1 Geschossdecke
- 4 Auszenwaenden (Ost und West inkl. Giebelanteil)
- 4 Fensterflaechen

---CHANGED---
Lib.Buildings.Elements.ConstructionSL2H1R inner_walls(A=A_iw, param=p_iwall, T_start=293.15) "Innenwaende";
connect(inner_walls.hp1, hp_int);
connect(inner_walls.hp2, hp_int);
</DOC>
*/

model UpperFloor2
  extends Lib.Buildings.Floors.Base;

  import Modelica.Math.tan;
  import Modelica.Constants.pi;

  //parameters
  parameter Real eta_solar = 0.7 "Ausnutzungsgrad solare Gewinne [1]";
  //
  parameter Real L_xi2 = 5.11 "x-Innenmasz ohne Dachschraegen [m]";
  parameter Real H_i2 = 1.68 "Hoehe Unterkante Dachschraege [m]";
  //
  parameter Real H_i_eff = H_i - p_ceiling.D_minus "eff. Raumhoehe [m]";
  parameter Real H_i2_eff = H_i2 "TODO H_i2 [m]";
  parameter Real H_eff = H_i_eff + p_ceiling.D "eff. Geschosshoehe [m]";
  parameter Real L_xi_eff = L_xi - 2 * p_wall.D_minus "eff. x-Innenmasz [m]";
  parameter Real L_xi2_eff = L_xi2 - 0 "TODO L_xi2 [m]";
  parameter Real L_yi_eff = L_yi - 2 * p_wall.D_minus "eff. y-Innenmasz [m]";
  parameter Real L_x_eff = L_xi + 2 * p_wall.D_plus "eff. x-Auszenmasz [m]";
  parameter Real L_y_eff = L_yi + 2 * p_wall.D_plus "eff. y-Auszenmasz [m]";
  parameter Real L_r = sqrt( ((L_x - L_xi2) / 2)^2 + (H - H_i2)^2 ) "Auszenlaenge Dachschraege [m]";
  parameter Real L_ri_eff = sqrt( ((L_xi_eff - L_xi2_eff) / 2)^2 + (L_xi_eff - L_xi2_eff)^2 ) "Innenlaenge Dachschraege [m]";
  parameter Real A_wns = L_x_eff * H - (H - H_i2) * (L_x_eff - L_xi2) / 2 "Flaeche Nord bzw. Sued-AW [m2]";
  parameter Real A_wew = L_y_eff * H_i2 "Flaeche Ost bzw. West-AW [m2]";
  parameter Real A_rew = L_y_eff * L_r "Flaeche Dachschraege Ost bzw. West [m2]";
  parameter Real A_ceiling = L_xi2 * L_y_eff "Flaeche Geschossdecke [m2]";
  parameter Real A_i_eff = L_xi_eff * L_yi_eff "eff. Innenflaeche GF [m2]";
  parameter Real A_eff = L_x_eff * L_y_eff "eff. Geschossflaeche GF [m2]";
  parameter Real V_i_eff = L_yi_eff * ((L_xi_eff*H_i_eff) - ((L_xi_eff-L_xi2_eff)/2)*(H_i_eff-H_i2_eff)) "eff. Innenvolumen [m3]";
  parameter Real V_eff = L_y_eff * ((L_x_eff*H_eff) - ((L_x_eff-L_xi2)/2)*(H_eff-H_i2)) "eff. Geschossvolumen [m3]";
  parameter Real A_iw = (L_xi_eff + L_yi_eff - p_iwall.D) * H_i_eff  - ( ((L_xi_eff - L_xi2)/2) * (H_i_eff - H_i2_eff) ) "Flaeche Innenwaende [m2]";
  parameter Real V_iw = A_iw * p_iwall.D "Innenwand-Volumen [m3]";
  parameter Real V_air = V_i_eff - V_iw "Luft-Volumen [m3]";  
  //
  parameter Real A_win_n = fwc.N_n*fwc.A_n;
  parameter Real A_win_e = fwc.N_e*fwc.A_e;
  parameter Real A_win_s = fwc.N_s*fwc.A_s;
  parameter Real A_win_w = fwc.N_w*fwc.A_w;
  parameter Real A_win = A_win_n + A_win_e + A_win_s + A_win_w;
  parameter Real N_win = fwc.N_n + fwc.N_e + fwc.N_s + fwc.N_w;
  parameter Real A_wall_n = A_wns - A_win_n;
  parameter Real A_wall_e = A_wew - A_win_e;
  parameter Real A_wall_s = A_wns - A_win_s;
  parameter Real A_wall_w = A_wew - A_win_w;
  parameter Real A_wall = A_wall_n + A_wall_e + A_wall_s + A_wall_w;
  parameter Real A_roof = 2 * A_rew;
  //
  parameter Real A_ext = A_wall + A_win + A_roof "Flaeche gegen Auszenluft [m2]";
  parameter Real A_ext_refurb = p_wall.refurb*A_wall + p_window.refurb*A_win + p_roof.refurb*A_roof "sanierte Flaeche gegen Auszenluft [m2]";
  parameter Real X_refurb = (4*p_wall.refurb + 2*p_roof.refurb + p_ceiling.refurb + p_window.refurb*N_win) / (4 + 2 + 1 + N_win) "Sanierungszustand [1]";
  parameter Real X_refurb_eff = (X_refurb + X_refurb_building) / 2 "eff. Sanierungszustand (Infiltration) [1]"; 
  parameter Real A_HT = A_ext + A_ceiling "waermeuebertragende Umfassungsflaeche [m2]";
  parameter Real HT = wall.HT + win.HT + ceiling.HT + roof.HT;

  //components
  parameter Lib.Buildings.Elements.RoofParam p_roof "Eigenschaften Dachschraegen";
  parameter Lib.Buildings.Elements.CeilingParam p_ceiling "Eigenschaften Decke";
  parameter Lib.Buildings.Elements.WallParam p_wall "Eigenschaften AW";
  parameter Lib.Buildings.Elements.IntWallParam p_iwall "Eigenschaften IW";
  parameter Lib.Buildings.Elements.WindowParam p_window "Eigenschaften Fenster";
  parameter Lib.Buildings.Floors.FloorWindowCfg fwc "Fenster-Konfiguration";
  //
  Lib.Buildings.Elements2.Roof roof(A=A_roof, param=p_roof, T_start=283.15) "Dachschraegen";
  Lib.Buildings.Elements2.Ceiling ceiling(A=A_ceiling, param=p_ceiling, T_start=273.15+10) "Geschossdecke";
  Lib.Buildings.Elements2.ExtWall wall(A=A_wall, param=p_wall, T_start=273.15+10) "Auszenwaende";
  Lib.Buildings.Elements2.IntWall inner_walls(A=A_iw, param=p_iwall, T_start=293.15) "Innenwaende"; 
  Lib.Buildings.Elements2.Window win(A=A_win, param=p_window, T_start=273.15) "Fenster";
  //
  Lib.Thermal.Capacity inner_air(C=V_air * 1.2306 * 1006.1, T_start=283.15) "Innenluftvolumen";
  //
  Lib.Thermal.HeatSource solarHeatGains "solare Waermegewinne";
  Lib.DH.RadiationData solarHeatGainsData(part="G_win_uf") "Einstrahlungsdaten [W]";
  //
  Lib.Buildings.Asmt.TC_Pistohl09_H8 th_comfort "Bewertung der Behaglichkeit"; 

  //connectors
  Lib.Thermal.Interfaces.HeatPort hp_top "Spitzboden-Luft";
  Lib.Thermal.Interfaces.HeatPort hp_bottom "Erdgeschoss-Decke";
  Lib.RealOutput P_tsr "transmittierte solare Einstrahlung [W]";

  //variables
  //eod

equation
  // Dachschraegen
  connect(roof.hp_int, hp_int);
  connect(roof.hp_ext, hp_ext);

  // Geschossdecke
  connect(ceiling.hp_int, hp_int);
  connect(ceiling.hp_ext, hp_top);

  // Auszenwaende
  connect(wall.hp_int, hp_int);
  connect(wall.hp_ext, hp_ext);

  // Innenwaende
  connect(inner_walls.hp_air, hp_int);

  // Fenster
  connect(win.hp_int, hp_int);
  connect(win.hp_ext, hp_ext);

  // Innenluftvolumen
  connect(inner_air.hp, hp_int);

  //
  connect(hp_bottom, hp_int);

  // innere Waermegewinne durch solare Einstrahlung (Fenster)
  P_tsr = eta_solar * p_window.f_glass * p_window.g_max * solarHeatGainsData.G;
  solarHeatGains.P_th = P_tsr;
  connect(solarHeatGains.hp, hp_int);

  // mittlere Temperatur der Raumumschlieszungsflaechen [degC] 
  T_si_deg = (A_wall * wall.T_si_deg + A_win * win.T_si_deg + A_roof * roof.T_si_deg + A_ceiling * ceiling.T_si_deg + A_eff * (hp_bottom.T - 273.15) + 2*A_iw * inner_walls.T_si_deg) / (A_wall + A_win + A_roof + A_ceiling + A_eff + 2*A_iw);

  // Bewertung der Behaglichkeit
  th_comfort.T_air_deg = T_air_deg;
  th_comfort.T_si_deg = T_si_deg;

end UpperFloor2;