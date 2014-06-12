int pointSpacing = 100; 
int numPointsX;
int numPointsY;
int numPoints;
int originX = 0;
int originY = 0;
int originZ = 0;

PrintWriter output;

void setup()
{
  size(300, 200, P3D);
  background(0);
  output = createWriter("newpts.txt");
  numPointsX = width/pointSpacing;
  println("ptsX: "+numPointsX);
  numPointsY = height/pointSpacing;
  println("ptsY: "+numPointsY);
  numPoints=numPointsX*numPointsY;
  println("pts: "+numPoints);
  int[][] points = new int[numPoints+10][3];
  for (int x=0; x<numPointsX; x++)
  {
//    if (x%2==0)
//    {
//      for (int y=numPointsY; y>=0; y--)
//      {
//        points[x*y][0]=originX+(pointSpacing*x);
//        points[x*y][1]=originY+(pointSpacing*y);
//        println("Point "+x*y+": ");
//        printArray(points[x*y]);
//        println();
//        output.println(points[x*y][0]+","+points[x*y][1]);
//      }
//    }
//    else
//    {
      for (int y=0; y<=numPointsY; y++)
      {
        points[(x*numPointsX)+y][0]=originX+(pointSpacing*x);
        points[(x*numPointsX)+y][1]=originY+(pointSpacing*y);
        //println("Point "+(x*numPointsX)+y+": ");
        //printArray(points[(x*numPointsX)+y]);
        //println();
        //output.println(points[(x*numPointsX)+y][0]+","+points[(x*numPointsX)+y][1]);
        println((x*numPointsX)+y);
      }
    //}
  }
  output.flush();
  output.close();
  exit();
}

void draw()
{
}

