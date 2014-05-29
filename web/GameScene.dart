library Scene;

import "dart:html";
import "dart:math";

import "SceneManager.dart" as mySceneManager;
import "Scene.dart";
import "Keyboard.dart";
import "Tile.dart";
import "Color.dart";
import "HasBeenCollidedListener.dart";

class GameScene extends Scene implements HasBeenCollidedListener{
  
  List<Tile>tiles;
  num rows, cols;
  double tileWidth, tileHeight;
  
  bool aTileHasBeenAlreadyGenerated;
  
  bool wHasBeenReleased, aHasBeenReleased, sHasBeenReleased, dHasBeenReleased;
  
  GameScene(CanvasRenderingContext2D target, num width, num height):super(target,width,height){
    rows = 4;
    cols = 4;
    
    tileWidth = width/cols;
    tileHeight = height/rows;
    
    tiles = new List<Tile>();
    for (int i = 0; i<rows*cols; i++){
      tiles.add(null);
    }
    
    
    wHasBeenReleased = true;
    aHasBeenReleased = true;
    sHasBeenReleased = true;
    dHasBeenReleased = true;
    
  }
  
  void onActivate(){
    super.onActivate();
    clearMap();
    generateStartingTiles();
    aTileHasBeenAlreadyGenerated = true;
  }
  
  void manageEvents(double deltaTime){
    if (areAllTilesStopped()){
      if (aTileHasBeenAlreadyGenerated==false){
        if (this.isTheBoardFull()){
          mySceneManager.activateScene("gameOverScene");
          this.onPause();
        }
        else{
          this.generateRandomTile();
        }
        aTileHasBeenAlreadyGenerated = true;
      }
      if (Keyboard.getInstance().isPressed(KeyCode.S)){
        if (sHasBeenReleased){
          aTileHasBeenAlreadyGenerated = false;
          sHasBeenReleased = false;
          
          //Vamos recorriendo columna por columna.
          for (int x=0; x<cols; x++){
            
            //Y en la columna vamos estudiando las distintas casillas.
            //La que está en la casilla 4 está en su posición ideal, no puede ir más abajo, luego
            //no nos interesa estudiarla, por eso empezamos por la tercera.
            
            for (int y=rows-2; y>=0; y--){
              
              //i es la casilla que nos interesa estudiar, la que moveremos si procede.
              int i = xyToIndex(x,y);
              
              //Miramos si hay algo en ese hueco, quizá no hay nada.
              if (tiles[i]!=null){
                
                //Pero sí que lo hay, entonces pueden ocurrir dos cosas: que debajo de nuetra celda
                //(da igual a qué distancia siempre y cuando no se interponga otra casilla) haya otra con el mismo
                //color o bien que no ocurra eso.
                
                //Esta variable nos devolverá el número de la fila donde haya una casilla con la que nos podamos
                //fusionar, si no hay tal casilla, la variable valdrá -1.
                int targetFusionY = getSameColorTileInCol(x,y,tiles[i].color);
                
                //En el caso de que haya alguna casilla a la que nos podamos fusionar y, además, con esa casilla
                //no se esté combinando ninguna otra...
                if (targetFusionY!=-1 && tiles[xyToIndex(x,targetFusionY)].child==null){
                  
                  //Vemos cuál es.
                  int indexFusion = xyToIndex(x,targetFusionY);
                  
                  //Y configuramos el movimiento que tendrá la pieza.
                  tiles[i].targetX = tiles[i].x; //La x no variará.
                  //En el caso de que nuestra casilla de destino se esté moviendo, nos tendremos que ir a su
                  //casilla de destino.
                  if (tiles[indexFusion].movingVertical){
                    //Por eso hago esto.
                    tiles[i].targetY = tiles[indexFusion].targetY;
                  }
                  else{
                    //Pero si no se está moviendo, simplemente vamos a su posición.
                    tiles[i].targetY = tiles[indexFusion].y;
                  }
                  //E iniciamos el movimiento.
                  tiles[i].movingVertical = true;
                  
                  //Procedemos a eliminar la casilla del tablero, ahora pasará a ser gestionada por la casilla
                  //padre, la casilla con la que se va a fusionar.
                  tiles[indexFusion].child = tiles[i];
                  tiles[i] = null;
                  
                }
                else{
                  //Si no hay casilla con la que combinarnos, simplemente buscamos una casilla vacía para
                  //posicionarnos en ella, la buscamos:
                  int targetY = getFreeRowIn(x,true);
                  //Y calculamos su índice porque lo necesitaremos...
                  int indexTarget = xyToIndex(x,targetY);
                  
                  //Obviamente, sólo nos interesa esa casilla blanca si está por debajo, no por encima, ya que
                  //nos estamos moviendo hacia abajo.
                  if (targetY!=-1 && targetY>y){
                    //Y procedemos a iniciar su movimiento...
                    tiles[i].targetX = tiles[i].x;
                    tiles[i].targetY = targetY*tileHeight;
                    tiles[i].movingVertical = true;
                    
                    //Y cambiamos su posición en el array.
                    tiles[indexTarget] = tiles[i];
                    tiles[i] = null;
                    
                  }
                }
  
              }
              
            }
            
          }
        }
        return; //Importante, si no, a veces se bloquean las casillas y se quedan inmóviles.
        
      }
      else{
        sHasBeenReleased = true;
      }
      
      if (Keyboard.getInstance().isPressed(KeyCode.W)){
        if (wHasBeenReleased){
          aTileHasBeenAlreadyGenerated = false;
          wHasBeenReleased = false;
          for (int x=0; x<cols; x++){
            
            for (int y=1; y<rows;y++){
              int i = xyToIndex(x,y);
              if (tiles[i]!=null){
                
                int targetFusionY = this.getSameColorTileInCol(x, y, tiles[i].color,true);
                
                if (targetFusionY!=-1 && tiles[xyToIndex(x,targetFusionY)].child==null){
                  int indexFusion = xyToIndex(x,targetFusionY);
                  
                  tiles[i].targetX = tiles[i].x;
                  if (tiles[indexFusion].movingVertical){
                    tiles[i].targetY = tiles[indexFusion].targetY;
                  }
                  else{
                    tiles[i].targetY = tiles[indexFusion].y;
                  }
                  tiles[i].movingVertical = true;
                  
                  tiles[indexFusion].child = tiles[i];
                  tiles[i] = null;
                  
                }
                else{
                  int targetY = getFreeRowIn(x,false);
                  int indexTarget = xyToIndex(x,targetY);
                  
                  if (targetY!=-1 && targetY<y){
                    tiles[i].targetX = tiles[i].x;
                    tiles[i].targetY = targetY*tileHeight;
                    tiles[i].movingVertical = true;
                    
                    tiles[indexTarget] = tiles[i];
                    tiles[i] = null;
                    
                  }
                }
              }
              
            }
            
          }
        }
        return;
      }
      else{
        wHasBeenReleased = true;
      }
      
      if (Keyboard.getInstance().isPressed(KeyCode.D)){
        if (dHasBeenReleased){
          aTileHasBeenAlreadyGenerated = false;
          dHasBeenReleased = false;
          
          for (int y=0; y<rows; y++){
            for (int x=cols-1; x>=0; x--){
              int i = xyToIndex(x,y);
              if (tiles[i]!=null){
                
                int targetFusionX = this.getSameColorTileInRow(y, x, tiles[i].color,false);
                if (targetFusionX!=-1 && tiles[xyToIndex(targetFusionX,y)].child==null){
                  int indexFusion = xyToIndex(targetFusionX,y);
                  
                  tiles[i].targetY = tiles[i].y;
                  if (tiles[indexFusion].movingHorizontal){
                    tiles[i].targetX = tiles[indexFusion].targetX;
                  }
                  else{
                    tiles[i].targetX = tiles[indexFusion].x;
                  }
                  tiles[i].movingHorizontal = true;
                  
                  tiles[indexFusion].child = tiles[i];
                  tiles[i] = null;
                  
                }
                else{
                  int targetX = getFreeColIn(y,true);
                  int indexTarget = xyToIndex(targetX,y);
                  
                  if (targetX!=-1 && targetX>x){
                    tiles[i].targetX = targetX*tileWidth;
                    tiles[i].targetY = tiles[i].y;
                    tiles[i].movingHorizontal = true;
                    
                    tiles[indexTarget] = tiles[i];
                    tiles[i] = null;
                    
                  }
                }
              }
              
            }
            
          }
        }
        return;
      }
      else{
        dHasBeenReleased = true;
      }
      
      if (Keyboard.getInstance().isPressed(KeyCode.A)){
        if (aHasBeenReleased){
          aTileHasBeenAlreadyGenerated = false;
          aHasBeenReleased = false;
          
          for (int y=0; y<rows; y++){
            for (int x=1; x<cols; x++){
              int i = xyToIndex(x,y);
              if (tiles[i]!=null){
                
                int targetFusionX = this.getSameColorTileInRow(y, x, tiles[i].color,true);
                if (targetFusionX!=-1 && tiles[xyToIndex(targetFusionX,y)].child==null){
                  int indexFusion = xyToIndex(targetFusionX,y);
                  
                  tiles[i].targetY = tiles[i].y;
                  if (tiles[indexFusion].movingHorizontal){
                    tiles[i].targetX = tiles[indexFusion].targetX;
                  }
                  else{
                    tiles[i].targetX = tiles[indexFusion].x;
                  }
                  tiles[i].movingHorizontal = true;
                  
                  tiles[indexFusion].child = tiles[i];
                  tiles[i] = null;
                  
                }
                else{
                  int targetX = getFreeColIn(y,false);
                  int indexTarget = xyToIndex(targetX,y);
                  
                  if (targetX!=-1 && targetX<x){
                    tiles[i].targetX = targetX*tileWidth;
                    tiles[i].targetY = tiles[i].y;
                    tiles[i].movingHorizontal = true;
                    
                    tiles[indexTarget] = tiles[i];
                    tiles[i] = null;
                    
                  }
                }
              }
              
            }
            
          }
        }
        return;
      }
      else{
        aHasBeenReleased = true;
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
    target.setFillColorRgb(100, 100, 100);
    target.fillRect(0, 0, width, height);

    for (Tile tile in tiles){
      if (tile!=null){
        tile.render(target);
      }
    }
  }
  
  void hasBeenCollided(){
  }
  
  bool isTheBoardFull(){
    for (Tile t in tiles){
      if (t==null){
        return false;
      }
    }
    return true;
  }
  
  bool areAllTilesStopped(){
    for (Tile t in tiles){
      if (t!=null){
        if (t.isMoving()==true){
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
          tiles[i].x = x*tileWidth;
          tiles[i].y = y*tileHeight;
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
  
  int getSameColorTileInCol(int col, int start, Color color, [bool invert=false]){
    if (invert){
      if (start>0){
        for (int y=start-1; y>=0; y--){
          int i = xyToIndex(col,y);
          if (tiles[i]!=null){
            if (tiles[i].color==color){
              return y;
            }
            else{
              //En el momento en el que encontramos uno de un color diferente, no nos sirve.
              return -1;
            }
          }
        }
      }
    }
    else{
      if (start<rows-1){
        for (int y=start+1; y<rows; y++){
          int i = xyToIndex(col,y);
          if (tiles[i]!=null){
            if (tiles[i].color==color){
              return y;
            }
            else{
              return -1;
            }
          }
        }
      }
    }
    return -1;
  }
  
  int getSameColorTileInRow(int row, int start, Color color, [bool invert=false]){
    if (invert){
      if (start>0){
        for (int x=start-1; x>=0; x--){
          int i = xyToIndex(x,row);
          if (tiles[i]!=null){
            if (tiles[i].color==color){
              return x;
            }
            else{
              //En el momento en el que encontramos uno de un color diferente, no nos sirve.
              return -1;
            }
          }
        }
      }
    }
    else{
      if (start<cols-1){
        for (int x=start+1; x<rows; x++){
          int i = xyToIndex(x,row);
          if (tiles[i]!=null){
            if (tiles[i].color==color){
              return x;
            }
            else{
              return -1;
            }
          }
        }
      }
    }
    return -1;
  }
  
  int xyToIndex(int x, int y){
    return y*cols+x;
  }
  
  void generateStartingTiles(){
    generateRandomTile();
    generateRandomTile();
  }
  
  int generateRandomTile(){
    
    int freeTiles = countFreeTiles();
    if (freeTiles==0){
      return -1;
    }
    
    Random rand = new Random();
    int n = rand.nextInt(freeTiles);
    
    for (int i = 0; i<tiles.length; i++){
      if (tiles[i]==null){
        n--;
        if (n==-1){
          int special = rand.nextInt(5);
          if (special==0){
            putTileInIndex(i,new Color.fromRGB(240, 200, 200));
          }
          else{
            putTileInIndex(i,new Color.fromRGB(240, 240, 240));
          }
          print("Generado en: "+i.toString());
        }
      }
    }
    
    /*int rX = rand.nextInt(cols-1);
    int rY = rand.nextInt(rows-1);
    
    int target = xyToIndex(rX,rY);
    
    //Si la casilla está libre.
    if (tiles[target]==null){
      //Ponemos...
      putTileIn(rX,rY,new Color.fromRGB(240,240,240));
      return target;
    }
    else{
      //Buscamos un sitio libre...
      int originalTarget = target; //Copia para más adelante.
      for (target+=1; target<tiles.length-1; target++){
        if (tiles[target]==null){
          putTileInIndex(target,new Color.fromRGB(240,240,240));
          return target;
        }
      }
      
      //Si hemos llegado hasta este punto es porque desde donde intentamos poner el tile hasta
      //el final no hay huecos, pero quizá sí los había antes, entonces hacemos el recorrido
      //al revés.
      target = originalTarget;
      
      for (target-=1; target>0; target--){
        if (tiles[target]==null){
          putTileInIndex(target,new Color.fromRGB(240,240,240));
          return target;
        }
      }
      
      //Y si llegamos hasta este punto... Es porque no quedan casillas libres. ¡Fin del juego!
      return -1;
    }*/
    
  }
  
  int countFreeTiles(){
    int n = 0;
    for (Tile tile in tiles){
      if (tile==null){
        n++;
      }
    }
    return n;
  }
  
  void clearMap(){
    for (int i=0; i<tiles.length; i++){
      tiles[i] = null;
    }
  }
  
  void putTileIn(int x, int y, Color color){
    int index = xyToIndex(x,y);
    
    if (tiles[index]==null){
      tiles[index] = new Tile(tileWidth,tileHeight,this);
      tiles[index].x = x*tileWidth;
      tiles[index].y = y*tileHeight;
      tiles[index].setColor(color);
    }
    
  }
  void putTileInIndex(int index, Color color){
    if (tiles[index]==null){
      Point p = xyFromIndex(index);
      putTileIn(p.x,p.y,color);
    }    
  }
  
  Point xyFromIndex(int index){
    int y = (index~/cols);
    int x = (index-(y*cols)).toInt();
    return new Point(x,y);
  }
  
}