import processing.serial.*;
import org.firmata.*;
import cc.arduino.*;

Arduino arduino;
Serial tinyg;
int feedrate = 2500;
int pause = 2000;
int sampleWindow = 50;
int sample =0;
String[] points;
String[] newPoints;
StringList output;
String message;

void setup() 
{
  output=new StringList();
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[1], 57600);
  tinyg = new Serial(this, Serial.list()[2], 9600);
  points = loadStrings("points.txt");
  tinyg.write("G0G21G90\n");
  noLoop();
}

void draw()
{
  for(int i=0; i<points.length; i++)
  {
    
    String point = points[i];
    String[] tuple = split(point, ',');
    String pointx = tuple[0];
    String pointy = tuple[1];
    message = "G1X"+pointx+"Y"+pointy+"F"+feedrate+"\n";
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
      sample = arduino.analogRead(5);
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
   output.append(pointx+","+pointy+","+peakToPeak);
  }
  newPoints = output.array();
  saveStrings("output.txt", newPoints);
  print("END");
}
