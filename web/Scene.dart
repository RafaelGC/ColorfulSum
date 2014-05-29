library Scene;

import 'dart:html';

abstract class Scene{
   
  static const int ACTIVE = 0, INACTIVE=1, PAUSED=2;
  
  CanvasRenderingContext2D target;
  num width, height;
  
  int currentState;
  
  Scene(CanvasRenderingContext2D target, num width, num height){
    this.target = target;
    this.width = width;
    this.height = height;
    
    currentState = INACTIVE;
  }
  
  void onActivate(){
    currentState = ACTIVE;
  }
  void onDeactive(){
    currentState = INACTIVE;
  }
  void onPause(){
    currentState = PAUSED;
  }
  
  void gameloop(double deltaTime){
    if (currentState!=INACTIVE){
      if (currentState==ACTIVE){
        manageEvents(deltaTime);
        logic(deltaTime);
      }
      
      render();
    }
  }
  
  void render();
  void logic(double deltaTime);
  void manageEvents(double deltaTime);

}