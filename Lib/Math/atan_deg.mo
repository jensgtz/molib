within Lib.Math;

/*
<DOC>
liefert atan(x) in Grad
</DOC>
*/

function atan_deg
  input Real u;
  output Real y;
algorithm
  y := Modelica.Math.atan(u) * 180 / Modelica.Constants.pi;
end atan_deg;