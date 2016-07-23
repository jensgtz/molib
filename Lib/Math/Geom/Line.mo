within Lib.Math.Geom;

record Line
  Point p1;
  Point p2;
  
  function length
    input Line line;
    output Real L;
  algorithm
    L := Point.distance(line.p1, line.p2);
  end length;

end Line;