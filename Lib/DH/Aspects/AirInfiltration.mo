within Lib.DH.Aspects;

/*
<DOC>
Luftwechsel in Abhaengigkeitr der Luftdichtheit des Gebaeudes
Annahme: linear sinkend mit steigendem sanierten Flaechenanteil
Formel:
n_50(x_san, n_san, n_unsan):=(n_san-n_unsan)*x_san+n_unsan;
</DOC>
*/

model AirInfiltration
  //parameters
  parameter Real n_0 = 4 "Luftwechsel im unsanierten Zustand [1/h]";
  parameter Real n_1 = 0.5 "Luftwechsel bei voller Sanierung der Gebaeudehuelle [1/h]";
  //components
  //connectors
  //variables
  Real x_r(start=0, fixed=true) "Flaechenanteil, saniert [1]";
  //eod

equation
  when time > 0.01 then
    x_r = getRefurbishedAreaRatio();
  end when;
end AirInfiltration;