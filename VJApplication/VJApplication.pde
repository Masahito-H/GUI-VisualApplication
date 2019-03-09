/*
 * 00: VJ Application
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2017-2019 Masahito H.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import java.util.ArrayList;
import processing.opengl.*;

static float pointX, pointY;

Minim minim;
AudioInput ai;
FFT fft;

int rate;

int modeNo;
Mode modeStatus;
CELLbrain Cb;
CELLbrainMode mode1;
modeExpression lamp1;
SPCTorbit Eo;
SPCTorbitMode mode2;
modeExpression lamp2;
DBnumber Dn;
DBnumberMode mode3;
modeExpression lamp3;
SPCTcross Ec;
SPCTcrossMode mode4;
modeExpression lamp4;

modeExpression preLamp;

boolean starting;

void modeExe(int modeNo){
  preLamp.setMode(false);
  
  switch(modeNo){
    case 1: //frameRate(10)
            rate = 30;
            Cb.exe((int)(width * 0.1), 25);
            modeStatus = mode1;
            
            lamp1.setMode(true);
            preLamp = lamp1;
            break;
    case 2: //frameRate(60)
            rate = 1;
            Eo.exe((int)(width * 0.1), 25);
            modeStatus = mode2;
            
            lamp2.setMode(true);
            preLamp = lamp2;
            break;
    case 3: //frameRate(20)
            rate = 15;
            Dn.exe((int)(width * 0.1), 25);
            modeStatus = mode3;
            
            lamp3.setMode(true);
            preLamp = lamp3;
            break;
    case 4: //frameRate(60)
            rate = 5;
            Ec.exe((int)(width * 0.1), 25);
            modeStatus = mode4;
            
            lamp4.setMode(true);
            preLamp = lamp4;
            break;
  }
}

void startUp(){
  noStroke();
  fill(255);
  rect(0, 0, width, height);
  
  
}

void setup(){
  fullScreen(OPENGL);
//  size(1000, 1000, OPENGL);
  background(0);
  frameRate(300);
  smooth();
  
  minim = new Minim(this);
  ai = minim.getLineIn(Minim.STEREO, 512);
  fft = new FFT(ai.bufferSize(), ai.sampleRate());
  fft.forward(ai.mix);
  
  rate = 1;
  
  modeNo = 0;
  modeStatus = null;
  Cb = new CELLbrain((float)width * 0.8, (float)height * 0.8, 10.0 * 0.8, false, 1);
  mode1 = new CELLbrainMode(Cb);
  lamp1 = new modeExpression((int)(width / 5), "1. CELLbrain");
  Eo = new SPCTorbit((float)width * 0.8, (float)height * 0.8, 0, 0, 10, 0);
  mode2 = new SPCTorbitMode(Eo);
  lamp2 = new modeExpression((int)(width * 2 / 5), "2. SPCTorbit");
  Dn = new DBnumber((float)width * 0.8, (float)height * 0.8, 400, 5, 0);
  mode3 = new DBnumberMode(Dn);
  lamp3 = new modeExpression((int)(width * 3 / 5), "3. DBnumber");
  Ec = new SPCTcross((float)width * 0.8, (float)height * 0.8, false, 10, 0);
  mode4 = new SPCTcrossMode(Ec);
  lamp4 = new modeExpression((int)(width * 4 / 5), "4. SPCTcross");
  
  preLamp = new modeExpression(0, "");
  
  starting = true;
}

void draw(){
  if(frameCount % rate == 0){
    background(0, 0, 40);
    modeExe(modeNo);
  
  
  fill(255);
  if(modeStatus != null){
      modeStatus.GDraw();
    }
  lamp1.exe();
  lamp2.exe();
  lamp3.exe();
  lamp4.exe();
  }
/*  
  if(starting){
    
  }
*/
}

void keyReleased(){
  if(key == '1'){
    clear();
    modeNo = 1;
  }
  else if(key == '2'){    
    clear();
    modeNo = 2;
  }
  else if(key == '3'){
    clear();
    modeNo = 3;
  }
  else if(key == '4'){
    clear();
    modeNo = 4;
  }
}

void mousePressed(){
  if(modeStatus != null){
    modeStatus.setSelect();
  }
}

void mouseReleased(){
  if(modeStatus != null){
    modeStatus.operation();
  }
}

void mouseDragged(){
  if(modeStatus != null){
    modeStatus.operation();
  }
}
