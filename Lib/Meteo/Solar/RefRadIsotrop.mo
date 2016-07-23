within Lib.Meteo.Solar;

/*
<DOC>
vgl. [Quasch11] S. 69
[http://insel.eu/fileadmin/insel.eu/diverseDokumente/diss_V.Quaschning.pdf # S. 103]: "nach Perez"
</DOC>
*/

function RefRadIsotrop
  import Modelica.Math.cos;
  //
  input Real G_glob_hor "Globalstrahlung auf die Horizontale [W/m2]";
  input Real Albedo "Albedo-Wert der Umgebung [1]";
  input Real gamma_surf "Neigung der Flaeche [rad]";
  //
  output Real G_ref "auf Flaeche reflektierte Strahlung [W/m2]";

algorithm
  G_ref := G_glob_hor * Albedo * 0.5 * (1 - cos(gamma_surf));
  G_ref := max(0, G_ref);

end RefRadIsotrop;