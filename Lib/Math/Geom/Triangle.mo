within Lib.Math.Geom;

record Triangle
  Point p1;
  Point p2;
  Point p3;
  
  function area
    input Triangle triangle;
    output Real A;
  algorithm
    A := 0;
  end area;

end Triangle;