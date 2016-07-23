within Lib.Buildings.Db;

function getD
  input Integer construction_id;
  input Integer i_block;
  input Integer i_layer;
  output Real d;
algorithm
  d := Lib.Data.pgReal("select thickness from buildings.construction_layer where construction_id=" + String(construction_id) + " and block=" + String(i_block) + " and layer=" + String(i_layer));
end getD;