/*
 * 02: spectrum analyzer(orbit)
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

class SPCTorbit{
  private GrainOrbit Gob;
  private float[] spctsave;
  
  private float offX, offY;
  private float area;
  private float spiral;
  private float lambda;
  private float shock;
  
  SPCTorbit(float offX, float offY, float area, float spiral, float lambda, float shock){
    this.offX = offX;
    this.offY = offY;
    this.area = area;
    this.spiral = spiral;
    this.lambda = lambda;
    this.shock = shock;
    
    spctsave = new float[fft.specSize() / 5 + 1];
    for(int i = 0; i < fft.specSize(); i += 5){
      spctsave[i / 5] = fft.getBand(i);
    }
    
    Gob = new GrainOrbit();
    Gob.exe(spctsave, offX, offY, spiral, lambda, shock);
    background(0);
  }
  
  void setArea(float area){
    this.area = area;
  }
  void setSpiral(float spiral){
    this.spiral = spiral;
  }
  void setLambda(float lambda){
    this.lambda = lambda;
  }
  void setShock(float shock){
    this.shock = shock;
  }
  
  void exe(int w0, int h0){   
    noStroke();
    fill(0, 30, 30, 255);
    pushMatrix();
    translate(w0 + offX / 2, h0 + offY / 2, -500);
    rect(-area, -area, area * 2, area * 2);
    popMatrix();
    fill(0, 30, 30, 255);
    
    fft.forward(ai.mix);
    spctsave = new float[fft.specSize() / 5 + 1];
    for(int i = 0; i < fft.specSize(); i += 5){
      spctsave[i / 5] = fft.getBand(i);
    }
    Gob.reexe(spctsave, offX, offY, spiral, lambda, shock);
    
    pushMatrix();
    fill(0, 0, 40);
    rect(0, 0, w0, height);
    rect(w0 + offX, 0, width - (w0 + offX), height);
    rect(0, 0, width, h0);
    rect(0, h0 + offY, width, height - (h0 + offY));
    translate(w0, h0);
    popMatrix();
  }
}
