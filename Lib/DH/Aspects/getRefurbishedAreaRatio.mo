within Lib.DH.Aspects;

function getRefurbishedAreaRatio
  output Real x_r;
protected
  Real A;
  Real A_r;
algorithm
  A := Lib.Data.sumReals(path="./com/construction_area.txt");
  A_r := Lib.Data.sumReals(path="./com/construction_refurbished_area.txt");
  x_r := A_r / A;
end getRefurbishedAreaRatio;