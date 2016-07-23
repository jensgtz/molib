within Lib.Buildings.HotWater;

/*
<DOC>
[Pistohl13-1], Bd. 1, B37  
Standspeicher aus Kupfer, Zink oder emailliertem Stahlblech
innenliegendes Flammrohr
"dienen gleichzeitig der Beheizung des Bades"

Kosten:
- http://www.wuh24.de/Heizung/Badeoefen/Wittigsthal-Badeofen-100l-mit-Mischbatterie-weiss-und-Unterofen::15541.html

Umweltwirkungen:
- ...
</DOC>
*/

model BathWaterHeater
  extends Lib.Technical.TechObject;
  extends Lib.Economic.InvestmentObject;
  extends Lib.Environmental.EnvImpactObject;

  //parameters
  parameter Real P_n = 7500 "th. Leistung [W]";
  parameter Real V_w = 0.1 "Wasserinhalt [m3]";
  parameter Real D_e = 0.35 "Durchmesser Behaelter [m]";
  parameter Real D_i = 0.10 "Durchmesser Flammrohr [m]";

  //components
  Lib.Thermal.Capacity water "Wasser";
  Lib.Thermal.Resistor cover "Behaelter";
  Lib.Thermal.HeatSource firebox "Feuerung";

  //connectors
  Lib.RealInput clock_hour "Uhrzeit";
  Lib.Thermal.Interfaces.HeatPort hp_hw "Warmwasser";
  Lib.Thermal.Interfaces.HeatPort hp_air "Raumluft";
  //variables
  //eod

equation
  connect(firebox.hp, water.hp);
  connect(water.hp, hp_hw);
  connect(water.hp, cover.hp1);
  connect(cover.hp2, hp_air);

  // Feuerung
  firebox.P_th = 0;

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
    eco__res.action := 0;
    //
    env__res.T_n := 20;
    env__res.Q_e := 0;
    env__res.Q_p := 0;
    env__res.Q_pne := 0;
    env__res.KEA := 1500;
    env__res.KEA_ne := 0;
  end when;

end BathWaterHeater;