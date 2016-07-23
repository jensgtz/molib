within Lib.Buildings.HotWater;

/*
<DOC>
2 Anschluesse

---
TODO: smoth P_th
Real P_th_set "Profil-Leistung [W]";
</DOC>
*/

model Load

  //parameters
  parameter Real E_a = 1800 "Jahres-Nutzwaermebedarf TWW [kWh/a]";
  parameter Real t_on = 6 "Nutzungszeit von ... [h]";
  parameter Real t_off = 23 "Nutzungszeit bis ... [h]";
  parameter Boolean use1 = false "Anschluss 1 Nutzen";
  parameter Boolean use2 = true "Anschluss 2 Nutzen";
  parameter Real P_1 = E_a / (365 * (t_off-t_on)) * 1000 "mittlere stuendliche Nutzwaerme [W]";

  //components

  //connectors
  Lib.RealInput clock_hour "Stunde, kontinuierlich";
  Lib.Thermal.Interfaces.HeatPort hp_dev1 "Anschluss 1";
  Lib.Thermal.Interfaces.HeatPort hp_dev2 "Anschluss 2";

  //variables
  Real P_th(start=0, fixed=true) "Nutzwaermestrom TWW [W]";
  Real E_th(start=0, fixed=true) "Nutzenergie TWW [kWh]";

  //eod

equation

  when {clock_hour >= t_on, clock_hour >= t_off} then
    P_th = if clock_hour >= t_on and clock_hour < t_off then P_1 else 0;
  end when;

  der(E_th) = P_th / 1000;

  if use1 then
    hp_dev1.Q_flow = P_th;
    hp_dev2.Q_flow = 0;
  else
    hp_dev1.Q_flow = 0;
    hp_dev2.Q_flow = P_th;
  end if;

end Load;