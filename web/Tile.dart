library Tile;

import "dart:html";

import "HasBeenCollidedListener.dart";
import "ColorList.dart" as myColorList;
import "Color.dart";

class Tile{
  double x, y;
  double animationPosX, animationPosY;
  
  num width, height;
  num originalWidth, originalHeight;
  int _colorId;
  static final SPEED = 2000;
  static final TRANSITION_SPEED = 1000;
  
  double targetX, targetY;
  bool movingHorizontal, movingVertical;
  
  Tile child;
  
  HasBeenCollidedListener hasBeenCollidedListener;
  
  bool animation;
  
  Color currentColor;
  Color targetColor;
  
  
  Tile(num width, num height, HasBeenCollidedListener hasBeenCollidedListener){
    x=y=animationPosX=animationPosY=0.0;
    targetX = targetY = 0.0;
    movingHorizontal = false;
    movingVertical = false;
    this.width = this.originalWidth = width;
    this.height = this.originalHeight = height;


    
    child = null;
    
    this.hasBeenCollidedListener = hasBeenCollidedListener;
    
    animation = false;
    
    currentColor = new Color.fromRGB(0, 0, 0);
    targetColor = new Color.fromRGB(255, 0, 0);
    
    colorId = 0;
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
    
    target.setFillColorRgb(currentColor.r.toInt(), currentColor.g.toInt(), currentColor.b.toInt());
    target.fillRect(animationPosX+x,animationPosY+y, width, height);
    
    target.setStrokeColorRgb(0, 0, 0);
    target.strokeRect(animationPosX+x,animationPosY+y, width, height);
    
  }
  
  set colorId(int colorId){
    this._colorId = colorId;
    targetColor.copy(myColorList.colorList[colorId]);
  }
  
  void setTargetAndCurrentId(int colorId){
    this._colorId = colorId;
    targetColor.copy(myColorList.colorList[colorId]);
    currentColor.copy(targetColor);
  }
  
  get colorId => _colorId;
  
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
    
    
    //Tansición del color
    //Red
    if (currentColor.r<targetColor.r){
      currentColor.r+=(TRANSITION_SPEED*deltaTime);
      if (currentColor.r>targetColor.r){
        currentColor.r = targetColor.r;
      }
    }
    else if (currentColor.r>targetColor.r){
      currentColor.r-=(TRANSITION_SPEED*deltaTime);
      if (currentColor.r<targetColor.r){
        currentColor.r=targetColor.r;
      }
    }
    //Green
    if (currentColor.g<targetColor.g){
      currentColor.g+=(TRANSITION_SPEED*deltaTime);
      if (currentColor.g>targetColor.g){
        currentColor.g = targetColor.g;
      }
    }
    else if (currentColor.g>targetColor.g){
      currentColor.g-=(TRANSITION_SPEED*deltaTime);
      if (currentColor.g<targetColor.g){
        currentColor.g=targetColor.g;
      }
    }
    //Blue
    if (currentColor.b<targetColor.b){
      currentColor.b+=(TRANSITION_SPEED*deltaTime);
      if (currentColor.b>targetColor.b){
        currentColor.b = targetColor.b;
      }
    }
    else if (currentColor.b>targetColor.b){
      currentColor.b-=(TRANSITION_SPEED*deltaTime);
      if (currentColor.b<targetColor.b){
        currentColor.b=targetColor.b;
      }
    }
    
    
    //Movimiento
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
      if (width<originalWidth){
        width+=(deltaTime*500);
        if (width>=originalWidth){
          width = originalWidth;
          animation = false;
        }
      }
      if (height<originalHeight){
        height+=(deltaTime*500);
        if (height>=originalHeight){
          height = originalHeight;
          animation = false;
        }
      }
      
      animationPosX = (originalWidth-width)/2;
      animationPosY = (originalHeight-height)/2;
      
    }

  }

}