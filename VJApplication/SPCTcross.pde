/*
 * 04: spectrum analyzer(cross)
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

class SPCTcross{
  private float[] fftBox;
  private float[] fftAlpha;
  private float[] fftPlus;
  
  private float offX, offY;
  private boolean echoSwitch;
  private float echoSpeed;
  private float bgColor;
  
  SPCTcross(float offX, float offY, boolean echoSwitch, float echoSpeed, float bgColor){
    this.offX = offX;
    this.offY = offY;
    this.echoSwitch = echoSwitch;
    this.echoSpeed = echoSpeed;
    this.bgColor = bgColor;
    
    fftBox = new float[fft.specSize()];
    fftAlpha = new float[fft.specSize()];
    fftPlus = new float[fft.specSize()];
    for(int i = 0; i < fft.specSize(); i++){
      fftAlpha[i] = 0;
      fftPlus[i] = 0;
    }
  }
  
  void setEchoSwitch(boolean echoSwitch){
    this.echoSwitch = echoSwitch;
  }
  
  void setEchoSpeed(float echoSpeed){
    this.echoSpeed = echoSpeed;
  }
  
  void setBgColor(float bgColor){
    this.bgColor = bgColor;
  }
  
  void exe(float w0, float h0){
    fft.forward(ai.mix);
    
    pushMatrix();
    translate(w0, h0);
    
    noStroke();
    fill(bgColor, 150, 150 - bgColor);
    rect(0, 0, offX, offY);
    
    for(int i = 0; i < fft.specSize(); i++){
      float x = map(i, 0, fft.specSize(), 0, offX);
      float y = map(i, 0, fft.specSize(), 0, offY);
      
      if(i % 5 == 0){
        if(echoSwitch){
          fill(fftBox[i] * 255, fftAlpha[i]);
          
          pushMatrix();
          translate(x, offY / 2, 0);
          box(fftBox[i] * 100, fftBox[i] * 100 + fftPlus[i], 0);
          popMatrix();
        
          pushMatrix();
          translate(offX / 2, y, 0);
          box(fftBox[i] * 100 + fftPlus[i], fftBox[i] * 100, 0);
          popMatrix();
        }
        
        fftPlus[i] += echoSpeed;
        fftAlpha[i] -= 3;
        
        fill(0, 255);
        
        pushMatrix();
        translate(x, offY / 2, 0);
        box(sqrt(fft.getBand(i)) * 100, sqrt(fft.getBand(i)) * 100, 0);
        popMatrix();
        
        pushMatrix();
        translate(offX / 2, y, 0);
        box(sqrt(fft.getBand(i)) * 100, sqrt(fft.getBand(i)) * 100, 0);
        popMatrix();
        
        if(fft.getBand(i) > fftBox[i]){
          fftAlpha[i] = 100;
          fftPlus[i] = 0;
          fftBox[i] = sqrt(fft.getBand(i));
        }
        if(fftAlpha[i] <= 0){
          fftBox[i] = 0;
        }
      }
    }
    
    popMatrix();
  }
}
