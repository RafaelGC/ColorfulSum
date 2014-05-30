import "dart:html";

import "Scene.dart";
import "SceneManager.dart" as mySceneManager;
import "Keyboard.dart";
class GameOverScene extends Scene{
  
  double alpha;
  
  GameOverScene(CanvasRenderingContext2D target, num width, num height):super(target,width,height){
    alpha = 0.0;
  }
  
  void onActivate(){
    super.onActivate();
    alpha = 0.0;
  }
  
  void manageEvents(num deltaTime){
    if (Keyboard.getInstance().isPressed(KeyCode.ENTER)){
      mySceneManager.activateScene("gameScene");
      this.onDeactive();
    }
  }
  
  void logic(num deltaTime){
    if (alpha<1.0){
      alpha+=0.5*deltaTime;
      if (alpha>1.0){
        alpha = 1.0;
      }
    }
  }
  
  void render(){
    target.globalAlpha = alpha;
    
    target.setFillColorRgb(255, 255, 255);
    target.textAlign = "center";
    target.font = "normal 40pt Arial";
    target.fillText("Game over!", width/2, height/2);
    target.strokeText("Game over!", width/2, height/2);
    target.font = "normal 20pt Arial";
    target.setFillColorRgb(255, 0, 0);
    target.fillText("Press [ENTER] to play again.", width/2, height/2+50);
    target.setFillColorRgb(0, 0, 0);
    target.strokeText("Press [ENTER] to play again.", width/2, height/2+50);
  }
  
}