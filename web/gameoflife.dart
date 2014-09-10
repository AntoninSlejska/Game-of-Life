library life;

import 'dart:html';
import 'dart:math';
import 'dart:async';

part "cell.dart";
part "grid.dart";
part "pattern.dart";

Timer timer;
Grid grid;

/// When the canvas is clicked or the mouse is hold a cell is fliped.
void clickHappend (MouseEvent event) {
  int clickX = event.offset.x;
  int clickY = event.offset.y;
  grid.flip(clickX, clickY);
  grid.lastFlip = new Point(-1,-1);
}

void mouseIsDown (MouseEvent event) {
  int clickX = event.offset.x;
  int clickY = event.offset.y;
  grid.flip(clickX, clickY);
}

void clickEvent(MouseEvent event) {
  ButtonElement clickedButton = event.target;
  switch (clickedButton.id) {
    case "startStop" :
      if (timer == null) {
        timer = new Timer.periodic(const Duration(milliseconds: 1), grid.update);
        querySelector("#startStop").text = "Stop";
      } else {
        timer.cancel();
        timer = null;
        querySelector("#startStop").text = "Start";
      }
      break;
    case "clear" :
      grid.clear();
      break;
    case "export" :
      grid.export();
      break;
    case "acorn" :
      Pattern p = new Pattern();
      grid.drawPattern(p.acorn);
      break;
    case "gosperGliderGun" :
      Pattern p = new Pattern();
      grid.drawPattern(p.gosperGliderGun);
      break;
    case "stillLife" :
      Pattern p = new Pattern();
      grid.drawPattern(p.stillLife);
      break;
    case "neverEndingChange" :
      Pattern p = new Pattern();
      grid.drawPattern(p.neverEndingChange);
      break;
    case "line" :
      Pattern p = new Pattern();
      grid.drawPattern(p.line);
      break;
    case "random" :
      Pattern p = new Pattern();
      grid.drawPattern(p.random());
      break;
    default :
      break;
  } 
}

void main() {
  CanvasElement lifeCanvas = querySelector("#lifeCanvas");
  grid = new Grid(lifeCanvas);
  grid.drawOnce();
  
  StreamSubscription streamSub;
  var cancel = (MouseEvent event) {
    streamSub.cancel(); // stop listening
    };
  var mouseDown =  (MouseEvent event) {
    streamSub = lifeCanvas.onMouseMove.listen(mouseIsDown);
  };
  lifeCanvas.onClick.listen(clickHappend);
  lifeCanvas.onMouseDown.listen(mouseDown);
  lifeCanvas.onMouseUp.listen(cancel);
  
  querySelector("#startStop").onClick.listen(clickEvent);
  querySelector("#clear").onClick.listen(clickEvent);
  querySelector("#export").onClick.listen(clickEvent);
  querySelector("#acorn").onClick.listen(clickEvent);
  querySelector("#gosperGliderGun").onClick.listen(clickEvent);
  querySelector("#stillLife").onClick.listen(clickEvent);
  querySelector("#neverEndingChange").onClick.listen(clickEvent);
  querySelector("#line").onClick.listen(clickEvent);
  querySelector("#random").onClick.listen(clickEvent);
}
