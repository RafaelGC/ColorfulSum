library SceneManager;

import "Scene.dart";

import "dart:async";
import "dart:html";

Map<String,Scene> _scenes;

num _previousTime;

void initialize(){
  _scenes = new Map<String,Scene>();
  _previousTime = 0;
}

void addScene(String name, Scene scene){
  _scenes[name] = scene;
}

void activateScene(String name){
  Scene scene = _scenes[name];
  scene.onActivate();
}

void deactivateScene(String name){
  Scene scene = _scenes[name];
  scene.onDeactive();
}

void pauseScene(String name){
  Scene scene = _scenes[name];
  scene.onPause();
}

void loop(Timer t){
  
  num now = window.performance.now();
  num deltaTime = (now-_previousTime)/1000;
  _previousTime = now;
  

  Iterable<Scene> iterator = _scenes.values;
  for (Scene scene in iterator){
    scene.gameloop(deltaTime);
  }
}

void startGameloop(){
  Timer timer = new Timer.periodic(const Duration(milliseconds:5),loop);
}
