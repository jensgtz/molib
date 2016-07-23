within Lib.Meteo.Solar;

/*
<DOC>
nach [Quasch11] S. 68
</DOC>
*/

function DiffRadIsotrop

  import Modelica.Math.cos;

  input Real G_diff_hor "diffuse Einstrahlung auf die Horizontale [W/m2]";
  input Real gamma_surf "Neigungswinkel der Ebene [rad]";

  output Real G_diff "diffuse Einstrahlung auf geneigte Ebene [W/m2]";

algorithm
  G_diff := G_diff_hor * 0.5 * (1 + cos(gamma_surf));
  G_diff := max(0, G_diff);

end DiffRadIsotrop;