within Lib.Electrical.Loads;

/*
<NOTES>
* ein- oder mehrstufige Regelung implementieren
</NOTES>
*/

model DumpLoad
  extends Lib.Technical.TechObject;
  extends Lib.Economic.InvestmentObject;
  extends Lib.Environmental.EnvImpactObject; 
  extends Lib.Electrical.Loads.AcLoad;

  //parameters

  //components

  //connectors
  Lib.Thermal.Interfaces.HeatPort hp "Waerme";
  
  //variables

  //eod

equation
  hp.Q_flow = -P_el;

algorithm
  when terminal() then
    eco__res.K_inv := if tech__exists then 100 * P_n / 1000 else 0;
    eco__res.K_serv := 0.04 * eco__res.K_inv;
    eco__res.K_op_e := 0;
    eco__res.K_op_ne := 0;
    eco__res.K_misc := 0;
    eco__res.T_n := 10;
    eco__res.f_r := 1;
    eco__res.flags := "";
    eco__res.action := 1;
    //
    env__res.T_n := 10;
    env__res.Q_e := 0;
    env__res.Q_p := 0;
    env__res.Q_pne := 0;
    env__res.KEA := 0;
    env__res.KEA_ne := 0;
  end when;

end DumpLoad;