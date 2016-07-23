within Lib.Buildings.Db;

function getMaterial
  input Integer material_id;
  output Lib.Buildings.Db.Material material;
algorithm
  material.rho := Lib.Data.pgReal("select rho from buildings.material where id=" + String(material_id));
  material.lambda := Lib.Data.pgReal("select lambda from buildings.material where id=" + String(material_id));
  material.cp := Lib.Data.pgReal("select cp from buildings.material where id=" + String(material_id));
end getMaterial;