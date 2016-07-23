within Lib.Electrical.Storages;

/*
<NOTES>
Aenderung 08.05.16:
  parameter Real eta_ch = 0.959 "[1]";
  parameter Real eta_dch = 0.959 "[1]"; 
  zu
  parameter Real eta_ch = 0.9705 "[1]";
  parameter Real eta_dch = 0.9705 "[1]";

Produktdatenblaetter
http://www.vaillant.de/heizung/produkte/systemerganzung/batteriespeicher/index.de_de.html
http://www.viessmann.de/de/wohngebaeude/kraft-waerme-kopplung/mikro-kwk-sterling/stromspeicher-systeme.html

---ECO---
Foerderprogramme Energiespeicher
netzgekoppelt: ja
netzautark: keine (?)

---ENV---
KEA_ne:
GNB Sonnenschein A412/65 -> Masse, 100% Blei,19 kg / (12 V * 50 Ah)
ProBas Blei 2010/2020 DE: 13.15 MJ/kg
</NOTES>
*/

model BatterySystem
  extends Lib.Technical.TechObject;
  extends Lib.Economic.InvestmentObject;
  extends Lib.Environmental.EnvImpactObject; 

  //parameters
  parameter Real C_bat = 12345 "Kapazitaet [Wh]";
  parameter Real SOC_min = 0.7 "minimaler Ladezustand [1]";
  parameter Real SOC_0 = 0.5 "Ladezustand zu Beginn [1]";
  parameter Real eta_ch = 0.959 "[1]";
  parameter Real eta_dch = 0.959 "[1]"; 
  parameter Real SDR = 0.03 / 720 "Selbstentladerate [1/h]";
  parameter Real eta_inv = 0.95 "[1]";
  parameter Real P_sc = 17 "[W]";

  //calculated
  parameter Real f_ex = if tech__exists then 1 else 0 "f_ex [1]";

  //components

  //connectors
  Lib.Electrical.Interfaces.AcPower ac "AC";
  Lib.RealOutput SOC_rel "rel. Ladezustand [1]";

  //variables
  Real P_ac "AC-Leistung [W]";
  Real P_dc "DC-Leistung [W]";
  Real P_bat "BAT-Leistung [W]";
  Real P_sd "Selbstentladung [W]";
  Real E_bat(start=SOC_0 * C_bat / 1000, fixed=true) "Energieinhalt [kWh]";
  Real SOC(start=if C_bat > 0 then SOC_0 else 0, fixed=true) "Ladezustand [1]";
  Real DOD_rel "rel. Entladezustand [1]";
  Real P_nch "Verlustleistung wegen Vollladung [W]";
  Real E_nch(start=0, fixed=true) "nicht gespeicherte Energie [kWh]";
  //eod

algorithm
  ac.f := 50;
  P_ac := f_ex * ac.p;

equation
  P_dc = if noEvent(P_ac > 0) then P_ac * eta_inv - P_sc else P_ac / eta_inv - f_ex * P_sc;
  P_sd = f_ex * SDR * E_bat;
  P_bat = if noEvent(P_dc > 0) then P_dc * eta_ch - P_sd else P_dc / eta_dch - P_sd;
  P_nch = if noEvent(SOC >= 1 and P_bat > 0) then P_bat else 0;
  der(E_nch) = P_nch / 1000;
  der(E_bat) = (P_bat - P_nch) / 1000;
  SOC = if noEvent(C_bat > 0) then E_bat / C_bat * 1000 else 0;
  DOD_rel = if noEvent(SOC < SOC_min) then 1 else (SOC - 1) / (SOC_min - 1);
  SOC_rel = 1 - DOD_rel;

algorithm
  when terminal() then
    eco__res.K_inv := 400 * C_bat / 1000;
    eco__res.K_serv := 0.04 * eco__res.K_inv;
    eco__res.K_op_e := 0;
    eco__res.K_op_ne := 0;
    eco__res.K_misc := 0;
    eco__res.T_n := 10;
    eco__res.f_r := 1;
    eco__res.flags := "cf_el=1";
    eco__res.action := if C_bat > 0 then 1 else 0;
    //
    env__res.T_n := 10;
    env__res.Q_e := 0;
    env__res.Q_p := 0;
    env__res.Q_pne := 0;
    env__res.KEA := 0;
    env__res.KEA_ne := 115.67 * C_bat / 1000;
  end when;

end BatterySystem;