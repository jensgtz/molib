within Lib.Electrical.Photovoltaic;

/*
<DOC>
PV-Anlage, einfaches η-Modell
</DOC>
*/

model System1
  extends Lib.Electrical.EMS_Device;
  extends Lib.Economic.InvestmentObject;

  //parameters
  parameter Real N_mod = 1 "Anzahl Module [1]";
  parameter Real A_mod = 1 "Flaeche eines Modules [m2]";
  parameter Real eta_mod = 0.21 "Modul-Wirkungsgrad [deg]";
  parameter Real eta_inv = 0.95 "Wechselrichter-Wirkungsgrad [deg]";
  //
  parameter Real P_inst = N_mod * A_mod * 1000 * eta_mod;
  parameter Real K_inv = P_inst / 1000 * 1500;

  //components

  //connectors
  Lib.RealInput G "Einstrahlung [W/m2]";

  //variables

  //eod

equation
  P_el = -1 * N_mod * A_mod * G * eta_mod * eta_inv;

  //EMS  
  P_el_pos = 0;
  P_el_neg = -P_el;
  K_el_pos = 1;
  K_el_neg = 1;

algorithm
  when terminal() then
    eco__res.K_inv := 1500 * P_inst / 1000;
    eco__res.K_serv := 0.02 * eco_res.K_inv;
    eco__res.K_op_e := 0;
    eco__res.K_op_ne := 0;
    eco__res.K_misc := 0;
    eco__res.T_n := 20;
    eco__res.f_r := 1;
    eco__res.flags := "KfW910+BAFA_1";
    eco__res.action := 1;
  end when;

end System1;