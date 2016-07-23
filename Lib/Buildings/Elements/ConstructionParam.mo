within Lib.Buildings.Elements;

record ConstructionParam
  //parameters
  parameter Integer refurb = 0 "0 fuer unsaniert oder 1 fuer saniert [1]";
  parameter Real R_si = 0.10 "Waermeuebergangswiderstand innen [m2*K/W]";
  parameter Real R_se = 0.04 "Waermeuebergangswiderstand auszen [m2*K/W]";
  parameter Real R_cond = 0.50 "Waermeleitwiderstand [m2*K/W]";
  parameter Real U_plus = 0.05 "Waermebrueckenzuschlag [W/(m2*K)]";
  parameter Real Cp_a = 1000 "flaechenspezifische Waermekapazitaet [J/(m2*K)]";
  parameter Real D = 0.24 "Staerke der Konstruktion [m]";
  parameter Real D_plus = 0.24 "Staerke von 0-Layer nach auszen [m]";
  parameter Real D_minus = 0.00 "Staerke von 0-Layer nach innen [m]";
  parameter Real alpha = 0.00 "Absorptionskoeffizient, auszen [1]";
  parameter Real epsilon = 0.00 "Emissionskoeffizient, auszen [1]";
  parameter Real tau = 0.00 "Transmissionskoeffizient [1]";
  parameter Real f_glass = 0.70 "Glasanteil Fenster [1]";
  parameter Real g_max = 0.75 "max. Gesamtenergiedurchlassgrad [1]";
  parameter Real R_bk10[10] = ones(10) "Beuken-Widerstandswerte [m2*K/W]";
  parameter Real C_bk10[10] = ones(10) "Beuken-Kapazitaetswerte [Wh/(m2*K)]";
  parameter Real tech__TL = 20 "Lebensdauer [a]";
  parameter Real tech__RF = 1 "Austauschfaktor [1]";
  parameter Real eco__k = 0 "spezif. Investitionskosten [EUR/m2]";
  parameter Real env__kea_h = 0 "spezif. KEA Herstellung [kWh/m2]";
  parameter Real env__kea_h_ne = 0 "spezif. n.e. KEA Herstellung [kWh/m2]";
  parameter String flags = "" "zusaetzliche Informationen [-]";

  //components
end ConstructionParam;