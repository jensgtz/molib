within Lib.Electrical.Storages;

/*
<DOC>
einfaches Speicher-Modell

http://ba.localhost/img/Documentation/Electrical/Storages/Battery/Battery.pdf
</DOC>
*/

model Battery
  extends Lib.Electrical.EMS_Device;
  extends Lib.Economic.InvestmentObject;

  //parameters
  parameter Real C = 1 "Kapazitaet [kWh]";
  parameter Real SOC_0 = 0.5 "Ladezustand zu Beginn [1]";
  parameter Real SOC_min = 0.5 "minimaler Ladezustand [1]";
  parameter Real eta_ch = 0.92 "Ladewirkungsgrad [1]";
  parameter Real eta_dch = 0.92 "Entladewirkungsgrad [1]";
  parameter Real P_ch_max = 500 * C "max. Ladeleistung, Betrag [W]";
  parameter Real P_dch_max = 500 * C "max. Entladeleistung, Betrag [W]";
  parameter Real dP_n = 1000 "Leistungsgradient [W/s]";
  //INV
  parameter Real eta_inv = 0.95 "Wirkungsgrad Wechselrichter [1]";

  //components

  //connectors
  Lib.Electrical.Interfaces.AcPower ac "AC";

  //variables
  Real E_bat(start=C*SOC_0, fixed=true) "Energieinhalt [kWh]";
  Real P_bat "Leistung [W]";
  Real SOC(start=SOC_0) "Ladezustand [1]";
  Real DOD_rel "relative Entladetiefe [1]";
  Real F_ch "Faktor Laden [1]";
  Real F_dch "Faktor Entladen [1]";
  Real P_act_ch_max "[W]";
  Real P_act_dch_max "[W]";
  Real P_bat_ch "[W]";
  Real P_bat_dch "[W]";
  //eod

protected
  Real P_set;

equation
  SOC = E_bat / C;
  DOD_rel = if SOC < SOC_min then 1 else 1 - (1 / (1-SOC_min)) * (SOC-SOC_min);
  F_ch = if SOC < 0.8 then 1 else (-1 / 0.2) * (SOC - 0.8) + 1;
  F_dch = if DOD_rel < 0.8 then 1 else if DOD_rel >= 1.0 then 0 else 1 - (DOD_rel - 0.8) / 0.2;
  P_act_ch_max = F_ch * P_ch_max;
  P_act_dch_max = F_dch * P_dch_max;
  //
  P_set = Lib.Math.inRange(-P_act_dch_max, emb.P_set, P_act_ch_max);
  der(P_el) = (P_set - P_el) / ((P_ch_max + P_dch_max) / 2) * (dP_n * 3600);
  //
  P_bat_ch = eta_ch * P_el;
  P_bat_dch = P_el / eta_dch;
  P_bat = if P_el < 0 then P_bat_dch else P_bat_ch;
  der(E_bat) = P_bat / 1000;

  //EMS
  P_el_pos = P_el + P_act_dch_max;
  P_el_neg = P_act_ch_max - P_el;
  K_el_pos = 0.5;
  K_el_neg = 0.5;

algorithm
  when terminal() then
    eco__res.K_inv := 500 * C;
    eco__res.K_serv := 0.02 * eco_res.K_inv;
    eco__res.K_op_e := 0;
    eco__res.K_op_ne := 0;
    eco__res.K_misc := 0;
    eco__res.T_n := 10;
    eco__res.f_r := 1;
    eco__res.flags := "KfW940";
    eco__res.action := 1;
  end when;

end Battery;