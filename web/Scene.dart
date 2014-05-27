library Scene;

import 'dart:html';

abstract class Scene{
   
  static const int ACTIVE = 0, INACTIVE=1, PAUSED=2;
  
  CanvasRenderingContext2D target;
  num width, height;
  
  int _currentState;
  
  Scene(CanvasRenderingContext2D target, num width, num height){
    this.target = target;
    this.width = width;
    this.height = height;
    
    _currentState = INACTIVE;
  }
  
  void onActivate(){
    _currentState = ACTIVE;
  }
  void onDeactive(){
    _currentState = INACTIVE;
  }
  void onPause(){
    _currentState = PAUSED;
  }
  
  void gameloop(double deltaTime){
    if (_currentState!=INACTIVE){
      if (_currentState==ACTIVE){
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