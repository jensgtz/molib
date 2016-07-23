within Lib.Data;

function delete
  input String path;
algorithm
  Modelica.Utilities.System.command("rm " + path);
end delete;