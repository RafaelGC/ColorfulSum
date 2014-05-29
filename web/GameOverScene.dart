import "dart:html";

import "Scene.dart";
import "SceneManager.dart" as mySceneManager;
import "Keyboard.dart";
class GameOverScene extends Scene{
  
  GameOverScene(CanvasRenderingContext2D target, num width, num height):super(target,width,height){
    
  }
  
  void manageEvents(num deltaTime){
    if (Keyboard.getInstance().isPressed(KeyCode.ENTER)){
      mySceneManager.activateScene("gameScene");
      this.onDeactive();
    }
  }
  
  void logic(num deltaTime){
    
  }
  
  void render(){
    target.setFillColorRgb(255, 255, 255);
    target.textAlign = "center";
    target.font = "normal 40pt Arial";
    target.fillText("Game over!", width/2, height/2);
    target.strokeText("Game over!", width/2, height/2);
    target.font = "normal 20pt Arial";
    target.setFillColorRgb(0, 0, 0);
    target.fillText("Press [ENTER] to play again.", width/2, height/2+50);
  }
  
}