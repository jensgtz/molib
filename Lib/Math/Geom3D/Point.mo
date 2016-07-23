within Lib.Math.Geom3D;

record Point
  Real x;
  Real y;
  Real z;

  function distance
    input Point p1;
    input Point p2;
    output Real d;
  algorithm
    d := sqrt((p2.x - p1.x) ^ 2 + (p2.y - p1.y) ^ 2 + (p2.z - p1.z) ^ 2);
  end distance;

end Point;