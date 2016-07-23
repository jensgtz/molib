within Lib.Math.Geom;

record Point
  Real x;
  Real y;
 
  function distance
    input Point p1;
    input Point p2;
    output Real d;
  algorithm
    d := sqrt((p2.x - p1.x) ^ 2 + (p2.y - p1.y) ^ 2);
  end distance;

end Point;