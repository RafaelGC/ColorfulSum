library Color;

class Color{
  int r, g, b;
  
  Color(){
    r=g=b=0;
  }
  
  Color.fromRGB(int r, int g, int b){
    this.r = r;
    this.g = g;
    this.b = b;
  }
  
  Color.fromInt(int number){
    r = number>>16;
    
    //Utilizo r como máscara para filtrar el rojo del entero.
    int rMask = r<<16;
    g = ((~rMask)&number)>>8;
    
    //Combinamos rMask con la nueva máscara que elimina también el verde.
    int gMask = g<<8;
    int rgMask = rMask+gMask;
    
    b = (~rgMask)&number;
    
  }
  
  String toString() => "$r,$g,$b";
  
  static Color getRGBFromInt(int number){
    return new Color.fromInt(number);
  }
  
  static int getIntFromRGB(int r, int g, int b){
    return (r<<16)+(g<<8)+b;
  }
  
}