library ColorList;

import "Color.dart";

List<Color>colorList;

void initialize(){
  colorList = new List<Color>();
  
  /*colorList.add(new Color.fromRGB(0,255,255));
  colorList.add(new Color.fromRGB(0,128,255));
  colorList.add(new Color.fromRGB(0,0,255));
  colorList.add(new Color.fromRGB(128,0,255));
  colorList.add(new Color.fromRGB(0,255,128));
  colorList.add(new Color.fromRGB(0,255,0));
  colorList.add(new Color.fromRGB(255,255,0));
  colorList.add(new Color.fromRGB(255,128,0));
  colorList.add(new Color.fromRGB(255,0,255));
  colorList.add(new Color.fromRGB(255,0,128));
  colorList.add(new Color.fromRGB(255,122,122));
  colorList.add(new Color.fromRGB(255,61,61));*/
  
  colorList.add(new Color.fromRGB(255,0,110));
  colorList.add(new Color.fromRGB(108,0,255));
  colorList.add(new Color.fromRGB(122,122,255));
  colorList.add(new Color.fromRGB(0,148,255));
  colorList.add(new Color.fromRGB(0,255,255));
  colorList.add(new Color.fromRGB(0,255,144));
  colorList.add(new Color.fromRGB(0,255,33));
  colorList.add(new Color.fromRGB(182,255,0));
  colorList.add(new Color.fromRGB(255,106,0));
  colorList.add(new Color.fromRGB(227,51,0));
  colorList.add(new Color.fromRGB(127,0,0));
  colorList.add(new Color.fromRGB(255,0,0));
  
  //Difícilmente se superará esto.
  
  colorList.add(new Color.fromRGB(255,0,0));
  for (int i=0; i<7; i++){
    colorList.add(new Color.fromRGB(255-(30*i),0,0));
  }
  
}