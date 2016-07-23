within Lib.Math;

/*
<DOC>
sin(x)
[x] = deg
</DOC>
*/

function sin_deg
  import Modlica.Math.sin;
  import Modelica.Constants.pi;
  //
  input Real u "Winkel [deg]";
  output Real y "Zahl [1]";
algorithm
  y := sin(u / 180 * pi);
end sin_deg;