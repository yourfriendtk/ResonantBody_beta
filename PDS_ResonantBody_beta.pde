// http://www.youtube.com/watch?v=UWlTjUNoIB0 
// 23:37 -- interesting full range movement
// 6:30 - 7:30 -- active around throat an other higher ranges
// 30:00 - 32:00 -- very active
// 34:20 -- very active

import ddf.minim.analysis.*;
import ddf.minim.*;

int countPos = 7;
int countBand = 8;

float[] bandVals;
float[] temp;

float[] bandIn;
float[] bandOut ;

int bandAdd = 50;
int gap = 10;

float rad;
float damper;

Minim minim;
AudioInput in;
FFT fft;

int w;
int i;
int hVal;
float rWidth, rHeight;

int chakraColor[] = { 
  200, 180, 145, 108, 45, 20, 0
};

int xPos[] = { 
  10, 7, 6, 6, 6, 4, -3
};

int yPos[] = {
  60, 163, 318, 452, 583, 717, 828
};

float avgValues[];

PImage chakras;

float radLerp = 0.0;
float radLerp1 = 0.0;
float radLerp2 = 0.0;
float radLerp3 = 0.0;

void setup() {
  size(932, 883, P3D);
  chakras = loadImage("7chakras.jpg");

  bandVals = new float[countBand+1];
  temp = new float[countBand];

  bandVals[0] = 0.f;
  for (int i=1; i<countBand; i++) {
    bandVals[i] = bandAdd;
    bandAdd +=gap;
  }


  for (int i = 0; i < countBand; i++) {
    int sum = 0;
    for (int j = 0; j < i+1 ; j++) {
      sum += bandVals[j];
    }
    temp[i] = sum;
  }


  bandIn = new float[7];
  bandOut = new float[7];

  for (int i=0; i < temp.length-1; i++) {
    println(temp[i]);
    bandIn[i] = temp[i];
    bandOut[i] = temp[i+1];
  }

  for (int i=0; i<bandIn.length; i++) {
    println("bandin " + bandIn[i]);
  }

  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
  fft = new FFT(in.bufferSize(), in.sampleRate());

  rWidth = width * 0.99;
  rHeight = height * 0.99;
  hVal = 0;
}

void draw() {
  //background(0);
  image(chakras, 0, 0);

  fft.forward(in.mix);

  int t = 9;
  int r = 0;
  colorMode(HSB);

  for (int i=0; i<countPos; i++) {
    float rad = fft.calcAvg(bandIn[countPos - (i+1)], bandOut[countPos -(i+1)]) * t;
    radLerp = lerp(radLerp, rad, 0.9);
    radLerp1 = lerp(radLerp1, rad, 0.09);
    radLerp2 = lerp(radLerp2, rad, 0.009);
    radLerp3 = lerp(radLerp3, rad, 0.0009);

    noStroke();
    fill(chakraColor[i], 255, 255);
    ellipse(width/2 - xPos[i], yPos[i], rad, rad);

    noFill();
    strokeWeight(12);
    stroke(chakraColor[i], 132, 255);
    ellipse(width/2 - xPos[i], yPos[i], radLerp1, radLerp1);
    strokeWeight(6);
    stroke(chakraColor[i], 66, 255);
    ellipse(width/2 - xPos[i], yPos[i], radLerp2, radLerp2);
    strokeWeight(3);
    stroke(chakraColor[i], 0, 255);
    ellipse(width/2 - xPos[i], yPos[i], radLerp3, radLerp3);
  }
}

