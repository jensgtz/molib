within Lib.Meteo.Solar;

/*
<DOC>
nach [Quasch11, S.68]

[http://insel.eu/fileadmin/insel.eu/diverseDokumente/diss_V.Quaschning.pdf # S. 104]:
"Temps und Coulson [3.29] entwickelten einen anisotropen Ansatz, der von Klucher [3.21]
erweitert wurde. Bei der Berechnung der diffusen Strahlung auf eine geneigte Flaeche wird
hierbei die Zunahme des Himmelslichtes in der Naehe des Horizontes und die zunehmende
Helligkeit in Sonnennaehe mit einbezogen"
</DOC>
*/

function DiffRadKlucher
  import Modelica.Math.cos;
  import Modelica.Math.sin;

  input Real gamma_surf "Neigungswinkel der Flaeche [rad]";
  input Real gamma_sun "Hoehenwinkel der Sonne [rad]";
  input Real phi "Einfallswinkel Sonne-Flaeche [rad]";
  input Real G_dir_hor "direkte Einstrahlung auf die Horizontale [W/m2]";
  input Real G_diff_hor "diffuse Einstrahlung auf die Horizontale [W/m2]";

  output Real G_diff "diffuse Einstrahlung auf die geneigte Flaeche [W/m2]";

protected
  Real G_glob_hor "Globalstrahlung auf die Horizontale [W/m2]";
  Real F "Faktor [1]";

algorithm
  G_glob_hor := G_dir_hor + G_diff_hor;
  if noEvent(G_glob_hor > 0) then
    F := 1 - (G_diff_hor / G_glob_hor)^2;
    G_diff := G_diff_hor * 0.5 * (1 + cos(gamma_surf)) * (1 + F * sin(0.5 * gamma_surf)^3) * (1 + F * (cos(phi)^2) * (cos(gamma_sun)^3));
    G_diff := max(0, G_diff);
  else
    F := 0;
    G_diff := 0;
  end if;

end DiffRadKlucher;