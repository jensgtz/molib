within Lib.Buildings.Db;

model MultiLayer5
  //parameters
  parameter Integer construction_id = 1 "";
  parameter Real A = 1 "area [m2]";
  //components
  Lib.Buildings.Db.Layer layer1(construction_id=construction_id, i_layer=1, i_block=1, A=A);
  Lib.Buildings.Db.Layer layer2(construction_id=construction_id, i_layer=2, i_block=1, A=A);
  Lib.Buildings.Db.Layer layer3(construction_id=construction_id, i_layer=3, i_block=1, A=A);
  Lib.Buildings.Db.Layer layer4(construction_id=construction_id, i_layer=4, i_block=1, A=A);
  Lib.Buildings.Db.Layer layer5(construction_id=construction_id, i_layer=5, i_block=1, A=A);
  //connectors
  Lib.Thermal.Interfaces.HeatPort hp1 "first / left / outside heatport";
  Lib.Thermal.Interfaces.HeatPort hp2 "second / right / inside heatport";
  //variables
  //eod
equation
  connect(hp1, layer1.hp1);
  connect(layer1.hp2, layer2.hp1);
  connect(layer2.hp2, layer3.hp1);
  connect(layer3.hp2, layer4.hp1);
  connect(layer4.hp2, layer5.hp1);
  connect(layer5.hp2, hp2);
end MultiLayer5;