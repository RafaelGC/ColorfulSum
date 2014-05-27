library Tile;

import "dart:html";
import "dart:math";

import "Color.dart";

class Tile{
  num x, y;
  num width, height;
  Color color;
  static final SPEED = 1000; 
  
  num targetX, targetY;
  bool moving;
  
  Tile(num width, height){
    x=y=0;
    targetX = targetY = 0;
    moving = false;
    this.width = width;
    this.height = height;

    color = new Color.fromRGB(255, 255, 255);
  }
  
  void render(CanvasRenderingContext2D target){
    target.setFillColorRgb(color.r, color.g, color.b);
    target.fillRect(x, y, width, height);
    
    target.setStrokeColorRgb(0, 0, 0);
    target.strokeRect(x, y, width, height);
  }
  
  
  void setColor(Color newColor){
    this.color = newColor;
  }
  
  void manage(double deltaTime){
    if (!moving) {return;}
    
    if (x<targetX){
      x+=deltaTime*SPEED;
      if (x>targetX){
        x = targetX;
        moving = false;
      }
    }
    else if (x>targetX){
      x-=deltaTime*SPEED;
      if (x<targetX){
        x = targetX;
        moving = false;
      }
    }
    
    if (y<targetY){
      y+=deltaTime*SPEED;
      if (y>targetY){
        y = targetY;
        moving = false;
      }
    }
    else if (y>targetY){
      y-=deltaTime*SPEED;
      if (y<targetY){
        y = targetY;
        moving = false;
      }
    }
  }
}