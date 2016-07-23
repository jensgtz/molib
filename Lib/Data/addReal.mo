within Lib.Data;

function addReal
  input String path;
  input Real value;
algorithm
  Modelica.Utilities.Streams.print(String(value), path);
  Modelica.Utilities.Streams.close(path);
end addReal;