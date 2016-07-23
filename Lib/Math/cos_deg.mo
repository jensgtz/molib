within Lib.Math;

/*
<DOC>
cos(x)
[x] = deg
</DOC>
*/

function cos_deg
  import Modlica.Math.cos;
  import Modelica.Constants.pi;
  //
  input Real u "Winkel [deg]";
  output Real y "Zahl [1]";
algorithm
  y := cos(u / 180 * pi);
end cos_deg;