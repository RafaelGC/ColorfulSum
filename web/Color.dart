library Color;

class Color{
  num r, g, b;
  
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
    int rMask = r.toInt()<<16;
    g = ((~rMask)&number)>>8;
    
    //Combinamos rMask con la nueva máscara que elimina también el verde.
    int gMask = g.toInt()<<8;
    int rgMask = rMask+gMask;
    
    b = (~rgMask)&number;
    
  }
  
  operator==(Color c) => c.r==r && c.g==g && c.b==b;
  
  void copy(Color c){
    this.r = c.r;
    this.g = c.g;
    this.b = c.b;
  }
  
  String toString() => "$r,$g,$b";
  
  int toInt(){
    return getIntFromRGB(r,g,b);
  }
  
  void fromInteger(int value){
    Color c = new Color.fromInt(value);
    this.r = c.r;
    this.g = c.g;
    this.b = c.b;
  }
  
  static Color getRGBFromInt(int number){
    return new Color.fromInt(number);
  }
  
  static int getIntFromRGB(int r, int g, int b){
    return (r<<16)+(g<<8)+b;
  }
  
}