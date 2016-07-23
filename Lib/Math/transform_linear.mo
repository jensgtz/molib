within Lib.Math;

function transform_linear
  input Real x;
  input Real x_min;
  input Real x_max;
  input Real y_min;
  input Real y_max;
  output Real y;

algorithm
  y := (y_max - y_min) / (x_max - x_min) * (x - x_min) + y_min;

end transform_linear;