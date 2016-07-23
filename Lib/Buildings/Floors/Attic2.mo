within Lib.Buildings.Floors;

/*
<DOC>
Dachboden, Satteldach, ohne aufsteigende Waende unter den Dachflaechen
Dachboden bestehend aus:
- 2 Dachflaechen (O, W)
- 2 Auszenwaenden (N, S)
- Luftvolumen

http://ba.localhost/img/Documentation/Buildings/Floors/Attic/Dach1799.jpg

---REMOVED---
Lib.RealOutput P_tsr "transmittierte solare Einstrahlung [W]";
P_tsr = 0;
</DOC>
*/

model Attic2
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
  parameter Real A_wall = 2 * A_wns "Auszenwandflaeche [m2]";
  parameter Real A_roof = 2 * A_rew "Dachflaeche [m2]";
  parameter Real A_ext = A_wall + A_roof "Flaeche gegen Auszenluft [m2]";
  parameter Real A_ext_refurb = p_wall.refurb * A_wall + p_roof.refurb * A_roof "sanierte Flaeche gegen Auszenluft [m2]";
  parameter Real X_refurb = (2*p_wall.refurb + 2*p_roof.refurb) / 4 "Sanierungszustand [1]";
  parameter Real X_refurb_eff = (X_refurb + X_refurb_building) / 2 "eff. Sanierungszustand (Infiltration) [1]"; 
  parameter Real A_HT = 0 "waermeuebertragende Umfassungsflaeche [m2]";
  parameter Real HT = 0;

  //components
  parameter Lib.Buildings.Elements.RoofParam p_roof "Eigenschaften Dach";
  parameter Lib.Buildings.Elements.WallParam p_wall "Eigenschaften AW";
  //
  Lib.Buildings.Elements2.Roof roof(A=A_roof, param=p_roof, T_start=273.15) "Dachflaechen";
  Lib.Buildings.Elements2.ExtWall wall(A=A_wall, param=p_wall, T_start=273.15) "Auszenwaende"; 
  //
  Lib.Thermal.Capacity inner_air(C=V_air * 1.2306 * 1006.1, T_start=283.15) "Innenluftvolumen";
  //
  Lib.Buildings.Ventilation.NaturalVentilation nat_ventilation(V_i=V_air, n_50_ur=n_50_ur, X_refurb=X_refurb_eff, n_min=0) "natuerliche Lueftung";

  //connectors
  Lib.Thermal.Interfaces.HeatPort hp_bottom "Obergeschoss-Decke";
  
  //variables
  //eod

equation
  // Dachflaechen
  connect(roof.hp_int, hp_int);
  connect(roof.hp_ext, hp_ext);

  // Auszenwaende
  connect(wall.hp_int, hp_int);
  connect(wall.hp_ext, hp_ext);

  // Innenluftvolumen
  connect(inner_air.hp, hp_int);

  // Waermeverluste durch nat. Belueftung
  connect(nat_ventilation.hp_int, hp_int);
  connect(nat_ventilation.hp_ext, hp_ext);
  connect(nat_ventilation.x_air_ext, x_air_ext);
  nat_ventilation.n_vsys = 0;

  // sonstiges
  connect(hp_bottom, hp_int);

  // mittlere Temperatur der Raumumschlieszungsflaechen [degC]
  T_si_deg = (A_wall * wall.T_si_deg + A_roof * roof.T_si_deg + A_eff * (hp_bottom.T - 273.15)) / (A_wall + A_roof + A_eff);

end Attic2;