within Lib.Buildings.Elements;

/*
<DOC>
Waermeuebergangswiderstaende nach DIN EN ISO 6946:2015-06 S.20
</DOC>
*/

model Wall
  extends Lib.Buildings.Elements.Construction(R_si=0.13, R_se=0.04);
end Wall;