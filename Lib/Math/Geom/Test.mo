within Lib.Math.Geom;

class Test
  parameter Point p1(x = 0, y = 0);
  parameter Point p2(x = 10, y = 10);
  parameter Point p3(x = 20, y = 0);
  parameter Line line1(p1 = p1, p2 = p3);
  parameter Rect rect1(p1 = p1, p2 = p2);
  parameter Triangle tri1(p1 = p1, p2 = p2, p3 = p3);
  parameter Real d = Point.distance(p1, p2);
  Real L_line;
  Real A_rect;
  Real A_tri;
algorithm
  L_line := Line.length(line1);
  A_rect := Rect.area(rect1);
  A_tri := Triangle.area(tri1);
end Test;