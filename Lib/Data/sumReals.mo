within Lib.Data;

function sumReals
  input String path;
  input Real dummy;
  output Real res;
protected
  Integer n;
  Integer i;
  Real s;
algorithm
  n := Modelica.Utilities.Streams.countLines(path);
  s := 0;
  for i in 1:n loop
    s := s + Modelica.Utilities.Strings.scanReal(Modelica.Utilities.Streams.readLine(path, i));
  end for;
  res := s;
end sumReals;