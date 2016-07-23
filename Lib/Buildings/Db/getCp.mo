within Lib.Buildings.Db;

function getCp
  input Integer material_id;
  output Real cp;
algorithm
  cp := Lib.Data.pgReal("select cp from buildings.material where id=" + String(material_id));
end getCp;