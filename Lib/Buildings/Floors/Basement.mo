within Lib.Buildings.Floors;

/*
<DOC>
Kellergeschoss bestehend aus:
- 1 Geschossdecke
- 4 Auszenwaenden gegen Auszenluft
- 1 Gesamt-Auszenwand gegen Erdreich
- 4 Fensterflaechen
- 1 Bodenplatte
- Innenwaende
- Luftvolumen als therm. Kapazitaet

Luft 10 degC: rho=1.2306 kg/m3, cp=1.0061 kJ/(kg*K) [VDI Waermeatlas, 10. Auflage, 2006, Kapitel D, S. 47]


---CHANGED---
Lib.Buildings.Elements.ConstructionSL2H1R inner_walls(A=A_iw, param=p_iwall, T_start=283.15);
connect(inner_walls.hp1, hp_int);
connect(inner_walls.hp2, hp_int);
</DOC>
*/

model Basement
  extends Lib.Buildings.Floors.Base;

  //parameters
  parameter Real H_soil = 1 "Hoehe AW in Erdreich [m]";

  parameter Real H_i_eff = H_i - p_ceiling.D_minus - p_floor.D_minus "eff. Raumhoehe [m]";
  parameter Real H_eff = H_i_eff + p_ceiling.D "eff. Geschosshoehe [m]";
  parameter Real L_xi_eff = L_xi - 2 * p_wall.D_minus "eff. x-Innenmasz [m]";
  parameter Real L_yi_eff = L_yi - 2 * p_wall.D_minus "eff. y-Innenmasz [m]";
  parameter Real L_x_eff = L_xi + 2 * p_wall.D_plus "eff. x-Auszenmasz [m]";
  parameter Real L_y_eff = L_yi + 2 * p_wall.D_plus "eff. y-Auszenmasz [m]";
  parameter Real A_i_eff = L_xi_eff * L_yi_eff "eff. Innenflaeche [m2]";
  parameter Real A_eff = L_x_eff * L_y_eff "eff. Geschossflaeche [m2]";
  parameter Real V_i_eff = A_i_eff * H_i_eff "eff. Innenvolumen [m3]";
  parameter Real V_eff = A_eff * H_eff "eff. Geschossvolumen [m3]";
  parameter Real A_iw = (L_xi_eff + L_yi_eff - p_iwall.D) * H_i_eff "Flaeche Innenwaende [m2]";
  parameter Real V_iw = A_iw * p_iwall.D "Innenwand-Volumen [m3]";
  parameter Real V_air = V_i_eff - V_iw "Luft-Volumen [m3]";
  //
  parameter Real A_win_n = fwc.N_n*fwc.A_n;
  parameter Real A_win_e = fwc.N_e*fwc.A_e;
  parameter Real A_win_s = fwc.N_s*fwc.A_s;
  parameter Real A_win_w = fwc.N_w*fwc.A_w;
  parameter Real A_wall_n = L_x_eff*(H_eff-H_soil) - A_win_n;
  parameter Real A_wall_e = L_y_eff*(H_eff-H_soil) - A_win_e;
  parameter Real A_wall_s = L_x_eff*(H_eff-H_soil) - A_win_s;
  parameter Real A_wall_w = L_y_eff*(H_eff-H_soil) - A_win_w;
  //
  parameter Real A_ext = A_wall_n + A_win_n + A_wall_e + A_win_e + A_wall_s + A_win_s + A_wall_w + A_win_w "Flaeche gegen Auszenluft [m2]";
  parameter Real A_ext_refurb = p_wall.refurb*(A_wall_n+A_wall_e+A_wall_s+A_wall_w) + p_window.refurb*(A_win_n+A_win_e+A_win_s+A_win_w) "sanierte Flaeche gegen Auszenluft [m2]"; 
  // Verhaeltnis der Anzahl sanierter Bauteile zur Gesamtanzahl
  parameter Real X_refurb = (4*p_wall.refurb + p_ceiling.refurb + p_window.refurb*(fwc.N_n + fwc.N_e + fwc.N_s + fwc.N_w)) / (4 + 1 + fwc.N_n + fwc.N_e + fwc.N_s + fwc.N_w) "Anteil sanierter Bauteile [1]";
  parameter Real A_HT = A_eff "waermeuebertragende Umfassungsflaeche [m2]"; 
  parameter Real HT = ceiling.HT "HT-Wert [W/K]";

  //components
  parameter Lib.Buildings.Elements.CeilingParam p_ceiling "Eigenschaften Decke";
  parameter Lib.Buildings.Elements.WallParam p_wall "Eigenschaften AW";
  parameter Lib.Buildings.Elements.IntWallParam p_iwall "Eigenschaften IW";
  parameter Lib.Buildings.Elements.FloorParam p_floor "Eigenschaften Boden";
  parameter Lib.Buildings.Elements.WindowParam p_window "Eigenschaften Fenster";
  parameter Lib.Buildings.Floors.FloorWindowCfg fwc "Fenster-Konfiguration";
  //
  Lib.Buildings.Elements2.Ceiling ceiling(A=A_eff, param=p_ceiling, T_start=273.15+10) "Geschossdecke";
  Lib.Buildings.Elements.ConstructionSL2H1R wall_n(A=A_wall_n, param=p_wall, RadData="bmn_G");
  Lib.Buildings.Elements.ConstructionSL2H1R wall_e(A=A_wall_e, param=p_wall, RadData="bme_G");
  Lib.Buildings.Elements.ConstructionSL2H1R wall_s(A=A_wall_s, param=p_wall, RadData="bms_G");
  Lib.Buildings.Elements.ConstructionSL2H1R wall_w(A=A_wall_w, param=p_wall, RadData="bmw_G");
  Lib.Buildings.Elements.ConstructionSL2H1R wall_soil(A=2*(L_x_eff+L_y_eff)*H_soil, param=p_wall);
  Lib.Buildings.Elements2.Floor floor(A=A_eff, param=p_floor, T_start=273.15+5) "Boden KG";
  Lib.Buildings.Elements2.IntWall inner_walls(A=A_iw, param=p_iwall, T_start=283.15);
  Lib.Buildings.Elements.ConstructionSL2H1R win_n(A=A_win_n, param=p_window, T_start=273.15, RadData="bmn_G");
  Lib.Buildings.Elements.ConstructionSL2H1R win_e(A=A_win_e, param=p_window, T_start=273.15, RadData="bme_G");
  Lib.Buildings.Elements.ConstructionSL2H1R win_s(A=A_win_s, param=p_window, T_start=273.15, RadData="bms_G");
  Lib.Buildings.Elements.ConstructionSL2H1R win_w(A=A_win_w, param=p_window, T_start=273.15, RadData="bmw_G");
  //
  Lib.Thermal.Capacity inner_air(C=V_air * 1.2306 * 1006.1, T_start=283.15);

  //connectors
  Lib.Thermal.Interfaces.HeatPort hp_top "Erdgeschoss-Luft";
  Lib.Thermal.Interfaces.HeatPort hp_soil1 "Erdreich 1m";
  Lib.Thermal.Interfaces.HeatPort hp_soil2 "Erdreich 2m";
  Lib.RealOutput P_tsr "transmittierte solare Einstrahlung [W]"; 

  //variables
  
  //eod

equation
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
  //
  connect(wall_soil.hp1, hp_int);
  connect(wall_soil.hp2, hp_soil1);

  // Geschossboden
  connect(floor.hp_int, hp_int);
  connect(floor.hp_ext, hp_soil2);

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
  connect(inner_air.hp, hp_int);
  //
  P_tsr = win_n.P_tsr + win_e.P_tsr + win_s.P_tsr + win_w.P_tsr; 

end Basement;