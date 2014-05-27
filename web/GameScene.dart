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
        for (int x=0;x<cols;x++){
          for (int y=rows-1; y>=0; y--){
            int i = xyToIndex(x,y);
            if (tiles[i]!=null){
              int objective = getFreeRowIn(x,true);
              if (objective>y){
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
  
  int getFreeRowIn(int col, [bool invertido=false]){
    if (invertido){
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
  
  int xyToIndex(int x, int y){
    return y*cols+x;
  }
  
  void generateStartingTiles(){
    generateRandomStartingTile();
    //generateRandomStartingTile();
  }
  
  void generateRandomStartingTile(){
    putTileIn(0,3,new Color.fromRGB(240, 240, 200));
    putTileIn(0,1,new Color.fromRGB(240, 240, 240));
    
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