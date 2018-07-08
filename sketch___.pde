
import processing.serial.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import cc.arduino.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;
Arduino arduino;

int ledPin = 9; // LED connected to digital pin 12
int ledPin2 = 10; // LED connected to digital pin 1
int ledPin3 = 11; // LED connected to digital pin 0

float kickSize, snareSize, hatSize;

class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioPlayer source;
  
  BeatListener(BeatDetect beat, AudioPlayer source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }
  
  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }
  
  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}
PImage myImg;
PImage Img;
float a;
float b;
float c;
float d;
float star;
float x1;
float y1;
float X=60;

void setup(){
size(600,400);
myImg = loadImage("13.jpg");
 
  
  minim = new Minim(this);
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  
  song = minim.loadFile("marcus_kellis_theme.mp3", 1024);
  song.play();
  // a beat detection object that is FREQ_ENERGY mode that 
  // expects buffers the length of song's buffer size
  // and samples captured at songs's sample rate
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  // set the sensitivity to 300 milliseconds
  // After a beat has been detected, the algorithm will wait for 300 milliseconds 
  // before allowing another beat to be reported. You can use this to dampen the 
  // algorithm if it is giving too many false-positives. The default value is 10, 
  // which is essentially no damping. If you try to set the sensitivity to a negative value, 
  // an error will be reported and it will be set to 10 instead. 
  // note that what sensitivity you choose will depend a lot on what kind of audio 
  // you are analyzing. in this example, we use the same BeatDetect object for 
  // detecting kick, snare, and hat, but that this sensitivity is not especially great
  // for detecting snare reliably (though it's also possible that the range of frequencies
  // used by the isSnare method are not appropriate for the song).
  beat.setSensitivity(300);  
  kickSize = snareSize = hatSize = 16;
  // make a new beat listener, so that we won't miss any buffers for the analysis
  bl = new BeatListener(beat, song);  
  textFont(createFont("Helvetica", 16));
  textAlign(CENTER);
  arduino.pinMode(ledPin, Arduino.OUTPUT); 
  arduino.pinMode(ledPin2, Arduino.OUTPUT); 
  arduino.pinMode(ledPin3, Arduino.OUTPUT); 
}

boolean flag=true;
int x=50,y=20,drift,score=0,n=0,miss=0;
void draw(){
  background(0);
  if(beat.isKick()) {
      arduino.digitalWrite(ledPin, Arduino.HIGH); // set the LED on
      kickSize = 32;
  }
  if(beat.isSnare()) {
      arduino.digitalWrite(ledPin2, Arduino.HIGH); // set the LED on
      snareSize = 32;
  }
  if(beat.isHat()) {
      arduino.digitalWrite(ledPin3, Arduino.HIGH); // set the LED on
      hatSize = 32;
  }
  arduino.digitalWrite(ledPin, Arduino.LOW); // set the LED off
  arduino.digitalWrite(ledPin2, Arduino.LOW); // set the LED off
  arduino.digitalWrite(ledPin3, Arduino.LOW); // set the LED off
  strokeWeight(30);
  image(myImg,0,0,myImg.width*1.5,myImg.height*1.5); 
  
 frameRate(50);
  a=random(255);
 b=random(255);
 c=random(255);
 d=random(255);
 star=random(20  );
 x1=random(width);
 y1=random(height);     


 noStroke();
 fill(a,b,c,d);
 ellipse(x1,y1,star,star);
  if(flag==true){
    x=(int)random(20,width-20);
    drift=(int)random(256*6);
    flag=false;

  }

  myStroke(2*y+drift,120);
  line(x,y,x,y+5);
  y+=3;
  if(y>height){y=20;flag=true;n++;}
  
  stroke(0,b,c,150);
  strokeWeight(10);
  line(X-60,height-5,X+60,height-5);

  if(y>height-5 && x<X+60 && x>X-60){score++;}
  textSize(20);fill(255);text("score:"+score,200,30);
  miss=n-score;
  textSize(20);fill(255);text("miss:"+miss,400,30);
  if(n-score>=5){
    background(0,b,c,120);
    textSize(50);
    
    text("Game Over!",280,200);
  }
}

void keyPressed(){
  if(keyCode==LEFT){
    X=X-60;}
    if(keyCode==RIGHT){
      X=X+60;}
}
void stop() {
  // always close Minim audio classes when you are finished with them
  song.close();
  // always stop Minim before exiting
  minim.stop();
  // this closes the sketch
  super.stop();
}
