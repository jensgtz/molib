within Lib.DH;

/*
<DOC>
azimuth: Ausrichtung / Abweichung von Nord im Uhrzeigersinn
  0deg: Nordwand (wall_n) zeit nach Norden
  90deg: Nordwand (wall_n) zeigt nach Osten usw.

hp_ext: Auszenluft-Knoten
</DOC>
*/

model Envelope
  import Modelica.Math.tan;
  import Modelica.Math.sin;
  import Modelica.Constants.pi;

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
  parameter Real n_50_ur = 4 "nat. Luftwechsel, unsaniert [1/h]";
  //
  parameter Real H_uf_i2 = H_e - H_gf_0 - H_gf "Unterkante Dachschraege OG, rel. [m]";
  parameter Real L_uf_xi2 = L_xi - 2 * ((H_uf_i-H_uf_i2)/tan(phi_roof_deg / 180 * pi)) "x-Innenmasz ohne Dachschraege OG [m]";
  parameter Real L_at_x = (H_r - H_uf - H_gf - H_gf_0) / (H_r - H_e) * L_x "x-Auszenmasz SB-Unterkante [m]";
  parameter Real L_at_xi = L_at_x - 2 * (D_roof / sin(phi_roof_deg / 180 * pi)) "x-Innenmasz SB-Unterkante [m]";
  parameter Real H_at = H_r - H_uf - H_gf - H_gf_0 "Hoehe Spitzboden [m]";
  parameter Real H_at_i = H_at - (D_roof / sin(phi_roof_deg / 180 * pi)) "Innenhoehe SB [m]";
  //
  parameter Real X_refurb = (basement.X_refurb + groundfloor.X_refurb + upperfloor.X_refurb + attic.X_refurb) / 4 "Anteil santierter Bauteile [1]";
  parameter Real A_HT =  attic.A_HT + upperfloor.A_HT + groundfloor.A_HT + basement.A_HT;
  parameter Real HT =  attic.HT + upperfloor.HT + groundfloor.HT + basement.HT;
  parameter Real H_T = HT / A_HT "spezifischer Transmissionswaermeverlust [W/(m2*K)]";
  //
  parameter Real A_ngf = groundfloor.A_i_eff + upperfloor.A_i_eff "Nettogrundflaeche [m2]";
  parameter Real V_i_h = groundfloor.V_i_eff + upperfloor.V_i_eff "Nettoinnenvolumen, beheizt [m3]";

  //components
  Lib.Buildings.Floors.Attic attic(L_x=L_at_x, L_y=L_y, H=H_at, L_xi=L_at_xi, L_yi=L_yi, H_i=H_at_i, phi_roof_deg=phi_roof_deg) "Spitzboden";
  Lib.Buildings.Floors.UpperFloor upperfloor(L_x=L_x, L_y=L_y, H=H_uf, L_xi=L_xi, L_yi=L_yi, H_i=H_uf_i, L_xi2=L_uf_xi2, H_i2=H_uf_i2) "Obergeschoss";
  Lib.Buildings.Floors.GroundFloor groundfloor(L_x=L_x, L_y=L_y, H=H_gf, L_xi=L_xi, L_yi=L_yi, H_i=H_gf_i) "Erdgeschoss";
  Lib.Buildings.Floors.Basement basement(L_x=L_x, L_y=L_y, H=H_bm, L_xi=L_xi, L_yi=L_yi, H_i=H_bm_i) "Kellergeschoss";
  //
  Lib.Buildings.EnergyBalance.InternalHeatGains heatgains(A_ngf=A_ngf) "Waermegewinne";
  Lib.Buildings.EnergyBalance.VentilationHeatLossInf heatloss_inf(V_i=V_i_h, n_50_ur=n_50_ur) "Lueftungsverluste";

  //connectors
  Lib.Thermal.Interfaces.HeatPort hp_at "Spitzboden";
  Lib.Thermal.Interfaces.HeatPort hp_gfuf "beheizte Zone";
  Lib.Thermal.Interfaces.HeatPort hp_bm "Kellergeschoss";
  Lib.Thermal.Interfaces.HeatPort hp_ext "Auszenluft";
  Lib.Thermal.Interfaces.HeatPort hp_soil1 "Erdreich 1m";
  Lib.Thermal.Interfaces.HeatPort hp_soil2 "Erdreich 2m";
  Lib.RealOutput P_tsr_gfuf;
  //variables


  //eod

equation
  // Spitzboden
  connect(attic.hp_ext, hp_ext);
  connect(attic.hp_int, hp_at);
  
  // Obergeschoss
  connect(upperfloor.hp_top, attic.hp_bottom);
  connect(upperfloor.hp_ext, hp_ext);
  connect(upperfloor.hp_int, hp_gfuf);

  // Erdgeschoss
  connect(groundfloor.hp_top, upperfloor.hp_bottom);
  connect(groundfloor.hp_ext, hp_ext);
  connect(groundfloor.hp_int, hp_gfuf);

  // Kellergeschoss
  connect(basement.hp_top, groundfloor.hp_bottom);
  connect(basement.hp_ext, hp_ext);
  connect(basement.hp_int, hp_bm);
  connect(basement.hp_soil1, hp_soil1);
  connect(basement.hp_soil2, hp_soil2);

  // innere Waermegewinne
  P_tsr_gfuf = groundfloor.P_tsr + upperfloor.P_tsr;
  connect(heatgains.P_tsr, P_tsr_gfuf);
  connect(heatgains.hp, hp_gfuf);

  // Waermeverluste durch nat. Belueftung
  connect(heatloss_inf.hp_int, hp_gfuf);
  connect(heatloss_inf.hp_ext, hp_ext);

end Envelope;