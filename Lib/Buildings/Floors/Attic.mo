within Lib.Buildings.Floors;

/*
<DOC>
Dachboden, Satteldach, ohne aufsteigende Waende unter den Dachflaechen
Dachboden bestehend aus:
- 2 Dachflaechen (O, W)
- 2 Auszenwaenden (N, S)
- Luftvolumen

http://ba.localhost/img/Documentation/Buildings/Floors/Attic/Dach1799.jpg
</DOC>
*/

model Attic
  extends Lib.Buildings.Floors.Base;

  import Modelica.Math.sin;
  import Modelica.Constants.pi;

  //parameters
  parameter Real phi_roof_deg = 32 "Dachneigung [deg]";
  //
  parameter Real H_i_eff = H_i - (p_roof.D_minus / sin(phi_roof_deg / 180 * pi)) "eff. Raumhoehe [m]";
  parameter Real L_xi_eff = L_xi - (p_roof.D_minus / sin(phi_roof_deg / 180 * pi)) "eff. x-Innenmasz [m]";
  parameter Real L_yi_eff =L_yi - 2 * p_wall.D_minus "eff. y-Innenmasz [m]";
  parameter Real L_y_eff = L_yi + 2 * p_wall.D_plus "eff. y-Auszenmasz [m]"; 
  parameter Real L_r = sqrt(H^2 + 0.25 * L_x^2) "Auszenlaenge Dachseite [m]";
  parameter Real A_wns = 0.5 * L_x * H "Flaeche Nord- bzw. Sued-AW [m2]";
  parameter Real A_rew = L_r * L_y_eff "Flaeche Ost- bzw. West-Dach [m2]";
  parameter Real A_eff = L_x * L_y_eff "eff. Grundflaeche [m2]";
  parameter Real A_i_eff = L_xi_eff * L_yi_eff "eff. Innenflaeche [m2]";
  parameter Real V_eff = 0.5 * L_x * L_y_eff * H "Volumen [m3]";
  parameter Real V_i_eff = 0.5 * L_xi_eff * L_yi_eff * H_i_eff "Innenvolumen [m3]";
  parameter Real V_air = V_i_eff "Luftvolumen [m3]";
  //
  parameter Real A_ext = 2 * A_wns + 2 * A_rew "Flaeche gegen Auszenluft [m2]";
  parameter Real A_ext_refurb = p_wall.refurb * 2 * A_wns + p_roof.refurb * 2 * A_rew "sanierte Flaeche gegen Auszenluft [m2]";
  parameter Real X_refurb = (2*p_wall.refurb + 2*p_roof.refurb) / 4 "Anteil sanierter Bauteile [1]";
  parameter Real A_HT = 0 "waermeuebertragende Umfassungsflaeche [m2]";
  parameter Real HT = 0;

  //components
  parameter Lib.Buildings.Elements.RoofParam p_roof "Eigenschaften Dach";
  parameter Lib.Buildings.Elements.WallParam p_wall "Eigenschaften AW";
  //
  Lib.Buildings.Elements.ConstructionSL2H1R roof_e(A=A_rew, param=p_roof, T_start=273.15, RadData="atre_G");
  Lib.Buildings.Elements.ConstructionSL2H1R roof_w(A=A_rew, param=p_roof, T_start=273.15, RadData="atrw_G");
  Lib.Buildings.Elements.ConstructionSL2H1R wall_n(A=A_wns, param=p_wall, T_start=273.15, RadData="atn_G");
  Lib.Buildings.Elements.ConstructionSL2H1R wall_s(A=A_wns, param=p_wall, T_start=273.15, RadData="ats_G");
  //
  Lib.Thermal.Capacity inner_air(C=V_air * 1.2306 * 1006.1, T_start=283.15);
  
  //connectors
  Lib.Thermal.Interfaces.HeatPort hp_bottom "Obergeschoss-Decke";
  Lib.RealOutput P_tsr "transmittierte solare Einstrahlung [W]";

  //variables
  //eod

equation
  connect(roof_e.hp1, hp_int);
  connect(roof_e.hp2, hp_ext);
  //
  connect(roof_w.hp1, hp_int);
  connect(roof_w.hp2, hp_ext);
  //
  connect(wall_n.hp1, hp_int);
  connect(wall_n.hp2, hp_ext);
  //
  connect(wall_s.hp1, hp_int);
  connect(wall_s.hp2, hp_ext);
  //
  connect(inner_air.hp, hp_int);
  //
  connect(hp_bottom, hp_int);
  //
  P_tsr = 0;

end Attic;