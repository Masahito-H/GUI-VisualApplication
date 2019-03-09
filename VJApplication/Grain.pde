/*
 * 04a: spectrum classes
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

class GrainBar {
  private int n;
  private float[] save;
  private float x;
  private ArrayList<Float> rans;

  GrainBar(int tl, float[] spctsave) {
    n = tl;
    save = spctsave;
    x = map(n, 0, fft.specSize(), 0, 2 * PI);
    
    rans = new ArrayList<Float>();
    for(int i = 0; i < fft.specSize(); i += 10){
      rans.add(random(75));
    }
  }
  GrainBar(GrainBar GB) {
    this.n = GB.n;
    this.save = GB.save;
    this.x = GB.x;
    this.rans = GB.rans;
  }

  void change(int tl) {
    n = tl;
    x = map(n, 0, fft.specSize(), 0, 2 * PI);
  }

  int getN() {
    return n;
  }

  void exe(float offX, float offY, float shock) {    
    for (int i = 0; i < fft.specSize(); i += 10) {
      float y = map(i, 0, fft.specSize(), 0, height / 4);

      pushMatrix();
      translate(0, offY / 2, 0);
      rotateX(PI * 5 / 8);
      translate((y + 400) * sin(x) * (offX / width), ((y + 250) * cos(x) + height / 8) * (offY / height) - ai.mix.get(0) * rans.get(i / 10) * shock, 0);
      noStroke();
      fill(save[i / 5] * 255, 0, 255 - save[i / 5] * 255);
      box(5, 5, 0);
      popMatrix();
    }
  }
}

class GrainSPCT {
  protected ArrayList<GrainBar> lst;

  GrainSPCT() {
    lst = new ArrayList<GrainBar>();
  }

  void exe(float[] spctsave, float offX, float offY, float shock) {  
    pushMatrix();
    translate(width / 2, 0, 0);

    for (int i = 0; i < fft.specSize(); i += 1) {
      GrainBar GB = new GrainBar(i, spctsave);
      GB.exe(offX, offY, shock);
      lst.add(GB);
    }
    popMatrix();
  }

  void reexe(float[] spctsave, float offX, float offY, float shock) {
    pushMatrix();
    translate(width / 2, 0, 0);
    for (int r = lst.size() - 1; r > 0; r--) {
      int n = lst.get(r).getN();
      lst.set(r, new GrainBar(lst.get(r - 1)));
      lst.get(r).change(n);
    }

    for (int i = 0; i < fft.specSize(); i += 1) {
      if (i == 0) {
        GrainBar GB = new GrainBar(i, spctsave);
        GB.exe(offX, offY, shock);
        lst.set(0, GB);
      } else {
        lst.get(i).exe(offX, offY, shock);
      }
    }
    popMatrix();
  }
}

class GrainOrbit extends GrainSPCT{
  private OrbitFlow flowWorld;
  
  GrainOrbit(){
    super();
    flowWorld = new OrbitFlow();
  }
  
  void exe(float[] spctsave, float offX, float offY, float spiral, float lambda, float shock){  
    pushMatrix();
    translate(width / 2, 0, 0);
    
    for(int i = 0; i < fft.specSize() + 1; i++){
      GrainBar GB = new GrainBar(i, spctsave);
      lst.add(GB);
    }
    
    for(int i = 0; i < fft.specSize(); i++){
      if(i < (int)((fft.specSize() * 3) / 4)){
        if(i == (int)(fft.specSize() / 2)){
          flowWorld.exe(offX, offY, spiral, lambda);
        }
        lst.get(i + (int)(fft.specSize() / 4) + 1).exe(offX, offY, shock);
      }
      else{
        lst.get(i - (int)((fft.specSize() * 3) / 4)).exe(offX, offY, shock);
      }
    }
    popMatrix();
  }
  
  void reexe(float[] spctsave, float offX, float offY, float spiral, float lambda, float shock){
    pushMatrix();
    translate(width / 2, 0, 0);
    for(int r = lst.size() - 1; r > 0; r--){
      int n = lst.get(r).getN();
      lst.set(r, new GrainBar(lst.get(r - 1)));
      lst.get(r).change(n);
    }
    
    GrainBar GB = new GrainBar(0, spctsave);
    lst.set(0, GB);
    
    for(int i = 0; i < fft.specSize(); i++){
      if(i < (int)((fft.specSize() * 3) / 4)){
        if(i == (int)(fft.specSize() / 2)){
          flowWorld.reexe(offX, offY, spiral, lambda);
        }
        lst.get(i + (int)(fft.specSize() / 4) + 1).exe(offX, offY, shock);
      }
      else{
        lst.get(i - (int)((fft.specSize() * 3) / 4)).exe(offX, offY, shock);
      }
    }
    popMatrix();
  }
}
