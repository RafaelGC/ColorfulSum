import 'dart:html';
import "SceneManager.dart" as mySceneManager;
import "GameScene.dart";

void main() {
  
  CanvasElement canvas = querySelector("#canvas");
  mySceneManager.initialize();
  
  GameScene gameScene = new GameScene(canvas.context2D,canvas.width,canvas.height);
  mySceneManager.addScene(gameScene);
  gameScene.onActivate();
  
  mySceneManager.startGameloop();
  
}

