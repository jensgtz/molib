within Lib.Buildings.Db;

function getMaterialID
  input Integer construction_id;
  input Integer i_layer;
  input Integer i_block;
  output Integer material_id;
algorithm
  material_id := Lib.Data.pgInt("select material_id from buildings.construction_layer where construction_id=" + String(construction_id) + " and layer=" + String(i_layer) + " and block=" + String(i_block));
end getMaterialID;