within Lib.Economic;

function removeResults
protected
  constant String PATH = "./res/eco_res.csv";
algorithm
  Modelica.Utilities.Files.removeFile(PATH);
end removeResults;