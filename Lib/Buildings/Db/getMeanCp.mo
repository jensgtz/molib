within Lib.Buildings.Db;

function getMeanCp
  input Integer construction_id;
  output Real mean_cp;
algorithm
  mean_cp := Lib.Data.pgReal("select mean_cp from buildings.construction where id=" + String(construction_id));
end getMeanCp;