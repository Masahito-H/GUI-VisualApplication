/*
 * 03a: Daiji class
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

class letter{
  int db;
  char[] s;
  
  letter(int i){
    db = i;
    s = new char[String.valueOf(db).length()];
  }
  
  String transport(){
    int value = db;
    StringBuilder ss = new StringBuilder();
    
    for(int i = 0; i < s.length; i++){
      int p = (int)pow(10, (s.length - 1) - i);
      if(s.length - i == 1){
        s[i] = label(value);
      }
      else{
        s[i] = label(value % p);
      }
      ss.append(s[i]);
      value -= (value % p) * p;
    }
    
    return ss.toString();
  }
  
  char label(int i){
    switch(i){
     case 0:return '零';
     case 1:return '壱';
     case 2:return '弐';
     case 3:return '参';
     case 4:return '肆';
     case 5:return '伍';
     case 6:return '陸';
     case 7:return '漆';
     case 8:return '捌';
     case 9:return '玖';
    }
    return ' ';
  }
}
