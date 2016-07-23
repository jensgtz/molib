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

model UpperFloor
  extends Lib.Buildings.Floors.Base;

  import Modelica.Math.tan;
  import Modelica.Constants.pi;

  //parameters
  parameter Real L_xi2 = 1 "x-Innenmasz ohne Dachschraegen [m]";
  parameter Real H_i2 = 1 "Hoehe Unterkante Dachschraege [m]";
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
  parameter Real A_wall_n = A_wns - A_win_n;
  parameter Real A_wall_e = A_wew - A_win_e;
  parameter Real A_wall_s = A_wns - A_win_s;
  parameter Real A_wall_w = A_wew - A_win_w;
  //
  parameter Real A_ext = A_wall_n + A_win_n + A_wall_e + A_win_e + A_wall_s + A_win_s + A_wall_w + A_win_w + 2 * A_rew "Flaeche gegen Auszenluft [m2]";
  parameter Real A_ext_refurb = p_wall.refurb*(A_wall_n+A_wall_e+A_wall_s+A_wall_w) + p_window.refurb*(A_win_n+A_win_e+A_win_s+A_win_w) + p_roof.refurb*2*A_rew "sanierte Flaeche gegen Auszenluft [m2]";
  parameter Real X_refurb = (4*p_wall.refurb + 2*p_roof.refurb + p_ceiling.refurb + p_window.refurb*(fwc.N_n + fwc.N_e + fwc.N_s + fwc.N_w)) / (4 + 2 + 1 + fwc.N_n + fwc.N_e + fwc.N_s + fwc.N_w) "Anteil sanierter Bauteile [1]";
  parameter Real A_HT = A_ext + A_ceiling "waermeuebertragende Umfassungsflaeche [m2]";
  parameter Real HT = wall_n.HT + wall_e.HT + wall_s.HT + wall_w.HT  +  win_n.HT + win_e.HT + win_s.HT + win_w.HT  +  ceiling.HT  +  roof_e.HT + roof_w.HT;

  //components
  parameter Lib.Buildings.Elements.RoofParam p_roof "Eigenschaften Dachschraegen";
  parameter Lib.Buildings.Elements.CeilingParam p_ceiling "Eigenschaften Decke";
  parameter Lib.Buildings.Elements.WallParam p_wall "Eigenschaften AW";
  parameter Lib.Buildings.Elements.IntWallParam p_iwall "Eigenschaften IW";
  parameter Lib.Buildings.Elements.WindowParam p_window "Eigenschaften Fenster";
  parameter Lib.Buildings.Floors.FloorWindowCfg fwc "Fenster-Konfiguration";
  //
  Lib.Buildings.Elements.ConstructionSL2H1R roof_e(A=A_rew, param=p_roof, T_start=283.15, RadData="ufre_G") "Dachschraege Ost";
  Lib.Buildings.Elements.ConstructionSL2H1R roof_w(A=A_rew, param=p_roof, T_start=283.15, RadData="ufrw_G") "Dachschraege West";
  Lib.Buildings.Elements2.Ceiling ceiling(A=A_ceiling, param=p_ceiling, T_start=273.15+10) "Decke zu Spitzboden";
  Lib.Buildings.Elements.ConstructionSL2H1R wall_n(A=A_wall_n, param=p_wall, T_start=283.15, RadData="ufn_G") "AW Nord";
  Lib.Buildings.Elements.ConstructionSL2H1R wall_e(A=A_wall_e, param=p_wall, T_start=283.15, RadData="ufe_G") "AW Ost";
  Lib.Buildings.Elements.ConstructionSL2H1R wall_s(A=A_wall_s, param=p_wall, T_start=283.15, RadData="ufs_G") "AW Sued";
  Lib.Buildings.Elements.ConstructionSL2H1R wall_w(A=A_wall_w, param=p_wall, T_start=283.15, RadData="ufw_G") "AW West";
  Lib.Buildings.Elements2.IntWall inner_walls(A=A_iw, param=p_iwall, T_start=293.15) "Innenwaende"; 
  Lib.Buildings.Elements.ConstructionSL2H1R win_n(A=A_win_n, param=p_window, T_start=273.15, RadData="ufn_G");
  Lib.Buildings.Elements.ConstructionSL2H1R win_e(A=A_win_e, param=p_window, T_start=273.15, RadData="ufe_G");
  Lib.Buildings.Elements.ConstructionSL2H1R win_s(A=A_win_s, param=p_window, T_start=273.15, RadData="ufs_G");
  Lib.Buildings.Elements.ConstructionSL2H1R win_w(A=A_win_w, param=p_window, T_start=273.15, RadData="ufw_G");
  //
  Lib.Thermal.Capacity inner_air(C=V_air * 1.2306 * 1006.1, T_start=283.15);

  //connectors
  Lib.Thermal.Interfaces.HeatPort hp_top "Spitzboden-Luft";
  Lib.Thermal.Interfaces.HeatPort hp_bottom "Erdgeschoss-Decke";
  Lib.RealOutput P_tsr "transmittierte solare Einstrahlung [W]";

  //variables
  //eod

equation
  connect(roof_e.hp1, hp_int);
  connect(roof_e.hp2, hp_ext);
  //
  connect(roof_w.hp1, hp_int);
  connect(roof_w.hp2, hp_ext);
  // Geschossdecke
  connect(ceiling.hp_int, hp_int);
  connect(ceiling.hp_ext, hp_top);
  //
  connect(wall_n.hp1, hp_int);
  connect(wall_n.hp2, hp_ext);
  //
  connect(wall_e.hp1, hp_int);
  connect(wall_e.hp2, hp_ext);
  //
  connect(wall_s.hp1, hp_int);
  connect(wall_s.hp2, hp_ext);
  //
  connect(wall_w.hp1, hp_int);
  connect(wall_w.hp2, hp_ext);

  // Innenwaende
  connect(inner_walls.hp_air, hp_int);

  //
  connect(win_n.hp1, hp_int);
  connect(win_n.hp2, hp_ext);
  //
  connect(win_e.hp1, hp_int);
  connect(win_e.hp2, hp_ext);
  //
  connect(win_s.hp1, hp_int);
  connect(win_s.hp2, hp_ext);
  //
  connect(win_w.hp1, hp_int);
  connect(win_w.hp2, hp_ext);
  //
  connect(hp_bottom, hp_int);
  //
  P_tsr = win_n.P_tsr + win_e.P_tsr + win_s.P_tsr + win_w.P_tsr;

end UpperFloor;