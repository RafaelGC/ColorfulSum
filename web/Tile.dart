library Tile;

import "dart:html";

import "Color.dart";
import "HasBeenCollidedListener.dart";

class Tile{
  double x, y;
  num width, height;
  Color color;
  static final SPEED = 2000; 
  
  double targetX, targetY;
  bool movingHorizontal, movingVertical;
  
  Tile child;
  
  HasBeenCollidedListener hasBeenCollidedListener;
  
  bool animation;
  
  Tile(num width, num height, HasBeenCollidedListener hasBeenCollidedListener){
    x=y=0.0;
    targetX = targetY = 0.0;
    movingHorizontal = false;
    movingVertical = false;
    this.width = width;
    this.height = height;

    color = new Color.fromRGB(255, 255, 255);
    
    child = null;
    
    this.hasBeenCollidedListener = hasBeenCollidedListener;
    
    animation = false;
  }
  
  void restartAnimation(){
    animation = true;
  }
  
  void render(CanvasRenderingContext2D target){
    if (child!=null){
      child.render(target);
    }
    target.setFillColorRgb(color.r, color.g, color.b);
    target.fillRect(x, y, width, height);
    
    target.setStrokeColorRgb(0, 0, 0);
    target.strokeRect(x, y, width, height);
    
  }
  
  
  void setColor(Color newColor){
    this.color = newColor;
  }
  
  bool isMoving(){
    return (movingHorizontal||movingVertical);
  }
  
  void manage(double deltaTime){
    
    if (child!=null){
      child.manage(deltaTime);
      
      //Si el hijo ha terminado con su movimiento, desaparece.
      if (child.isMoving()==false){
        child = null;
        //¡Me lo he comido! Debo cambiar mi color...
        color.r-=0;
        color.g-=40;
        color.b-=40;
        //Llamamos al listener (aunque no debería ser nunca nulo, compruebo si lo es).
        if (hasBeenCollidedListener!=null){
          hasBeenCollidedListener.hasBeenCollided();
        }
      }
    }
    
    if (x==targetX){
      movingHorizontal = false;
    }
    if (y==targetY){
      movingVertical = false;
    }
    
    if (movingHorizontal){
      
      if (x<targetX){
        x+=deltaTime*SPEED;
        if (x>=targetX){
          movingHorizontal = false;
          x = targetX;
        }
      }
      else if (x>targetX){
        x-=deltaTime*SPEED;
        if (x<=targetX){
          movingHorizontal = false;
          x = targetX;
        }
      }
      
    }
    
    if (movingVertical){
      
      if (y<targetY){
        y+=deltaTime*SPEED;
        if (y>=targetY){
          movingVertical = false;
          y = targetY;
        }
      }
      else if (y>targetY){
        y-=deltaTime*SPEED;
        if (y<=targetY){
          y = targetY;
          movingVertical = false;
        }
      }
      
    }
  }

}