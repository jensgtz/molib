within Lib.Buildings.Constructions;

model Wall5
  //parameters
  parameter Integer construction_id = 1 "";
  parameter Real R_alpha_int = 0.1 "";
  parameter Real R_alpha_ext = 0.1 "";
  //components
  Lib.Buildings.Constructions.MultiLayer5 layers(construction_id=construction_id) "5 layers";
  Lib.Thermal.Resistor resistor_int(R=R_alpha_int);
  Lib.Thermal.Resistor resistor_ext(R=R_alpha_int);
  //connectors
  Lib.Thermal.Interfaces.HeatPort hp_ext "outside heatport";
  Lib.Thermal.Interfaces.HeatPort hp_int "inside heatport";
  //variables
  Real Q_balance(start=0, fixed=true) "balance of heat flow [kWh]";
  //eod
equation
  connect(hp_ext, resistor_ext.hp1);
  connect(resistor_ext.hp2, layers.hp1);
  connect(layers.hp2, resistor_int.hp1);
  connect(resistor_int.hp2, hp_int);
end Wall5;