within Lib.Meteo.Solar;

/*
<DOC>
eigene stark vereinfachte Berechnung
- Hintergrund / Annahme: isotrop / Strahlungsdichte auf Halbkugeloberflaeche  ueber der geneigten Flaeche an jedem Punkt gleich
- Horizont ist durchgehend gleich hoch -> erzeugt einen keilfoermigen Schatten

Die Berechnung sollte eigentlich das Verhaeltnis der durch einen Keil verminderten 
Halbkugel-Oberflaeche zur vollen Halbkugel-Oberflaeche liefern.

Derzeit: halbierter Zylinder, Seitenflaechen nicht beruecksichtigt
</DOC>
*/

function ShadedDiffRad
  import Modelica.Constants.pi;
  //
  input Real gamma_surface "Neigungswinkel der Ebene [rad]";
  input Real gamma_horizon "Hoehenwinkel Horizont [rad]";
  //
  output Real S "Verschattungsfaktor [1]";

algorithm
  S := 1 - (pi - gamma_surface - gamma_horizon) / pi;

end ShadedDiffRad;