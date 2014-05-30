import "dart:html";

import "SceneManager.dart" as mySceneManager;
import "GameScene.dart";
import "GameOverScene.dart";
import "ColorList.dart" as myColorList;

void main() {
  
  myColorList.initialize();
  

  
  CanvasElement canvas = querySelector("#canvas");
  
  print(window.innerWidth);
  
  if (window.innerWidth<canvas.width){
    canvas.width = window.innerWidth;
  }
  
  mySceneManager.initialize();
  
  GameScene gameScene = new GameScene(canvas.context2D,canvas.width,canvas.height);
  mySceneManager.addScene("gameScene",gameScene);
  gameScene.onActivate();
  
  GameOverScene gameOverScene = new GameOverScene(canvas.context2D,canvas.width,canvas.height);
  mySceneManager.addScene("gameOverScene",gameOverScene);
  
  mySceneManager.startGameloop();
  
}

