within Lib.Math;

function inRange
  input Real x_min;
  input Real x;
  input Real x_max;
  output Real y;
algorithm
  y := if x < x_min then x_min else if x > x_max then x_max else x;
end inRange;