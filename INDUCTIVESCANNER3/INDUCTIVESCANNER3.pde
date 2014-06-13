import processing.serial.*;
import org.firmata.*;
import cc.arduino.*;

Arduino arduino;
Serial tinyg;
int feedrate = 2500;
int pause = 2000;
int sampleWindow = 50;
int sample =0;
//String[] points;
int[][] pointArray;
String[] newPointsArray;
StringList pointList;
String message;
int pointSpacing = 100; 
int numPointsX;
int numPointsY;
int numPoints;
int originX = 0;
int originY = 0;
int originZ = 0;
int pointX;
int pointY;

PrintWriter testOutput;



void setup() 
{
  size(200, 300, P3D);
  background(0);
  noLoop();
  pointList=new StringList();
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[12], 57600);
  arduino.pinMode(0, Arduino.INPUT);
  tinyg = new Serial(this, Serial.list()[13], 9600);
  //points = loadStrings("points.txt");
  tinyg.write("G0G21G90\n");
  testOutput = createWriter("testoutput.txt");
  numPointsX = width/pointSpacing;
  println("ptsX: "+numPointsX);
  numPointsY = height/pointSpacing;
  println("ptsY: "+numPointsY);
  numPoints=numPointsX*numPointsY;
  println("pts: "+numPoints);
  pointArray = new int[numPoints+numPoints/2][3];
  for (int x=0; x<numPointsX; x++)
  {
    if (x%2==0)
    {
      for (int y=numPointsY; y>=0; y--)
      {
        pointArray[((x*numPointsX)+(numPointsY-y))][0]=originX+(pointSpacing*x);
        pointArray[((x*numPointsX)+(numPointsY-y))][1]=originY+(pointSpacing*y);
        //println("Point "+x*y+": ");
        //printArray(points[x*y]);
        //println();
        testOutput.println(pointArray[((x*numPointsX)+(numPointsY-y))][0]+","+pointArray[((x*numPointsX)+(numPointsY-y))][1]);
      }
    }
    else
    {
      for (int y=0; y<=numPointsY; y++)
      {
        pointArray[(x*numPointsX)+y][0]=originX+(pointSpacing*x);
        pointArray[(x*numPointsX)+y][1]=originY+(pointSpacing*y);
        //println("Point "+(x*numPointsX)+y+": ");
        //printArray(points[(x*numPointsX)+y]);
        //println();
        testOutput.println(pointArray[(x*numPointsX)+y][0]+","+pointArray[(x*numPointsX)+y][1]);
        //println((x*numPointsX)+y);
      }
    }
  }
  testOutput.flush();
  testOutput.close();
}

void draw()
{
  for(int i=0; i<numPoints+numPoints/2; i++)
  {
    //print(pointArray[0][0]);
    pointX = pointArray[i][0];
    pointY = pointArray[i][1];
    message = "G1X"+pointX+"Y"+pointY+"F"+feedrate+"\n";
    print(message);
    tinyg.write(message);
    delay(pause);
    long startMillis= millis();  // Start of sample window
     int peakToPeak = 0;   // peak-to-peak level
     int signalMax = 0;
     int signalMin = 1024;
 
   // collect data for 50 mS
   while (millis() - startMillis < sampleWindow)
   {
      sample = arduino.analogRead(0);
      print("Sample: "+sample);
      if (sample < 1024)  // toss out spurious readings
      {
         if (sample > signalMax)
         {
            signalMax = sample;  // save just the max levels
         }
         else if (sample < signalMin)
         {
            signalMin = sample;  // save just the min levels
         }
      }
   }
   peakToPeak = signalMax - signalMin;  // max - min = peak-peak amplitude
   //println("Reading: "+peakToPeak);
   pointList.append(pointX+","+pointY+","+peakToPeak);
  }
  newPointsArray = pointList.array();
  saveStrings("scanpoints.txt", newPointsArray);
  print("END");
}
