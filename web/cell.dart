part of life;

class Cell {
  bool alive = false;
  bool activated = false;
  bool aliveNextGeneration = false;
  Point location;
  
  static const int WIDTH = 5;
  static const int HEIGHT = 5;
  
  Cell(this.location);
  
  /// Each Cell can draws itself
  void draw(CanvasRenderingContext2D c2d) {
    if (alive) {
      c2d.setFillColorRgb(0, 0, 255); // blue
    } else if (activated) {
      c2d.setFillColorRgb(150, 150, 255); // light blue
    } else {
      c2d.setFillColorRgb(255, 255, 255); // white
    }
    c2d.fillRect(location.x * WIDTH, location.y * HEIGHT, WIDTH, HEIGHT);
    
    c2d.setStrokeColorRgb(200, 200, 200);
    c2d.strokeRect(location.x * WIDTH, location.y * HEIGHT, WIDTH, HEIGHT);
  }
  
  void export() {
    DivElement cellInfo = new DivElement();
    var fragment = new DocumentFragment.html("&nbsp;&nbsp;&nbsp;&nbsp;");
    cellInfo.text = fragment.text + "new " + this.location.toString() + ",";
    document.body.nodes.add(cellInfo);
  }
}