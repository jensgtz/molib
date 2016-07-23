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

waermeuebertragende Umfassungsflaeche = Geschossdecke bzw. Kellerdecke


---CHANGED---
Lib.Buildings.Elements.ConstructionSL2H1R inner_walls(A=A_iw, param=p_iwall, T_start=283.15);
connect(inner_walls.hp1, hp_int);
connect(inner_walls.hp2, hp_int);
</DOC>
*/

model Basement2
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
  parameter Real A_win = A_win_n + A_win_e + A_win_s + A_win_w;
  parameter Real N_win = fwc.N_n + fwc.N_e + fwc.N_s + fwc.N_w;
  parameter Real A_wall_n = L_x_eff*(H_eff-H_soil) - A_win_n;
  parameter Real A_wall_e = L_y_eff*(H_eff-H_soil) - A_win_e;
  parameter Real A_wall_s = L_x_eff*(H_eff-H_soil) - A_win_s;
  parameter Real A_wall_w = L_y_eff*(H_eff-H_soil) - A_win_w;
  parameter Real A_wall = A_wall_n + A_wall_e + A_wall_s + A_wall_w;
  parameter Real A_wall_soil = 2*(L_x_eff+L_y_eff)*H_soil;
  //
  parameter Real A_ext = A_wall + A_win "Flaeche gegen Auszenluft [m2]";
  parameter Real A_ext_refurb = p_wall.refurb*A_wall + p_window.refurb*A_win "sanierte Flaeche gegen Auszenluft [m2]"; 
  // Verhaeltnis der Anzahl sanierter Bauteile zur Gesamtanzahl
  parameter Real X_refurb = (4*p_wall.refurb + p_ceiling.refurb + p_window.refurb*N_win) / (4 + 1 + N_win) "Sanierungszustand [1]";
  parameter Real X_refurb_eff = (X_refurb + X_refurb_building) / 2 "eff. Sanierungszustand (Infiltration) [1]";
  parameter Real A_HT = A_eff "waermeuebertragende Umfassungsflaeche [m2]"; 
  parameter Real HT = ceiling.HT "HT-Wert [W/K]";

  //components
  parameter Lib.Buildings.Elements.CeilingParam p_ceiling "Eigenschaften Decke";
  parameter Lib.Buildings.Elements.WallParam p_wall "Eigenschaften AW";
  parameter Lib.Buildings.Elements.WallParam p_swall "Eigenschaften AWE";
  parameter Lib.Buildings.Elements.IntWallParam p_iwall "Eigenschaften IW";
  parameter Lib.Buildings.Elements.FloorParam p_floor "Eigenschaften Boden";
  parameter Lib.Buildings.Elements.WindowParam p_window "Eigenschaften Fenster";
  parameter Lib.Buildings.Floors.FloorWindowCfg fwc "Fenster-Konfiguration";
  //
  Lib.Buildings.Elements2.Ceiling ceiling(A=A_eff, param=p_ceiling, T_start=273.15+10) "Geschossdecke";
  Lib.Buildings.Elements2.ExtWall wall(A=A_wall, param=p_wall, T_start=273.15+5) "AW gegen Luft";
  Lib.Buildings.Elements2.ExtWall wall_soil(A=A_wall_soil, param=p_swall, T_start=273.15+5) "AW gegen Erdreich";
  Lib.Buildings.Elements2.Floor floor(A=A_eff, param=p_floor, T_start=273.15+5) "Boden";
  Lib.Buildings.Elements2.IntWall inner_walls(A=A_iw, param=p_iwall, T_start=283.15) "Innenwaende";
  Lib.Buildings.Elements2.Window win(A=A_win, param=p_window, T_start=273.15);
  //
  Lib.Thermal.Capacity inner_air(C=V_air * 1.2306 * 1006.1, T_start=283.15) "Innenluftvolumen";
  //
  Lib.Thermal.HeatSource solarHeatGains "solare Waermegewinne";
  Lib.DH.RadiationData solarHeatGainsData(part="G_win_bm") "Einstrahlungsdaten [W]";
  Lib.Buildings.Ventilation.NaturalVentilation nat_ventilation(V_i=V_air, n_50_ur=n_50_ur, X_refurb=X_refurb_eff, n_min=0) "natuerliche Lueftung"; 

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

  // Auszenwaende gegen Auszenluft
  connect(wall.hp_int, hp_int);
  connect(wall.hp_ext, hp_ext);

  // Auszenwaende gegen Erdreich
  connect(wall_soil.hp_int, hp_int);
  connect(wall_soil.hp_ext, hp_soil1);

  // Geschossboden
  connect(floor.hp_int, hp_int);
  connect(floor.hp_ext, hp_soil2);

  // Innenwaende
  connect(inner_walls.hp_air, hp_int);

  // Fenster
  connect(win.hp_int, hp_int);
  connect(win.hp_ext, hp_ext);

  // Innenluftvolumen 
  connect(inner_air.hp, hp_int);

  // innere Waermegewinne durch solare Einstrahlung (Fenster)
  P_tsr = 0.7 * p_window.f_glass * p_window.g_max * solarHeatGainsData.G;
  solarHeatGains.P_th = P_tsr;
  connect(solarHeatGains.hp, hp_int);

  // Waermeverluste durch nat. Belueftung
  connect(nat_ventilation.hp_int, hp_int);
  connect(nat_ventilation.hp_ext, hp_ext);
  connect(nat_ventilation.x_air_ext, x_air_ext);
  nat_ventilation.n_vsys = 0;

  // mittlere Temperatur der Raumumschlieszungsflaechen [degC] 
  T_si_deg = (A_wall * wall.T_si_deg + A_wall_soil * wall_soil.T_si_deg + A_win * win.T_si_deg + A_eff * ceiling.T_si_deg + A_eff * floor.T_si_deg + 2*A_iw * inner_walls.T_si_deg) / (A_wall + A_wall_soil + A_win + A_eff + A_eff + 2*A_iw);

end Basement2;