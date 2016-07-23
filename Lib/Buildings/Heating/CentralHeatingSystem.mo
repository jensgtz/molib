within Lib.Buildings.Heating;

/*
<DOC>
Indizes:
b2 ... 2. Kessel / Spitzenlastkessel
</DOC>
*/

model CentralHeatingSystem
  extends Lib.Technical.TechObject;
  extends Lib.Economic.InvestmentObject;
  extends Lib.Environmental.EnvImpactObject;

  //parameters
  parameter Real P_el_min = 600 "el. Leistung bei P_th_min BHKW [W]";
  parameter Real P_el_n = 1000 "el. Leistung bei P_th_n BHKW [W]";
  parameter Real P_th_min = 2000 "th. Mindestleistung BHKW bzw. Kessel 1 [W]";
  parameter Real P_th_n = 3000 "th. Nennleistung BHKW bzw. Kessel 1 [W]";
  parameter Real P_th_b2_min = 0 "th. Mindesleistung Kessel 2 [W]";
  parameter Real P_th_b2_n = 0 "th. Nennleistung Kessel 2 [W]";
  parameter Real V_hws = 100 "Wasserinhalt Waermespeicher [ltr]";

  //components
  Lib.Buildings.Heating.HeatingController controller "Heizungsregelung";
  Lib.Buildings.Heating.Boiler boiler "Heizkessel";
  Lib.CHP.MicroCogenerationUnit cogenunit "Mikro-BHKW";
  Lib.Buildings.Heating.StorageTank heatstore "Waermespeicher";
  Lib.Buildings.Heating.Heater heater "Heizgeraete";

  //connectors
  Lib.RealInput clock_hour "Uhrzeit";
  Lib.RealInput T_op_deg "Mittelwert operative Raumtemperatur EG und OG [degC]"; 
  Lib.Thermal.Interfaces.HeatPort hp_int "Raumluft beheizte Zone";
  Lib.Thermal.Interfaces.HeatPort hp_ext "Auszenluft";
  Lib.Thermal.Interfaces.HeatPort hp_inst "Raumluft Technikraum";
  Lib.Thermal.Interfaces.HeatPort hp_hws "Waermespeicher";
  Lib.Electrical.Interfaces.AcPower ac_aux "Strom";
  Lib.Electrical.Interfaces.AcPower ac_chp "KWK-Strom";
  Lib.RealInput P_el_bal "Leistungsbilanz Stromversorgung [W]";
  Lib.RealInput P_dump "Leistung Heizpatrone [W]";

  //variables
  //eod

equation
  // Heizungsregelung
  controller.clock_hour = clock_hour;
  controller.T_int = hp_int.T;
  controller.T_ext = hp_ext.T;
  controller.T_hws = hp_hws.T;
  connect(controller.B1_on, cogenunit.switch);
  connect(controller.B2_on, cogenunit.switch_sup);
  connect(controller.B2_on, boiler.switch);

  // Heizkessel
  connect(boiler.hp_hws, heatstore.hp);
  connect(boiler.ac_aux, ac_aux);

  // Mikro-BHKW
  connect(cogenunit.hp_hws, heatstore.hp);
  connect(cogenunit.ac_chp, ac_chp);
  connect(cogenunit.ac_aux, ac_aux);
  connect(cogenunit.P_el_bal, P_el_bal);

  // Waermespeicher
  connect(heatstore.hp, hp_hws);
  connect(heatstore.hp_air, hp_inst);
  connect(heatstore.P_dump, P_dump);
  connect(heatstore.SOC, controller.SOC_hws);

  // Waermeverteilung und Uebergabe (Heizgeraete)
  connect(heater.T_set, controller.T_set);
  connect(heater.T_op_deg, T_op_deg); 
  connect(heater.hp_int, hp_int);
  connect(heater.hp_hws, heatstore.hp);
  connect(heater.ac_aux, ac_aux);

  // nicht genutzte Verbindungen
  hp_ext.Q_flow = 0;

algorithm
  when terminal() then
    eco__res.K_inv := 0;
    eco__res.K_serv := 0.02 * eco__res.K_inv;
    eco__res.K_op_e := 0;
    eco__res.K_op_ne := 0;
    eco__res.K_misc := 0;
    eco__res.T_n := 20;
    eco__res.f_r := 1;
    eco__res.flags := "";
    eco__res.action := 1;
    //
    env__res.T_n := 0;
    env__res.Q_e := 0;
    env__res.Q_p := 0;
    env__res.Q_pne := 0;
    env__res.KEA := 0;
    env__res.KEA_ne := 0;
  end when; 

end CentralHeatingSystem;