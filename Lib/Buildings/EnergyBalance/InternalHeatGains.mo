within Lib.Buildings.EnergyBalance;

/*
<DOC>
innere Waermegewinne (beheizte Zone)
in Anlehnung an DIN V 18599-2:2011 S. 77 ff.

beruecksichtigt werden:
- solare Einstrahlung durch transparente Flaechen
- elektrische Lasten (Geraete inkl. Beleuchtung) *1
- Waermeabgabe durch Personen *1

*1 ... zusammengefasst in q_I

---CHANGED---
- Ausnutzungsgrad wird nicht auf solare Gewinne angewendet
- Input P_tsr dient nur als Wertequelle um gesamte innere Gewinne zu berechnen / Waermestrom wird in Geschossen zugefuehrt
</DOC>
*/

model InternalHeatGains

  //parameters
  parameter Real q_I = 45 "interne Waermequellen WG [Wh/(m2*d)]";
  parameter Real A_ngf = 100 "Nettogrundflaeche [m2]";
  parameter Real eta_g = 0.7 "Ausnutzungsgrad Waermegewinne [1]";

  //calculated
  parameter Real P_th_pgb = A_ngf * q_I / 24 "Waermestrom durch Personen, Geraete und Beleuchtung [W]";

  //components

  //connectors
  Lib.RealInput P_tsr "solare Einstrahlung durch transparente Flaechen, beheizte Zone [W]";
  Lib.Thermal.Interfaces.HeatPort hp "Luftknoten beheizte Zone";

  //variables
  Real P_th "aktueller Gesamt-Waermezufluss, beheizte Zone [W]";
  Real E_th(start=0, fixed=true) "kumulierte innere Gewinne, beheizte Zone [kWh]";
  Real E_th_pgb(start=0, fixed=true) "PGB-Anteil Gewinne [kWh]";
  Real E_th_solar(start=0, fixed=true) "Solar-Anteil Gewinne [kWh]";

  //eod

equation
  P_th = eta_g * P_th_pgb + P_tsr;
  hp.Q_flow = -eta_g * P_th_pgb;
  der(E_th) = P_th / 1000;
  der(E_th_pgb) = eta_g * P_th_pgb / 1000;
  der(E_th_solar) = P_tsr / 1000;

end InternalHeatGains;