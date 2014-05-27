library Keyboard;

import 'dart:html';

class Keyboard {
  List<int> _keys = new List<int>();
  static Keyboard _instance = null;
  
  Keyboard() {
    window.onKeyDown.listen(keyHasBeenPressed);
    window.onKeyUp.listen(keyHasBeenReleased);
  }
  
  void keyHasBeenPressed(KeyboardEvent e){
    forceKeyPress(e.keyCode);
  }
  
  void keyHasBeenReleased(KeyboardEvent e){
    forceKeyRelease(e.keyCode);
  }

  
  bool isPressed(int keyCode){
    return _keys.contains(keyCode);
  }
  
  void forceKeyPress(int keyCode){
    if (!_keys.contains(keyCode)){
         _keys.add(keyCode);
    }
  }
  
  void forceKeyRelease(int keyCode){
    _keys.remove(keyCode);
  }
  
  static Keyboard getInstance(){
    if (_instance==null){
      _instance = new Keyboard();
    }
    return _instance;
  }
}