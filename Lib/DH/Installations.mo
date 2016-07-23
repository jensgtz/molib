within Lib.DH;

/*
<DOC>
---
  hotwaterload.clock_hour = clock.hour_local;
  Lib.Electrical.PowerGrid pub_grid "oeffentl. Netz";
</DOC>
*/

/*
<NOTES>
//  Lib.Electrical.Meter main_meter "Hauptzaehler";
//  Lib.Electrical.Meter pv_meter "PV-Zaehler";
//  Lib.Electrical.Meter chp_meter "KWK-Zaehler";
</NOTES>
*/

model Installations
  //parameters
  parameter Real V_i_h = 280 "beheiztes Raumvolumen [m3]";

  //components
  Lib.Misc.Clock clock "Uhrzeit";
  //
  Lib.Electrical.PowerSupply power "Stromversorgung";
  Lib.Electrical.AcTerminal ac_term "Hauptverteilung";
  Lib.Electrical.Loads.TableLoad_NC el_load(E_a=4000) "el. Verbraucher";
  //
  Lib.Electrical.Photovoltaic.PVSystem pv_east(radPart="atre_G") "PV Ostdach";
  Lib.Electrical.Photovoltaic.PVSystem pv_west(radPart="atrw_G") "PV Westdach";
  //
  Lib.Buildings.Heating.DecentralisedSystem dcheatsys "dezentrale Heizung"; 
  Lib.Buildings.Heating.CentralHeatingSystem cheatsys "Zentralheizung";
  Lib.Buildings.Ventilation.VentilationSystem2 ventilation(V_i=V_i_h) "Lueftungsanlage";

  //TODO: useHWS=cheatsys.tech__exists
  Lib.Buildings.HotWater.TableLoad_VDI4655 hotwaterload "TWW-Verbrauch";
  
  //connectors
  Lib.Thermal.Interfaces.HeatPort hp_ext "Auszenluft";
  Lib.Thermal.Interfaces.HeatPort hp_at "Spitzboden";
  Lib.Thermal.Interfaces.HeatPort hp_gfuf "beheizte Zone (EG+OG)";
  Lib.Thermal.Interfaces.HeatPort hp_bm "Kellergeschoss";
  Lib.RealInput T_op_deg "Mittelwert operative Raumtemperatur EG und OG [degC]";
  Lib.RealInput x_air_ext "Wasserdampfgehalt Auszenluft [kg/kg]";
  Lib.RealInput n_nat "Luftwechselrate natuerliche Lueftung [1/h]";
  Lib.RealOutput n_vsys "Luftwechselrate Lueftungsanlage [1/h]";

  //variables
  Real E_n_el "Nutzenergie Strom [kWh]";
  Real E_n_rw(start=0, fixed=true) "Nutzenergie Raumwaerme [kWh]";
  Real E_n_tww "Nutzenergie TWW-Bereitung [kWh]";
  Real E_fuel "Endenergie Brennstoffe [kWh]";
  Real E_el_aux "elektrische Hilfsenergie [kWh]";
  Real E_e "Endenergie [kWh]";
  Real P_el_gen "Bilanz Erzeugung [W]";
  Real P_el_cons "Bilanz Verbrauch [W]";
  Real E_el_gen(start=0) "Bilanz Erzeugung [kWh]";
  Real E_el_cons(start=0) "Bilanz Verbrauch [kWh]";

  //eod

equation
  // Stromversorgung und Stromzaehler
  connect(power.ac, ac_term.ac);

  // Photovoltaik
  connect(pv_east.ac, ac_term.ac);
  connect(pv_east.ac_aux, ac_term.ac);
  connect(pv_west.ac, ac_term.ac);
  connect(pv_west.ac_aux, ac_term.ac);

  // elektrische Last
  connect(el_load.ac, ac_term.ac);

  // dezentrale Heizung
  dcheatsys.clock_hour = clock.hour_local;
  connect(dcheatsys.hp_int, hp_gfuf);

  // Zentralheizung
  cheatsys.clock_hour = clock.hour_local;
  connect(cheatsys.T_op_deg, T_op_deg);
  connect(cheatsys.hp_int, hp_gfuf);
  connect(cheatsys.hp_ext, hp_ext);
  connect(cheatsys.hp_inst, hp_bm);
  connect(cheatsys.ac_aux, ac_term.ac);
  connect(cheatsys.ac_chp, ac_term.ac);
  connect(power.P_dump, cheatsys.P_dump);
  // Leistungsbilanz power.ac.p > 0 fuer Einspeisung und power.ac.p < 0 fuer Bezug
  cheatsys.P_el_bal = -power.ac.p;

  // Lueftungsanlage
  connect(ventilation.clock_hour, clock.hour_local);
  connect(ventilation.hp_int, hp_gfuf);
  connect(ventilation.hp_ext, hp_ext);
  connect(ventilation.x_air_ext, x_air_ext);
  connect(ventilation.n_vsys, n_vsys);
  connect(ventilation.n_nat, n_nat);
  connect(ventilation.ac, ac_term.ac);

  // Warmwasserverbrauch
  connect(dcheatsys.hp_hw, hotwaterload.hp_dhw);
  connect(cheatsys.hp_hws, hotwaterload.hp_hws);

  // ungenutzte Ports
  hp_at.Q_flow = 0;


  // Nutzenergiebilanz
  E_n_el = el_load.E_el;
  E_n_rw = cheatsys.heater.Q_h + dcheatsys.woodstoves.Q_h;
  E_n_tww = hotwaterload.E_th;

  // Endenergiebilanz
  E_fuel = power.offgrid.generator.E_fuel + cheatsys.cogenunit.E_fuel + cheatsys.boiler.E_fuel;
  E_el_aux = cheatsys.cogenunit.E_el_aux + cheatsys.boiler.E_el_aux + cheatsys.heater.E_el_aux + ventilation.E_el_aux + pv_east.E_el_aux + pv_west.E_el_aux;
  E_e = E_fuel + power.grid.E_out - power.grid.E_in;

algorithm
  // Leistungsbilanz und Energieanteile
  P_el_gen := pv_east.P_el + pv_west.P_el + cheatsys.cogenunit.P_el + power.offgrid.generator.P_el + power.grid.P_out;
  P_el_cons := power.P_el - P_el_gen;
  if noEvent(P_el_gen > 0) then
    power.x_chp := cheatsys.cogenunit.P_el / P_el_gen;
    power.x_pv := (pv_east.P_el + pv_west.P_el) / P_el_gen;
  else
    power.x_chp := 0;
    power.x_pv := 0;
  end if;

equation
  der(E_el_gen) = P_el_gen / 1000;
  der(E_el_cons) = P_el_cons / 1000;

end Installations;