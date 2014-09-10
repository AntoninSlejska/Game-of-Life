part of life;

class Grid {
  static int NUM_CELLS_WIDE = querySelector("#lifeCanvas").clientWidth ~/ Cell.WIDTH;
  static int NUM_CELLS_TALL = querySelector("#lifeCanvas").clientHeight ~/ Cell.HEIGHT;

  CanvasElement lifeCanvas;
  Map<Point, Cell> cells = new Map();
  Point lastFlip = new Point(-1, -1);
  int generation = 0, numLiveCells = 0;
  DateTime lastTime, newTime;
  double durationTotal = 0.0;
  
  Grid(this.lifeCanvas) {
    for (int x = 0; x < NUM_CELLS_WIDE; x++) {
      for (int y = 0; y < NUM_CELLS_TALL; y++) {
        Point location = new Point(x, y);
        cells[location] = new Cell(location);
      }
    }
  }
  /// Get a cell at a given location by looking it up in the cells Map.
  /// If its coordinates are off the end of the grid, we wrap aroun to the other side of the grid.
  Cell getCell(int x, int y) {
    if (x < 0) {
      x = NUM_CELLS_WIDE - 1;
    } else if (x >= NUM_CELLS_WIDE) {
      x = 0;
    }
    if (y < 0) {
        y = NUM_CELLS_TALL - 1;
    } else if (y >= NUM_CELLS_TALL) {
        y = 0;
    }
    return cells[new Point(x, y)];
  }
  
  /// Switch the status of the cell at the location x, y
  void flip(int x, int y) {
    Point point = new Point(x ~/ Cell.WIDTH, y ~/ Cell.HEIGHT);
    Cell cell = cells[point];
    if (cell != cells[lastFlip]) {  // The cell will flip only if it was not flipped resently
      cell.alive = !cell.alive;
      cell.activated = true;
      lastFlip = point;
      cell.draw(lifeCanvas.context2D);
    }
  }
 
  /// Check the eight cells around [cell] to see if they're alive count how many of them are.
  int aliveNeighbors(Cell cell) {
    int x = cell.location.x, y = cell.location.y;
    int newX, newY;
    int numAlive = 0;
    //top left cell
    newX = x - 1;
    newY = y - 1;
    if (getCell(newX, newY).alive) {
      numAlive++;
    }
    // top cell
    newX = x;
    newY = y - 1;
    if (getCell(newX, newY).alive) {
      numAlive++;
    }
    // top right cell
    newX = x + 1;
    newY = y - 1;
    if (getCell(newX, newY).alive) {
      numAlive++;
    }
    // left cell
    newX = x - 1;
    newY = y;
    if (getCell(newX, newY).alive) {
      numAlive++;
    }
    // right cell
    newX = x + 1;
    newY = y;
    if (getCell(newX, newY).alive) {
      numAlive++;
    }
    // bottom left cell
    newX = x - 1;
    newY = y + 1;
    if (getCell(newX, newY).alive) {
      numAlive++;
    }
    // bottom cell
    newX = x;
    newY = y + 1;
    if (getCell(newX, newY).alive) {
      numAlive++;
    }
    // bottom right cell
    newX = x + 1;
    newY = y + 1;
    if (getCell(newX, newY).alive) {
      numAlive++;
    }
    return numAlive;
  }
  
  /// Draw the whole grid once - useful before any play takes place
  void drawOnce() {
    CanvasRenderingContext2D c2d = lifeCanvas.context2D;
    for (Cell cell in cells.values) {
      cell.draw(c2d);
    }
  }
  
  /// Clear the canvas
  void clear() {
    for (Cell cell in cells.values) {
      cell.activated = false;
      cell.alive = false;
      cell.draw(lifeCanvas.context2D);
    }
    generation = 0;
    numLiveCells = 0;
    lastTime = null;
    durationTotal = 0.0;
    querySelector("#generation").text = generation.toString();
    querySelector("#liveCells").text = numLiveCells.toString();
    querySelector("#durationTotal").text = "0 ms";
    querySelector("#durationLastStep").text = "0 ms";
    querySelector("#durationAverage").text = "0 s";
  }
  
  /// Draw the selected pattern
  void drawPattern(List pattern) {
    for (Point point in pattern) {
      Cell cell = cells[point];
      cell.alive = true;
      cell.activated = true;
      cell.draw(lifeCanvas.context2D);
    }
  }
  
  /// Figure out what the next generation should look like, then flip everyone over into the next generation and redraw.
  void update(Timer t) {
    numLiveCells = 0;
    if (lastTime == null) {
      lastTime = new DateTime.now();
    } else {
      lastTime = newTime;
    }
    for (Cell cell in cells.values) {
      int livingNeighbors = aliveNeighbors(cell);
      cell.aliveNextGeneration = false;
      if (cell.alive) {
        if (livingNeighbors == 3 || livingNeighbors == 2) {
          cell.aliveNextGeneration = true;
          numLiveCells++;
        }
      } else if (livingNeighbors == 3) {
        cell.aliveNextGeneration = true;
        cell.activated = true;
        numLiveCells++;
      }
    }
    CanvasRenderingContext2D c2d = lifeCanvas.context2D;
    for (Cell cell in cells.values) {
      cell.alive = cell.aliveNextGeneration;
      cell.draw(c2d);
    }
    generation++;
    newTime = new DateTime.now();
    int durationLastStep = newTime.difference(lastTime).inMilliseconds;
    durationTotal += durationLastStep / 1000;
    double durationAverage = durationTotal * 1000 / generation;
    querySelector("#durationTotal").text = durationTotal.round().toString() + " s";
    querySelector("#durationLastStep").text = durationLastStep.toString() + " ms";
    querySelector("#durationAverage").text = durationAverage.round().toString() + " ms";
    querySelector("#generation").text = generation.toString();
    querySelector("#liveCells").text = numLiveCells.toString();
  }
  
  void export() {
    for (Cell cell in cells.values) {
      if (cell.alive) {
        cell.export();
      }
    }
  }
}