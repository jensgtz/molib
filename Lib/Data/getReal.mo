within Lib.Data;

function getReal
  input String path;
  input Real dummy;
  output Real res;
protected
  String s;
  Integer n;
  Boolean e;
algorithm
  n := Modelica.Utilities.Streams.countLines(path);
  (s, e) := Modelica.Utilities.Streams.readLine(path, n);
  Modelica.Utilities.Streams.close(path);
  res := Modelica.Utilities.Strings.scanReal(s);
end getReal;