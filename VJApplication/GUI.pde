/*
 * 00a: GUI(parts and modes)
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

//Parts
abstract class Parts{
  protected float x, y;
  
  Parts(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  float getX(){
    return x;
  }
  float getY(){
    return y;
  }
  
  abstract void partsDraw();
}

class Button extends Parts{
  private boolean sw;
  private String name;
  
  Button(float x, float y, String name){
    super(x, y);
    sw = false;
    this.name = name;
  }
  
  void partsDraw(){
    int testY = 50;
    int buttonR = 30;
    
    fill(0, 0, 50);
    textAlign(CENTER);
    text(name, x, y + 70);
    
    noStroke();
    if(sw){
      fill(255, 255, 0);
    }
    else{
      fill(175);
    }
    
    rect(x - buttonR, y - buttonR, buttonR * 2, buttonR * 2);
    
    noStroke();
    textSize(17);
    fill(255, 255, 50);
    textAlign(CENTER);
    text(name, x, y + testY);
  }
  
  boolean click(){
    sw = !sw;
    partsDraw();
    return sw;
  }
}

class Fader extends Parts{
  private float minMeter, maxMeter;
  private float meter;
  private float preMeter;
  private String name;
  
  Fader(float x, float y, float minM, float maxM, String name){
    super(x, y);
    this.minMeter = minM;
    this.maxMeter = maxM;
    meter = 0;
    preMeter = 0;
    this.name = name;
  }
  
  float getMax(){
    return maxMeter;
  }
  
  void partsDraw(){
    int textY = 50;
    int meterExp = 80;
    int meterR = 70;
    int nobR = 25;
    float plusEdge = 20;
    
    noStroke();
    fill(65, 65, 65);
    arc(x, y, meterExp, meterExp, HALF_PI + QUARTER_PI, TWO_PI + QUARTER_PI); //<>// //<>//
    if(meter == maxMeter - minMeter){
      fill(255, 200, 0);
      arc(x, y, meterR, meterR, HALF_PI + QUARTER_PI, TWO_PI + QUARTER_PI);
      
      stroke(210);
      strokeWeight(1);
      fill(255, 255, 180);
      ellipse(x, y, nobR, nobR);
      noStroke();
      fill(0, 70);
      
      pushMatrix();
      translate(x, y);
      line(x - plusEdge, y, x + plusEdge, y);
      line(x, y - plusEdge, x, y + plusEdge);
      popMatrix();
    }
    else if(meter <= 0){
      stroke(210);
      strokeWeight(1);
      fill(90);
      ellipse(x, y, nobR, nobR);
    }
    else{
      float plusSita = (2 * TWO_PI * meter) / (maxMeter - minMeter); 
      
      fill(255, 255, 180);
      arc(x, y, meterR, meterR, HALF_PI + QUARTER_PI, HALF_PI + QUARTER_PI + ((PI + HALF_PI) * meter) / (maxMeter - minMeter));
      
      stroke(210);
      strokeWeight(1);
      fill(255, 255, 0);
      ellipse(x, y, nobR, nobR);
      noStroke();
      fill(0, 70);
      
      pushMatrix();
      translate(x, y);
      rotate(plusSita);
      line(x - plusEdge, y, x + plusEdge, y);
      line(x, y - plusEdge, x, y + plusEdge);
      popMatrix();
    }
    
    noStroke();
    textSize(17);
    fill(255, 255, 50);
    textAlign(CENTER);
    text(name, x, y + textY);
  }
  
  float slide(float para, float offset){
    meter = (maxMeter * (-(para - offset))) / (height / 2) + preMeter;
    if(meter > maxMeter - minMeter){
      meter = maxMeter - minMeter;
    }
    else if(meter < 0){
      meter = 0;
    }
    
    partsDraw();
    return meter + minMeter;
  }
  
  void release(){
    preMeter = meter;
  }
}


//GUI Mode
abstract class Mode{
  protected final int x = width / 2;
  protected final int y = (height * 9) / 10;
  
  ArrayList<Parts> parts;
  protected int sw;
  protected float offset;
  
  Mode(){
    sw = 0;
    parts = new ArrayList<Parts>();
  }
  
  abstract void operation();
  
  void setSelect(){
    float x = mouseX;
    float y = mouseY;
    offset = mouseY;
    
    Parts p;
    int nobR = 25;
    int buttonR = 50;
    for(int i = 0; i < parts.size(); i++){
      p = parts.get(i);
      if(p instanceof Fader){
        if(((x >= p.getX() - nobR) && (x <= p.getX() + nobR)) && ((y >= p.getY() - nobR) && (y <= p.getY() + nobR))){
          sw = i + 1;
          return;
        }
      }
      else if(p instanceof Button){
        if(((x >= p.getX() - buttonR) && (x <= p.getX() + buttonR)) && ((y >= p.getY() - buttonR) && (y <= p.getY() + buttonR))){
          sw = i + 1;
          return;
        }
      }
    }
    sw = 0;
  }
  
  void GDraw(){
    for(Parts p: parts){
      if(p instanceof Fader){
        p.partsDraw();
      }
      else if(p instanceof Button){
        p.partsDraw();
      }
    }
  }
  
  void reset(){
    sw = 0;
  }
}

class CELLbrainMode extends Mode{
  private CELLbrain mode;
  private Fader cellSize;
  private Button lineVH;
  private Fader weightLine;
  
  CELLbrainMode(CELLbrain mode){
    super();
    this.mode = mode;
   
    cellSize = new Fader(x - 300, y, 10, 30, "CellSize");
    parts.add(cellSize);
    lineVH = new Button(x, y, "LineDirection");
    parts.add(lineVH);
    weightLine = new Fader(x + 300, y, 1, 10, "LineBold");
    parts.add(weightLine);
  }
  
  void operation(){
    switch(sw){
    case 1: mode.setCellSize((int)cellSize.slide(mouseY, offset));
            if(!mousePressed){
              cellSize.release();
            }
            break;
            
    case 2: if(!mousePressed){
              mode.setXYswitch(lineVH.click());
            }
            break;
            
    case 3: mode.setWeight(weightLine.slide(mouseY, offset));
            if(!mousePressed){
              weightLine.release();
            }
            break;
    }
  }
}

class SPCTorbitMode extends Mode{
  private SPCTorbit mode;
  private Fader area;
  private Fader spiral;
  private Fader lambda;
  private Fader shock;
  
  SPCTorbitMode(SPCTorbit mode){
    super();
    this.mode = mode;
    
    area = new Fader(x - 390, y, 0, 1000, "BlurArea");
    parts.add(area);
    spiral = new Fader(x - 130, y, 0, 2, "SpiralStrength");
    parts.add(spiral);
    lambda = new Fader(x + 130, y, 10, 100, "Velocity");
    parts.add(lambda);
    shock = new Fader(x + 390, y, 0, 2, "ImpactSpectram");
    parts.add(shock);
  }
  
  void operation(){
    switch(sw){
    case 1: mode.setArea(area.slide(mouseY, offset));
            if(!mousePressed){
              area.release();
            }
            break;
    case 2: mode.setSpiral(spiral.slide(mouseY, offset));
            if(!mousePressed){
              spiral.release();
            }
            break;
    case 3: mode.setLambda(lambda.slide(mouseY, offset));
            if(!mousePressed){
              lambda.release();
            }
            break;
    case 4: mode.setShock(shock.slide(mouseY, offset));
            if(!mousePressed){
              shock.release();
            }
            break;
    }
  }
}

class DBnumberMode extends Mode{
  private DBnumber mode;
  private Fader letterSize;
  private Fader letterBlur;
  private Fader bgColor;
  
  DBnumberMode(DBnumber mode){
   super();
   this.mode = mode;
   
   letterSize = new Fader(x - 300, y, 100, 1000, "LetterSize");
   parts.add(letterSize);
   letterBlur = new Fader(x, y, 0, 10, "LetterBlur");
   parts.add(letterBlur);
   bgColor = new Fader(x + 300, y, 0, 255, "BgColor");
   parts.add(bgColor);
  }
  
  void operation(){
   switch(sw){
   case 1: mode.setLetterSize(letterSize.slide(mouseY, offset));
           if(!mousePressed){
             letterSize.release();
           }
           break;
   case 2: mode.setLetterBlur(letterBlur.slide(mouseY, offset));
           if(!mousePressed){
             letterBlur.release();
           }
           break;
   case 3: mode.setBgColor(bgColor.slide(mouseY, offset));
           if(!mousePressed){
             bgColor.release();
           }
           break;
   }
  }
}

class SPCTcrossMode extends Mode{
  private SPCTcross mode;
  private Button echoSwitch;
  private Fader echoSpeed;
  private Fader bgColor;
  
  SPCTcrossMode(SPCTcross mode){
    super();
    this.mode = mode;
    
    echoSwitch = new Button(x - 300, y, "EchoSwitch");
    parts.add(echoSwitch);
    echoSpeed = new Fader(x, y, 5, 50, "EchoSpeed");
    parts.add(echoSpeed);
    bgColor = new Fader(x + 300, y, 0, 150, "BgColor");
    parts.add(bgColor);
  }
  
  void operation(){
    switch(sw){
    case 1: if(!mousePressed){
              mode.setEchoSwitch(echoSwitch.click());
            }
            break;
    case 2: mode.setEchoSpeed(echoSpeed.slide(mouseY, offset));
            if(!mousePressed){
              echoSpeed.release();
            }
            break;
    case 3: mode.setBgColor(bgColor.slide(mouseY, offset));
            if(!mousePressed){
              bgColor.release();
            }
            break;
    }
  }
}

class modeExpression{
  boolean sw;
  float x;
  String name;
  
  modeExpression(float x, String name){
    this.x = x;
    sw = false;
    this.name = name;
  }
  
  void setMode(boolean sw){
    this.sw = sw;
  }
  
  void exe(){
    noStroke();
    
    if(sw){
      fill(255, 255, 0);
    }
    else{
      fill(175);
    }
    textFont(createFont("Charter-Black", 30, true));
    textAlign(CENTER, CENTER);
    
    pushMatrix();
    translate(x, height - 10);
    rect(-25, -10, 100, 100);
    text(name, 0, -35);
    popMatrix();
  }
  
}
