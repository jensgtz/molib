within Lib.Buildings.Ventilation;

/*
<DOC>
Lueftungsanlage 
- Berechnung der Waermerueckgewinnung ueber Waermebereitstellungsgrad
</DOC>
*/

model VentilationSystem
  extends Lib.Technical.TechObject;
  extends Lib.Economic.InvestmentObject;
  extends Lib.Environmental.EnvImpactObject;

  //parameters
  parameter Real n = 0.5 "Luftwechsel [1/h]";
  parameter Real V = 500 "belueftetes Volumen [m3]";
  parameter Real eta = 0 "Waermebereitstellungsgrad [1]";
  parameter Real rho = 1.2 "Dichte Luft [kg/m3]";
  parameter Real cp = 1000 "Spezif. Waermekapazitaet [J/(kg*K)]";
  parameter Real P_h_max = 2000 "max. Nachheiz-Leistung [W]";
  parameter Real a_h_dp = 0.1 "[1/h]";
  
  //components

  //connectors
  Lib.RealInput clock_hour "Uhrzeit [h]";
  Lib.RealInput P_h_set "Soll-Heizleistung [W]";
  Lib.Thermal.Interfaces.HeatPort hp_ext "Auszenluft";
  Lib.Thermal.Interfaces.HeatPort hp_int "Raumluft";
  Lib.Thermal.Interfaces.HeatPort hp_hw "Heizwasser";

  //variables
  Real mf "Massestrom [kg/h]";
  Real Qf "Waermestrom Abluft bzgl. T_ext [W]";
  Real Qf_in "Waermestrom Zuluft [W]";
  Real Qf_out "Waermestrom Fortluft [W]";
  Real T_in "Temperatur Zuluft [K]";
  Real T_out "Temperatur Fortluft [K]";
  Real P_h(start=0, fixed=true) "Nachheizleistung [W]";

  //eod

equation
  mf = n * V * rho;
  Qf = mf * cp * (hp_int.T - hp_ext.T) / 3600;  // [kg/h * J/(kg*K) * K * h/s] = [W]
  Qf_in = eta * Qf;
  Qf_out = (1 - eta) * Qf;
  T_in = hp_ext.T + Qf_in / (mf * cp) * 3600;  // [K + J/s * h/kg * (kg*K)/J * s/h] = [K] 
  T_out = hp_int.T - Qf_in / (mf * cp) * 3600;  // [K + J/s * h/kg * (kg*K)/J * s/h] = [K] 
  hp_int.Q_flow = Qf - Qf_in - P_h;
  hp_ext.Q_flow = -Qf_out;
  hp_hw.Q_flow = P_h;

  // Leistungsanpassung
  der(P_h) = max(-a_h_dp * P_h_max, min(a_h_dp * (P_h_set - P_h), a_h_dp * P_h_max));
  
algorithm
  when terminal() then
    eco__res.K_inv := 0;
    eco__res.K_serv := 0.02 * eco__res.K_inv;
    eco__res.K_op_e := 0;
    eco__res.K_op_ne := 0;
    eco__res.K_misc := 0;
    eco__res.T_n := 15;
    eco__res.f_r := 1;
    eco__res.flags := "";
    eco__res.action := 1;
    //
    env__res.T_n := 15;
    env__res.Q_e := 0;
    env__res.Q_p := 0;
    env__res.Q_pne := 0;
    env__res.KEA := 999;
    env__res.KEA_ne := 0;
  end when; 

end VentilationSystem;