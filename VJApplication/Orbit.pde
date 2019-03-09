/*
 * 02a: orbit classes
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

class Orbit{
  private float time;
  private float ran;
  private float a;
  private float sig;
  private float x, y, z;
  
  Orbit(float a){
    this.a = a * 100;
    ran = random(a * 50);
    sig = ((random(2) - 1) >= 0 ? 1 : -1);
    time = 0;
  }
  
  public float getX(){
    return x;
  }
  public float getY(){
    return y;
  }
  public float getZ(){
    return z;
  }
  
  private float calcX(float spiral){
    x = (sig * (a * sqrt(2)) * pow(time , 2) * sin(radians(time * 50)) + ran) * spiral;
    return x;
  }
  private float calcY(float lambda){
    y = (height * 7 / 10) * (1 - (1 / ((time + 1))))+ time * lambda;
    return y;
  }
  private float calcZ(float spiral){
    z = sig * (a * sqrt(2)) * pow(time, 2) * cos(radians(time * 50)) * spiral;
    return z;
  }
  
  public void run(float offX, float offY, float spiral, float lambda){
    noStroke();
    fill(180, 180, 255);
    
    pushMatrix();
//    rotateX(PI * 5 / 8);
    translate(calcX(spiral), calcY(lambda), calcZ(spiral));
    box(((10 + 25 * pow(ai.mix.get(0), 1.75)) * offX) / width, ((10 + 25 * pow(ai.mix.get(0), 1.75)) * offY) / height, 0);
//    box(5, 5, 0);
    popMatrix();
    
    time += 0.1;
  }
}

class OrbitFlow{
  private ArrayList<Orbit> OrbitWorld;
  private ArrayList<Integer> DeleteList;
  private Orbit Orb;
  
  OrbitFlow(){
    OrbitWorld = new ArrayList<Orbit>();
    DeleteList = new ArrayList<Integer>();
  }
  
  public void exe(float offX, float offY, float spiral, float lambda){
    Orb = new Orbit(ai.mix.get(0));
    OrbitWorld.add(Orb);
    
    for(Orbit orb: OrbitWorld){
      orb.run(offX, offY, spiral, lambda);
    }
  }
  
  public void reexe(float offX, float offY, float spiral, float lambda){
    for(int i = 0; i < OrbitWorld.size(); i++){
        if(OrbitWorld.get(i).getY() > offY + 50){
          DeleteList.add(i);
        }
    }
    int diff = 0;
    for(int del: DeleteList){
      OrbitWorld.remove(del - diff);
      diff++;
    }
    DeleteList.clear();
    
    this.exe(offX, offY, spiral, lambda);
  }
}
