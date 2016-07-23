within Lib.Electrical;

/*
<NOTES>
- Herausziehen der Bedingungen aus den when-Argumenten nach Empfehlung auf http://modref.xogeny.com/

--- removed---
  Boolean cond__dump_start "Bedingung Zuschalten Heizelement [-]";
  Boolean cond__dump_stop "Bedingung Abschalten Heizelement [-]";
  Boolean dumpload_on(start=false) "Ueberschusslast in Betrieb [-]";

  cond__dump_start = SOC_rel >= SOC_rel_start_dump;
  cond__dump_stop = SOC_rel <= SOC_rel_stop_dump;
  when {pre(cond__dump_start), pre(cond__dump_stop)} then
    dumpload_on = pre(cond__dump_start);
  end when;
  dumpload.P_set =  if noEvent(dumpload_on and is_installed) then P_dump_n else 0;
</NOTES>
*/

model OffGridSystem

  //parameters
  parameter Boolean is_installed = true "installiert ja/nein [-]";
  parameter Real C_bat = 20000 "Kapazitaet Batteriesystem [Wh]";
  parameter Real P_gen = 3000 "el. Nennleistung Stromaggregat [W]";
  parameter Real SOC_rel_start_gen = 0.1 "SOC_rel fuer Start GEN [1]";
  parameter Real SOC_rel_stop_gen = 0.4 "SOC_rel fuer Stopp GEN [1]";
  parameter Real P_dump_n = 1000 "elektrische Nennleistung Heizelement [1]";
  parameter Real SOC_rel_start_dump = 0.995 "SOC_rel fuer Start DUMP [1]";
  parameter Real SOC_rel_stop_dump = 0.985 "SOC_rel fuer Stopp DUMP [1]";

  //calculated
  parameter Real f_ex = if is_installed then 1 else 0 "f_ex [1]";

  //components
  Lib.Electrical.Storages.BatterySystem battery(C_bat=C_bat, tech__exists=is_installed) "Batteriesystem";
  Lib.Electrical.Generators.Generator generator(P_n=P_gen, tech__exists=is_installed) "Stromaggregat";
  Lib.Electrical.Loads.AcLoad0 dumpload "Heizelement";

  //connectors
  Lib.Electrical.Interfaces.AcPower ac "AC-Knoten";
  Lib.RealOutput SOC_rel "Batterie-Status SOC_rel [1]";
  Lib.RealOutput P_dump "Leistung Heizelement [W]";

  //variables
  Boolean generator_on(start=is_installed) "Stromaggregat in Betrieb [-]";
  Boolean cond__gen_start "Bedingung Generatorstart [-]";
  Boolean cond__gen_stop "Bedingung Generatorstopp [-]";

  //eod

equation
  // Batteriesystem
  connect(ac, battery.ac);
  connect(SOC_rel, battery.SOC_rel);

  // Stromaggregat
  connect(ac, generator.ac);
  cond__gen_start = SOC_rel <= SOC_rel_start_gen;
  cond__gen_stop = SOC_rel > SOC_rel_stop_gen;
  when {pre(cond__gen_start), pre(cond__gen_stop)} then
    generator_on = pre(cond__gen_start);
  end when;
  generator.f_set = if generator_on and is_installed then 1 else 0;

  // Heizelement
  connect(ac, dumpload.ac);
  P_dump = 1 / (1 + exp(1000 * ( ((SOC_rel_start_dump + SOC_rel_stop_dump) / 2) - SOC_rel) ) ) * P_dump_n * f_ex;
  dumpload.P_el_set = P_dump;

end OffGridSystem;