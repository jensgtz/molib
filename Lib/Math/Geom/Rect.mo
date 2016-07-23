within Lib.Math.Geom;

record Rect
  Point p1;
  Point p2;
  
  function area
    input Rect rect;
    output Real A;
  algorithm
    //todo: +noEvent
    A := abs(rect.p2.x - rect.p1.x) * abs(rect.p2.y - rect.p1.y);
  end area;

end Rect;