struct Point2D {
  unsigned long x;
  unsigned long y;
};

struct Point3D {
  unsigned long x;
  unsigned long y;
  unsigned long z;
};

struct Point2D plus(struct Point2D u, struct Point2D v)
{
  struct Point2D w;

  w.x = u.x + v.x;
  w.y = u.y + v.y;
  
  return w;
}

struct Point2D doubler(struct Point2D v)
{
  struct Point2D w;

  w = plus(v, v);

  return w;
}

struct Point3D etendre(struct Point2D v)
{
  struct Point3D w;

  w.x = v.x;
  w.y = v.y;
  w.z = 0;
  
  return w;
}

int main()
{
  struct Point2D v;

  v.x = 42;
  v.y = 9000;
  
  struct Point3D w = etendre(v);
}
