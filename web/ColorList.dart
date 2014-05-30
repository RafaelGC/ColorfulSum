library ColorList;

import "Color.dart";

List<Color>colorList;

void initialize(){
  colorList = new List<Color>();
  
  colorList.add(new Color.fromRGB(0,255,255));
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
  colorList.add(new Color.fromRGB(255,61,61));
  
  //Difícilmente se superará esto.
  
  colorList.add(new Color.fromRGB(255,0,0));
  for (int i=0; i<7; i++){
    colorList.add(new Color.fromRGB(255-(30*i),0,0));
  }
  
}