library Scene;

import "dart:html";
import "dart:math";

import "Scene.dart";
import "Keyboard.dart";
import "Tile.dart";
import "Color.dart";

class GameScene extends Scene{
  
  List<Tile>tiles;
  num rows, cols;
  
  GameScene(CanvasRenderingContext2D target, num width, num height):super(target,width,height){
    rows = 5;
    cols = 5;
    
    tiles = new List<Tile>();
    for (int i = 0; i<rows*cols; i++){
      tiles.add(null);
    }
    
    restartGame();
    generateStartingTiles();
    
  }
  
  void manageEvents(double deltaTime){
    if (areAllTilesStopped()){
      
      if (Keyboard.getInstance().isPressed(KeyCode.S)){
        //Vamos recorriendo columna por columna.
        for (int x=0; x<cols; x++){
          
          //Y en la columna vamos estudiando las distintas casillas.
          //La que está en la casilla 4 está en su posición ideal, no puede ir más abajo, luego
          //no nos interesa estudiarla, por eso empezamos por la tercera.
          
          for (int y=rows-2; y>=0; y--){
            
            int i = xyToIndex(x,y);
            
            //Miramos si hay algo en ese hueco, quizá no hay nada.
            if (tiles[i]!=null){
              
              //Pero sí que lo hay, entonces vamos a buscar una casilla por debajo de ésta
              //que nos sirva. Hay dos posibilidades, que sea una casilla vacía o que sea una casilla
              //con nuestro mismo valor.
              
              int targetY = getFreeRowIn(x,true);
              
              //Como nos estamos moviendo hacia abajo, sólo nos interesan las casillas vacías que están
              //por debajo de la casilla que estamos estudiando, luego ignoramos las que están por encima.
              if (targetY>y){
                
                //Teóricamente, ya tenemos la próxima posición de la casilla, pero hay que estudiar si la
                //que hay por debajo de targetY es del mismo color para fusionarlas.
                //Esto sólo lo estudiamos si targetY<rows-1.
                if (targetY<rows-1){
                  int nextTile = xyToIndex(x,targetY+1);
                  if (tiles[nextTile]!=null){
                    //Ponemos como condición, para que se fusionen, que, además de tener el mismo color,
                    //la casilla padre no tenga un hijo al que esté gestionando.
                    if (tiles[nextTile].color==tiles[i].color && tiles[nextTile].child==null){
                      print("Se puede fusionar con $nextTile");
                      /* ¡Tienen el mismo color! Los fusionamos.
                       * Hay que tener en cuenta algo: cuando los fusionamos hay dos casillas que ocupan el mismo
                       * hueco, y esto hacerlo en una array es imposible: en un mismo lugar no podemos poner dos
                       * tiles diferentes.
                       * Para solucionar esto he decidido que la casilla que se mantiene estática se convertirá
                       * en padre de la casilla que vamos a fusionar y será la casilla padre la que gestiona.
                       * De este modo, podemos eliminar la casilla que fusionamos del array y que todo esto siga
                       * su curso.
                       * */
                      
                      //Primero, seleccionamos el nuevo objetivo. Aquí hay dos posibilidades: si nuestro
                      //objetivo están en movimiento, iremos a su mismo objetivo, al lugar al que se dirige, no
                      //al que está; si nuestro objetivo está estático, simplemente iremos donde él.
                      tiles[i].targetX = tiles[i].x; //No cambia, estamos haciendo un movimiento vertical.
                      if (tiles[nextTile].moving){
                        tiles[i].targetY = tiles[nextTile].targetY;
                      }
                      else{
                        tiles[i].targetY = tiles[nextTile].y;
                      }
                      tiles[i].moving = true;
                      
                      //Y ahora ponemos el objeto en el padre.
                      tiles[nextTile].child = tiles[i];
                      //Y lo quitamos del array.
                      tiles[i] = null;
                      //Ahora será el padre quien lo gestione.
                      
                      
                      //Forzamos la siguiente iteración.
                      continue;
                    }
                  }
                }
                
                int indexTarget = xyToIndex(x,targetY);
                
                tiles[indexTarget] = tiles[i];
                tiles[i] = null;
                
                tiles[indexTarget].targetX = tiles[indexTarget].x;
                tiles[indexTarget].targetY = targetY*100;
                tiles[indexTarget].moving = true;
                
              }
              
            }
            
          }
          
        }
        
      }
      
      if (Keyboard.getInstance().isPressed(KeyCode.W)){
        for (int x=0;x<cols;x++){
          for (int y=1; y<rows; y++){
            int i = xyToIndex(x,y);
            if (tiles[i]!=null){
              int objective = getFreeRowIn(x);
              if (objective<y){
                int indexTarget = xyToIndex(x,objective);
                tiles[indexTarget] = tiles[i];
                tiles[i] = null;
                
                tiles[indexTarget].targetX = tiles[indexTarget].x;
                tiles[indexTarget].targetY = objective*100;
                tiles[indexTarget].moving = true;
              }
            }
          }
        }
      }
      
      
      
    }
    
  }
  
  void logic(double deltaTime){
    for (Tile t in tiles){
      if (t!=null){
        t.manage(deltaTime);
      }
    }
  }
  
  void render(){
    target.setFillColorRgb(255, 255, 255);
    target.fillRect(0, 0, width, height);

    for (Tile tile in tiles){
      if (tile!=null){
        tile.render(target);
      }
    }
  }
  
  bool areAllTilesStopped(){
    for (Tile t in tiles){
      if (t!=null){
        if (t.moving==true){
          return false;
        }
      }
    }
    return true;
  }
  
  void repositionTiles(){
    for (int y=0; y<rows; y++){
      for (int x=0; x<cols; x++){
        int i = xyToIndex(x,y);
        if (tiles[i]!=null){
          tiles[i].x = x*100;
          tiles[i].y = y*100;
        }
      }
    }
  }
  
  int getFreeRowIn(int col, [bool invert=false]){
    if (invert){
      for (int y=rows-1; y>0; y--){
        if (tiles[xyToIndex(col,y)]==null){
          return y;
        }
      }
      return -1;
    }
    else{
      for (int y=0; y<rows; y++){
        if (tiles[xyToIndex(col,y)]==null){
          return y;
        }
      }
      return -1;
    }
  }
  
  int getFreeColIn(int row, [bool invert=false]){
    if (invert){
      for (int x=cols-1; x>0; x--){
        if (tiles[xyToIndex(x,row)]==null){
          return x;
        }
      }
      return -1;
    }
    else{
      for (int x=0; x<cols; x++){
        if (tiles[xyToIndex(x,row)]==null){
          return x;
        }
      }
      return -1;
    }
  }
  
  int xyToIndex(int x, int y){
    return y*cols+x;
  }
  
  void generateStartingTiles(){
    generateRandomStartingTile();
    //generateRandomStartingTile();
  }
  
  void generateRandomStartingTile(){
    putTileIn(0,0,new Color.fromRGB(240, 240, 240));
    putTileIn(0,2,new Color.fromRGB(240, 240, 240));
    putTileIn(0,4,new Color.fromRGB(240, 240, 240));
    
  }
  
  void restartGame(){
    for (int i=0; i<tiles.length; i++){
      tiles[i] = null;
    }
  }
  
  void putTileIn(int x, int y, Color color){
    int index = xyToIndex(x,y);
    
    if (tiles[index]==null){
      tiles[index] = new Tile(100,100);
      tiles[index].x = x*100;
      tiles[index].y = y*100;
      tiles[index].setColor(color);
    }
  }
  
  
  
}