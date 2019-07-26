/*
 * 03: sound level meter(discreted Daiji)
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

class DBnumber{
  private PFont myFont1, myFont2, myFont3;
  private String preC, preL, preR;
  private String preBackC, preBackL, preBackR;
  
  private float offX, offY;
  private float letterSize;
  private float letterBlur;
  private float bgColor;
  
  DBnumber(float offX, float offY, float letterSize, float letterBlur, float bgColor){    
    this.offX = offX;
    this.offY = offY;
    this.letterSize = letterSize;
    this.letterBlur = letterBlur;
    this.bgColor = bgColor;
    
    myFont1 = createFont("Charter-Black", letterSize, true);
    myFont2 = createFont("Charter-Black", 1000, true);
    myFont3 = createFont("Charter-Black", 2500, true);
  }
  
  void setLetterSize(float letterSize){
    this.letterSize = letterSize;
    myFont1 = createFont("Charter-Black", letterSize, true);
  }
  
  void setLetterBlur(float letterBlur){
    this.letterBlur = letterBlur;
  }
  
  void setBgColor(float bgColor){
    this.bgColor = bgColor;
  }
  
  void exe(int w0, int h0){
    textAlign(CENTER, CENTER);
    
    pushMatrix();
    translate(w0, h0);
    
    int dbC = abs(floor(ai.mix.get(0) * 700));
    int dbL = abs(floor(ai.mix.get(0) * 700));
    int dbR = abs(floor(ai.mix.get(0) * 700));
    
    letter expressionC = new letter(dbC);
    letter expressionL = new letter(dbL);
    letter expressionR = new letter(dbR);
    
    float scroll = random(750) - 375;
    
    noStroke();
    fill(210 - bgColor, 0, bgColor);
    rect(0, 0, offX, offY);
    fill(255);
    
    //text3
    pushMatrix();
    translate(offX / 2, offY / 2);
    textFont(myFont3);
    fill(0, 50);
    
    String expBackC = expressionC.transport();
    if(expBackC != " "){
      text(expBackC, 0, -100);
      preBackC = expBackC;
    }
    else{
      text(preBackC, 0, -100);
    }
    
    //text2
    textFont(myFont2);
    fill(255, 75);
    
    String expBackL = expressionL.transport();
    if(expBackL != " "){
      text(expBackL, -(offX / 4 + scroll * letterBlur), -100);
      preBackL = expBackL;
    }
    else{
      text(preBackL, -(offX / 4 + scroll * letterBlur), -100);
    }
    
    String expBackR = expressionR.transport();
    if(expBackR != " "){
      text(expBackR, (offX / 4 + scroll * letterBlur), -100);
      preBackR = expBackR;
    }
    else{
      text(preBackR, (offX / 4 + scroll * letterBlur), -100);
    }
    
    //text1
    fill(0);
    textFont(myFont1);
    
    pushMatrix();
    translate(noise(frameCount + random(100)) * dbC * 2 - dbC, noise(frameCount + random(100)) * dbC * 2 - dbC);
    String expC = expressionC.transport();
    if(expC != " "){
      text(expC, 25, -25);
      preC = expC;
    }
    else{
      text(preC, 25, -25);
    }
    popMatrix();
    
    fill(255);
    
    pushMatrix();
    translate(noise(frameCount + random(100)) * dbL * 2 - dbL, noise(frameCount + random(100)) * dbL * 2 - dbL);
    String expL = expressionL.transport();
    if(expL != " "){
      text(expL, -(offX / 2 + 25), -25);
      preL = expL;
    }
    else{
      text(preL, -(offX / 2 + 25), -25);
    }
    popMatrix();
    
    pushMatrix();
    translate(noise(frameCount + random(100)) * dbR * 2 - dbR, noise(frameCount + random(100)) * dbR * 2 - dbR);
    String expR = expressionR.transport();
    if(expR != " "){
      text(expR, (offX / 2 + 25), -25);
      preR = expR;
    }
    else{
      text(preR, (offX / 2 + 25), -25);
    }
    popMatrix();
    
    popMatrix();
    popMatrix();
    
    noStroke();
    fill(0, 0, 40);
    rect(0, 0, w0, height);
    rect(w0 + offX, 0, width, height);
    rect(w0, 0, w0 + offX, h0);
    rect(w0, h0 + offY, w0 + offX, height);
  }
}
