within Lib.Electrical.Generators;

/*
<DOC>
Stromaggregat

  t_op(start=0, fixed=true) "Betriebszeit, kumulierte [h]";
  t_op_cur(start=0, fixed=true) "Betriebszeit, aktuelle [h]";
  t_op_start(start=0) "Zeitpunkt letzter Generatorstart [h]";
</DOC>
*/

/*
<NOTES>
parameter Real rho_fuel = 0.84 "Dichte des Kraftstoffes [kg/ltr]";
  parameter Real H_i_fuel = 11.8 "Heizwert des Kraftstoffes [kWh/kg]";
protected
  Modelica.Blocks.Tables.CombiTable1D eta_table(table=[0.0, 0.0; 0.1, 0.05; 0.2, 0.10; 0.3, 0.15; 0.4, 0.18; 0.5, 0.20; 0.6, 0.22; 0.7, 0.23; 0.8, 0.24; 0.9, 0.245; 1.0, 0.25]) "Wirkungsgrad-Kennlinie";

---
KEA_ne: 100% Stahl, ProBas 2010/2020
---
Zeitkonstante hinsichtlich Simulationsgeschwindigkeit unverhaeltnismaeszig hoch
</NOTES>
*/

model Generator
  extends Lib.Technical.TechObject;
  extends Lib.Economic.InvestmentObject;
  extends Lib.Environmental.EnvImpactObject; 

  //parameters
  parameter Real P_n = 1000 "Nennleistung [W]";
  parameter Real eta = 0.25 "Wirkungsgrad, gesamt [1]";
  parameter Real tau = 0.1 "Zeitkonstante [h]";
  parameter Real fuel__k = 0.110977 "Brennstoffkosten, brt. [EUR/kWh]";
  parameter Real fuel__f_p = 1.1 "Primaerenergiefaktor Brennstoff [1]";
  parameter Real fuel__f_pne = 1.1 "Primaerenergiefaktor, nicht-erneuerbar [1]";
  
  //calculated
  parameter Real f_ex = if P_n > 0 then 1 else 0 "f_ex [1]";

  //components

  //connectors
  Lib.Electrical.Interfaces.AcPower ac "AC-Knoten";
  Lib.RealInput f_set "relative Soll-Leistung [1]";

  //variables
  Real P_el(start=0, fixed=true) "el. Leistung [W]";
  Real E_el(start=0, fixed=true) "el. Energie [kWh]";
  Real E_fuel(start=0, fixed=true) "Endenergie Brennstoff [kWh]";
  //
  Real E_el_err1(start=0, fixed=true) "Leistungsaufnahme, Testwert1 [kWh]";
  //eod


equation
  tau * der(P_el) = f_ex * (f_set * P_n - P_el);
  der(E_el) = P_el / 1000;
  der(E_fuel) = P_el / (eta * 1000);
  ac.p = -P_el;
  der(E_el_err1) = if noEvent(P_el < 0) then -P_el else 0;

algorithm
  when terminal() then
    eco__res.K_inv := 750 * P_n / 1000;
    eco__res.K_serv := 0.08 * eco__res.K_inv;
    eco__res.K_op_e := fuel__k * E_fuel;
    eco__res.K_op_ne := 0;
    eco__res.K_misc := 0;
    eco__res.T_n := 10;
    eco__res.f_r := 1;
    eco__res.flags := "cf_el=1";
    eco__res.action := if P_n > 0 then 1 else 0;
    //
    env__res.T_n := tech__TL;
    env__res.Q_e := E_fuel;
    env__res.Q_p := fuel__f_p * E_fuel;
    env__res.Q_pne := fuel__f_pne * E_fuel;
    env__res.KEA := 0;
    env__res.KEA_ne := (0.014*P_n+16.444) * 15.75 / 3.6;
  end when;

end Generator;