/*
 * 01: cell automaton (brain model)
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

import java.util.LinkedList;

class CELLbrain{
  private Cell[][] CellArray;
  
  private int cellSize;
  private int numX, numY;
  private float offX, offY;
  private LinkedList<Cell> LL;
  private boolean XYswitch;
  private float weight;
  
  // Nihongo Nyuuryoku Dekinai... 
  //parameter: 5
  CELLbrain(float offX, float offY, float cellSize, boolean sw, float w){
    this.cellSize = floor(cellSize);
    this.offX = offX;
    this.offY = offY;
    numX = floor(offX / cellSize);
    numY = floor(offY / cellSize);
    
    weight = w;
    XYswitch = sw;
    
    reAndStart();
  }
  
  void setCellSize(int cellSize){
    this.cellSize = cellSize;
    numX = floor(offX / cellSize);
    numY = floor(offY / cellSize);
    reAndStart();
  }
  void setXYswitch(boolean XYs){
    XYswitch = XYs;
  }
  void setWeight(float weight){
    this.weight = weight;
  }
  
  
  
  void reAndStart(){
    CellArray = new Cell[numX][numY];
    for(int x = 0; x < numX; x++){
      for(int y = 0; y < numY; y++){
        CellArray[x][y] = new Cell(x, y, cellSize);
      }
    }
    
    for(int x = 0; x < numX; x++){
      for(int y = 0; y < numY; y++){
        int above = y - 1;
        int below = y + 1;
        int left = x - 1;
        int right = x + 1;
        
        if(above < 0){
          above = numY - 1;
        }
        if(below == numY){
          below = 0;
        }
        if(left < 0){
          left = numX - 1;
        }
        if(right == numX){
          right = 0;
        }
        
       int[] neighbourX = {left, x, right};
       int[] neighbourY = {above, y, below};
       
       for(int nX: neighbourX){
         for(int nY: neighbourY){
           if(!(nX == x && nY == y)){
             CellArray[x][y].addNeighbour(CellArray[nX][nY]);
           }
         }
       }
//       消えていく
      }
    }
  }
  
  void exe(int w0, int h0){
    //(0, 0) -> (w0, h0)
    pushMatrix();
    translate(w0, h0);
    
    boolean con = true;
    LL = new LinkedList<Cell>();
    
    for(int x = 0; x < numX; x++){
      for(int y = 0; y < numY; y++){
        CellArray[x][y].calcNextState();
      }
    }
    
    translate(cellSize / 2, cellSize / 2);
    
    for(int x = 0; x < numX; x++){
      for(int y = 0; y < numY; y++){
        CellArray[x][y].drawMe();
      }
    }
    
    int numL, numF;
    if(XYswitch){
      numL = numY;
      numF = numX;
    }
    else{
     numL = numX;
     numF = numY;
    }
    
    //set iterate of linecell?
    for(int last = 0; last < numL; last++){
      for(int first = 0; first < numF; first++){
        int r = (int)random(2);
        if(XYswitch){          
          if(CellArray[first][last].getState() == 1){
            if(r == 0){
              LL.addFirst(CellArray[first][last]);
            }
            else{
              LL.addLast(CellArray[first][last]);
            }
          }
        }
        else{
          if(CellArray[last][first].getState() == 1){
            if(r == 0){
              LL.addFirst(CellArray[last][first]);
            }
            else{
              LL.addLast(CellArray[last][first]);
            }
          }
        }
      }
    }
    
    float preX = 0;
    float preY = 0;
    strokeWeight(weight);
    stroke(255);
    
    for(Cell c: LL){
      if(con){
        preX = c.getX();
        preY = c.getY();
        con = false;
      }
      else{
        if(dist(c.getX(), c.getY(), preX, preY) <= 200){
          line(c.getX(), c.getY(), preX, preY);
        }
        
        preX = c.getX();
        preY = c.getY();
      }
    }
    popMatrix();
  }
  
}
