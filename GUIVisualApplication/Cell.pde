/*
 * 01a: cell class
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

class Cell{
  private int cellSize;
  private float x, y;
  private int state;
  private int nextState;
  
  Cell[] neighbours;
 
  Cell(float xx, float yy, int cS){
    cellSize = cS;
    x = xx * cellSize;
    y = yy * cellSize;
    nextState = int(random(2));
    state = nextState;
    neighbours = new Cell[0];
  }
  
  int getState(){
    return state;
  }
  
  float getX(){
    return x;
  }
  
  float getY(){
    return y;
  }
 
  void addNeighbour(Cell cell){
    neighbours = (Cell[])append(neighbours, cell);
  }
 
  void calcNextState(){
    if(state == 0){
      int firingCount = 0;
      for(int i = 0; i < neighbours.length; i++){
        if(neighbours[i].getState() == 1){
          firingCount++;
        }
      }
      if(firingCount == 2){
        nextState = 1;
      }
      else{
        nextState = state;
      }
    }
    else if(state == 1){
      nextState = 2;
    }
    else if(state == 2){
      nextState = 0;
    }
  }
  
  void drawMe(){
    state = nextState;
    noStroke();
    
    if(state == 1){
      fill(75, 75, 255);
    }
    else if(state == 2){
      fill(122.5);
    }
    else{
      fill(0);
    }
    
    if(state == 1 || state == 2){
    ellipse(x, y, cellSize, cellSize);
    }
  }
}
