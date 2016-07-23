within Lib.Buildings.Db;

model ULayer
  //parameters
  parameter Integer construction_id "db reference";
  parameter Real A = 1 "area [m2]";
  parameter Real Azimut = 0 "azimuth [deg]";
  parameter Real Slope = 90 "slope [deg]";
  parameter Real R_cond = Lib.Buildings.Db.getMeanR(construction_id) "[(m2*K)/W]";
  parameter Real Cp_a = Lib.Buildings.Db.getMeanCp(construction_id) "area specific thermal heat capacity [J/(m2*K)]";
  parameter Real T_start = 283.15 "start temperature [K]";
  parameter Real R_si = 0.10 "intern heat transfer resistance [(m2*K)/W]";
  parameter Real R_se = 0.04 "extern heat transfer resistance [(m2*K)/W]";

  //components
  Lib.Thermal.Resistor int_trans_resistor(R = R_si / A);
  Lib.Thermal.Resistor cond_resistor1(R = R_cond / (2 * A));
  Lib.Thermal.Capacity capacity(C = Cp_a * A, T_start=T_start);
  Lib.Thermal.Resistor cond_resistor2(R = R_cond / (2 * A));
  Lib.Thermal.Resistor ext_trans_resistor(R = R_se / A);

  //connectors
  Lib.Thermal.Interfaces.HeatPort hp1 "";
  Lib.Thermal.Interfaces.HeatPort hp2 "";
  
  //variables
  Real T_i;
  Real T_c;
  Real T_e;
  //
  Real Q_flow;
  Real Q_balance(start=0, fixed=true);
  Real Q_flow_pos;
  Real Q_flow_neg;
  Real Q_pos(start=0, fixed=true);
  Real Q_neg(start=0, fixed=true);
  //eod

equation
  connect(hp1, int_trans_resistor.hp1);
  connect(int_trans_resistor.hp2, cond_resistor1.hp1);
  connect(cond_resistor1.hp2, cond_resistor2.hp1);
  connect(cond_resistor1.hp2, capacity.hp);
  connect(cond_resistor2.hp2, ext_trans_resistor.hp1);
  connect(ext_trans_resistor.hp2, hp2);

  T_i = cond_resistor1.hp1.T;
  T_c = capacity.hp.T;
  T_e = cond_resistor2.hp2.T;
  Q_flow = hp1.Q_flow;
  der(Q_balance) = Q_flow / 1000;

  Q_flow_pos = if hp1.Q_flow > 0 then hp1.Q_flow else 0;
  Q_flow_neg = if hp1.Q_flow < 0 then -hp1.Q_flow else 0;
  der(Q_pos) = Q_flow_pos / 1000;
  der(Q_neg) = Q_flow_neg / 1000;
end ULayer;