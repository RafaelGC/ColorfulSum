library Scene;

import "dart:html";
import "dart:math";

import "SceneManager.dart" as mySceneManager;
import "Scene.dart";
import "Keyboard.dart";
import "Tile.dart";
import "HasBeenCollidedListener.dart";

class GameScene extends Scene implements HasBeenCollidedListener{
  
  List<Tile>tiles, copyTiles;
  num rows, cols;
  double tileWidth, tileHeight;
  
  bool aTileHasBeenAlreadyGenerated;
  
  bool wHasBeenReleased, aHasBeenReleased, sHasBeenReleased, dHasBeenReleased;
  
  int score;
  int bestScore;
  SpanElement scoreElement, bestScoreElement;
  InputElement restartButton;
  
  
  GameScene(CanvasRenderingContext2D target, num width, num height):super(target,width,height){
    rows = 4;
    cols = 4;
    
    tileWidth = width/cols;
    tileHeight = height/rows;
    
    tiles = new List<Tile>();
    copyTiles= new List<Tile>();
    for (int i = 0; i<rows*cols; i++){
      tiles.add(null);
      copyTiles.add(null);
    }
    
    
    wHasBeenReleased = true;
    aHasBeenReleased = true;
    sHasBeenReleased = true;
    dHasBeenReleased = true;
    

    
    scoreElement = querySelector("#score");
    bestScoreElement = querySelector("#bestScore");
    
    restartButton = querySelector("#restartButton");
    restartButton.onClick.listen(restartGame);
    
    if (window.localStorage.containsKey("csBestScore")){
      
      bestScore = int.parse(window.localStorage["csBestScore"]);
      bestScoreElement.innerHtml = bestScore.toString();
    }
    else{
      bestScore = 0;
    }
    
  }
  
  void onActivate(){
    super.onActivate();
    
    restartGame(null);
  }
  
  void manageEvents(double deltaTime){
    if (areAllTilesStopped()){
      if (this.countFreeTiles()==0){
        if (this.someTileAnimated()==false){
          if (!this.isThereAFusibleTile()){
            
            if (score>bestScore){
              bestScore = score;
              bestScoreElement.innerHtml = bestScore.toString();
              
              window.localStorage["csBestScore"] = bestScore.toString();
            }
            
            mySceneManager.activateScene("gameOverScene");
            this.onPause();
          }
        }
      }
      else{
        if (aTileHasBeenAlreadyGenerated==false){
          aTileHasBeenAlreadyGenerated = true;
          this.generateRandomTile();
        }
      }
      
      if (Keyboard.getInstance().isPressed(KeyCode.S)){
        if (sHasBeenReleased){
          sHasBeenReleased = false;
          copy();
          
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
                int targetFusionY = getSameColorTileInCol(x,y,tiles[i].colorId);
                
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
          
          if (hasChanged()){
            aTileHasBeenAlreadyGenerated = false;
          }
          
        }
        return; //Importante, si no, a veces se bloquean las casillas y se quedan inmóviles.
        
      }
      else{
        sHasBeenReleased = true;
      }
      
      if (Keyboard.getInstance().isPressed(KeyCode.W)){
        if (wHasBeenReleased){
          copy();
          wHasBeenReleased = false;
          for (int x=0; x<cols; x++){
            
            for (int y=1; y<rows;y++){
              int i = xyToIndex(x,y);
              if (tiles[i]!=null){
                
                int targetFusionY = this.getSameColorTileInCol(x, y, tiles[i].colorId,true);
                
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
          if (hasChanged()){
            aTileHasBeenAlreadyGenerated = false;
          }
        }
        return;
      }
      else{
        wHasBeenReleased = true;
      }
      
      if (Keyboard.getInstance().isPressed(KeyCode.D)){
        if (dHasBeenReleased){
          copy();
          dHasBeenReleased = false;
          
          for (int y=0; y<rows; y++){
            for (int x=cols-1; x>=0; x--){
              int i = xyToIndex(x,y);
              if (tiles[i]!=null){
                
                int targetFusionX = this.getSameColorTileInRow(y, x, tiles[i].colorId,false);
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
          if (hasChanged()){
            aTileHasBeenAlreadyGenerated = false;
          }
        }
        return;
      }
      else{
        dHasBeenReleased = true;
      }
      
      if (Keyboard.getInstance().isPressed(KeyCode.A)){
        if (aHasBeenReleased){
          copy();
          aHasBeenReleased = false;
          
          for (int y=0; y<rows; y++){
            for (int x=1; x<cols; x++){
              int i = xyToIndex(x,y);
              if (tiles[i]!=null){
                
                int targetFusionX = this.getSameColorTileInRow(y, x, tiles[i].colorId,true);
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
          if (hasChanged()){
            aTileHasBeenAlreadyGenerated = false;
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
    target.globalAlpha = 1;
    target.setFillColorRgb(255, 255, 204);
    target.fillRect(0, 0, width, height);

    for (Tile tile in tiles){
      if (tile!=null){
        tile.render(target);
      }
    }
  }
  
  void hasBeenCollided(Tile t){
    score+=(t.colorId*100);
    scoreElement.innerHtml = score.toString();
    
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
  
  int getSameColorTileInCol(int col, int start, int colorId, [bool invert=false]){
    if (invert){
      if (start>0){
        for (int y=start-1; y>=0; y--){
          int i = xyToIndex(col,y);
          if (tiles[i]!=null){
            if (tiles[i].colorId==colorId){
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
            if (tiles[i].colorId==colorId){
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
  
  int getSameColorTileInRow(int row, int start, int colorId, [bool invert=false]){
    if (invert){
      if (start>0){
        for (int x=start-1; x>=0; x--){
          int i = xyToIndex(x,row);
          if (tiles[i]!=null){
            if (tiles[i].colorId==colorId){
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
            if (tiles[i].colorId==colorId){
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
  
  void restartGame(Event ev){
    clearMap();
    generateStartingTiles();
    aTileHasBeenAlreadyGenerated = true;
     
    score = 0;
    scoreElement.innerHtml = "0";
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
            putTileInIndex(i,1);
          }
          else{
            putTileInIndex(i,0);
          }
          return i;
        }
      }
    }
    return -1;
    
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
  
  void putTileIn(int x, int y, int colorId){
    int index = xyToIndex(x,y);
    
    if (tiles[index]==null){
      tiles[index] = new Tile(tileWidth,tileHeight,this);
      tiles[index].x = x*tileWidth;
      tiles[index].y = y*tileHeight;
      tiles[index].setColor(colorId);
      tiles[index].restartAnimation();
    }
    
  }
  void putTileInIndex(int index, int colorId){
    if (tiles[index]==null){
      Point p = xyFromIndex(index);
      putTileIn(p.x,p.y,colorId);
    }    
  }
  
  Point xyFromIndex(int index){
    int y = (index~/cols);
    int x = (index-(y*cols)).toInt();
    return new Point(x,y);
  }
  
  void  copy(){
    for (int i = 0; i<tiles.length; i++){
      copyTiles[i] = tiles[i];
    }
  }
  bool hasChanged(){
    for (int i = 0; i<tiles.length; i++){
      if (copyTiles[i]!=tiles[i]){
        return true;
      }
    }
    return false;
  }
  
  bool isThereAFusibleTile(){
    for (int i=0; i<tiles.length; i++){
      if (canIFusion(i)){
        return true;
      }
    }
    return false;
  }
  
  bool canIFusion(int index){
    if (tiles[index]==null) {return false;}
    
    Point<int> myPosition = this.xyFromIndex(index);
    int myPosX = myPosition.x;
    int myPosY = myPosition.y;
    
    //Miramos hacia arriba.
    if (myPosY>0){
      int i = xyToIndex(myPosX,myPosY-1);
      if (tiles[i]!=null && tiles[i].colorId==tiles[index].colorId){
        return true;
      }
    }
    
    //Miramos hacia abajo.
    if (myPosY<(rows-1)){
      int i = xyToIndex(myPosX,myPosY+1);
      if (tiles[i]!=null && tiles[i].colorId==tiles[index].colorId){
        return true;
      }
    }
    
    //Miramos hacia la izquierda.
    if (myPosX>0){
      int i = xyToIndex(myPosX-1,myPosY);
      if (tiles[i]!=null && tiles[i].colorId==tiles[index].colorId){
        return true;
      }
    }
    
    //Miramos hacia la derecha.
    if (myPosX<(cols-1)){
      int i = xyToIndex(myPosX+1,myPosY);
      if (tiles[i]!=null && tiles[i].colorId==tiles[index].colorId){
        return true;
      }
    }
    
    return false;
    
  }
  
  bool someTileAnimated(){
    for (int i = 0; i<tiles.length; i++){
      if (tiles[i].animation){
        return true;
      }
    }
    return false;
  }
  
}