within Lib.Data;

function setReal
  input String path;
  input Real value;
algorithm
  Modelica.Utilities.Files.remove(path);
  Modelica.Utilities.Streams.print(String(value), path);
  Modelica.Utilities.Streams.close(path);
end setReal;