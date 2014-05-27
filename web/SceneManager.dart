library SceneManager;

import "Scene.dart";

import "dart:async";
import "dart:html";

List<Scene> _scenes;

num _previousTime;

void initialize(){
  _scenes = new List<Scene>();
  _previousTime = 0;
}

void addScene(Scene scene){
  _scenes.add(scene);
}

void loop(Timer t){
  
  num now = window.performance.now();
  num deltaTime = (now-_previousTime)/1000;
  _previousTime = now;
  
  for (Scene scene in _scenes){
    scene.gameloop(deltaTime);
  }
}

void startGameloop(){
  Timer timer = new Timer.periodic(const Duration(milliseconds:5),loop);
}
