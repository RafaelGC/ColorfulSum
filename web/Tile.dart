library Tile;

import "dart:html";

import "Color.dart";
import "HasBeenCollidedListener.dart";
import "ColorList.dart" as myColorList;

class Tile{
  double x, y;
  double animationPosX, animationPosY;
  num width, height;
  num targetWidth, targetHeight;
  int colorId;
  static final SPEED = 2000; 
  
  double targetX, targetY;
  bool movingHorizontal, movingVertical;
  
  Tile child;
  
  HasBeenCollidedListener hasBeenCollidedListener;
  
  bool animation;
  
  Tile(num width, num height, HasBeenCollidedListener hasBeenCollidedListener){
    x=y=animationPosX=animationPosY=0.0;
    targetX = targetY = 0.0;
    movingHorizontal = false;
    movingVertical = false;
    this.width = this.targetWidth = width;
    this.height = this.targetHeight = height;

    colorId = 0;
    
    child = null;
    
    this.hasBeenCollidedListener = hasBeenCollidedListener;
    
    animation = false;
  }
  
  void restartAnimation(){
    animation = true;
    this.width = 0;
    this.height = 0;
    
  }
  
  void render(CanvasRenderingContext2D target){
    if (child!=null){
      child.render(target);
    }
    target.setFillColorRgb(myColorList.colorList[colorId].r, myColorList.colorList[colorId].g, myColorList.colorList[colorId].b);
    target.fillRect(animationPosX+x, animationPosY+y, width, height);
    
    target.setStrokeColorRgb(0, 0, 0);
    target.strokeRect(animationPosX+x, animationPosY+y, width, height);
    
  }
  
  
  void setColor(int colorId){
    this.colorId = colorId;
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
        colorId++;
        //Llamamos al listener (aunque no debería ser nunca nulo, compruebo si lo es).
        if (hasBeenCollidedListener!=null){
          hasBeenCollidedListener.hasBeenCollided(this);
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
    
    if (this.animation){
      if (width<targetWidth){
        width+=(deltaTime*500);
        if (width>=targetWidth){
          width = targetWidth;
          animation = false;
        }
      }
      if (height<targetHeight){
        height+=(deltaTime*500);
        if (height>=targetHeight){
          height = targetHeight;
          animation = false;
        }
      }
      
      animationPosX = (targetWidth-width)/2;
      animationPosY = (targetHeight-height)/2;
      
    }
  }

}