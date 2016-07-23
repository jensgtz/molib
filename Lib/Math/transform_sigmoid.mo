within Lib.Math;

function transform_sigmoid
  input Real x;
  input Real x_min;
  input Real x_max;
  input Real y_min;
  input Real y_max;
  output Real y;

protected
  Real x1;
  Real x2;

algorithm
  x1 := Lib.Math.transform_linear(x, x_min, x_max, -5, 5);
  x2 := 1 / (1 + Modelica.Constants.e^(-x1));
  y := Lib.Math.transform_linear(x2, 0, 1, y_min, y_max);

end transform_sigmoid;