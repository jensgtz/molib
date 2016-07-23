within Lib.Buildings.Elements;

/*
<DOC>
Ein-Schicht-Modell mit:
- 2 Waermeschnittstellen
- 1 auszenliegenden Strahlungsschnittstelle

---
  Lib.Thermal.RadiationEmitter rad_em(A=A, epsilon=param.epsilon) "Emission";
  connect(rad_em.hp, cond_resistor2.hp2);
</DOC>
*/

model ConstructionSL2H1R

  //parameters
  parameter Real A = 1 "Flaeche [m2]";
  parameter Lib.Buildings.Elements.ConstructionParam param "Eigenschaften der Konstruktion";
  parameter Real T_start = 283.15 "Start-Temperatur [K]";
  parameter String RadData = "no_G" "Bezeichner der Einstrahlungsdaten"; 
  //
  parameter Real A_set = max(1e-4, A) "Flaeche (min. 1 cm2) [m2]";
  parameter Real U = 1 / (param.R_si + param.R_cond + param.R_se) "U-Wert [W/(m2*K)]";
  parameter Real HT = U*A "zur Berechnung von H_T' [W/K]";

  //components
  Lib.Thermal.Resistor int_trans_resistor(R = param.R_si / A_set) "WUe innen";
  Lib.Thermal.Resistor cond_resistor1(R = param.R_cond / (2 * A_set)) "WL 1";
  Lib.Thermal.Capacity capacity(C = param.Cp_a * A_set, T_start=T_start) "WSp";
  Lib.Thermal.Resistor cond_resistor2(R = param.R_cond / (2 * A_set)) "WL 2";
  Lib.Thermal.Resistor ext_trans_resistor(R = param.R_se / A_set) "WUe auszen";
  Lib.DH.RadiationData rad_data(part=RadData) "Einstrahlungsdaten";
  Lib.Thermal.RadiationHeatSource rad_abs(A=A, alpha=param.alpha) "Absorption";
  Lib.Thermal.RadiationTransmission rad_trans(A=A, tau=param.tau) "Transmission";

  //connectors
  Lib.Thermal.Interfaces.HeatPort hp1 "Waerme innen";
  Lib.Thermal.Interfaces.HeatPort hp2 "Waerme auszen";
  Lib.RealOutput P_tsr "durchgelassene solare Einstrahlung [W]";

  //variables
  Real Q_flow;
  Real Q_balance(start=0, fixed=true);
  Real Q_flow_pos;
  Real Q_flow_neg;
  Real Q_pos(start=0, fixed=true);
  Real Q_neg(start=0, fixed=true);
  
  //eod

equation
  connect(hp1, int_trans_resistor.hp1);
  connect(int_trans_resistor.hp2, cond_resistor1.hp1);
  connect(cond_resistor1.hp2, cond_resistor2.hp1);
  connect(cond_resistor1.hp2, capacity.hp);
  connect(cond_resistor2.hp2, ext_trans_resistor.hp1);
  connect(ext_trans_resistor.hp2, hp2);

  connect(rad_abs.G, rad_data.G);
  connect(rad_abs.hp, cond_resistor2.hp2);
  connect(rad_trans.G, rad_data.G);
  connect(rad_trans.P_tsr, P_tsr);

  Q_flow = hp1.Q_flow;
  der(Q_balance) = Q_flow / 1000;

  Q_flow_pos = if noEvent(hp1.Q_flow > 0) then hp1.Q_flow else 0;
  Q_flow_neg = if noEvent(hp1.Q_flow < 0) then -hp1.Q_flow else 0;
  der(Q_pos) = Q_flow_pos / 1000;
  der(Q_neg) = Q_flow_neg / 1000;

end ConstructionSL2H1R;