class Board {

  TypeCell[][] cells;
  PVector position;
  int nbCellsX;
  int nbCellsY;
  int cellSize; // Each cell is a square
  String[] levelInfo; // Information to build the board

  Board(PVector position, int nbCellsX, int nbCellsY, String[] levelInfo) {
    this.position = position.copy();
    this.nbCellsX = nbCellsX;
    this.nbCellsY = nbCellsY;
    this.levelInfo = levelInfo.clone();
    this.cells = new TypeCell[this.nbCellsY][this.nbCellsX];

    for (int y = 0; y < this.nbCellsY; y++) {
      for (int x = 0; x < this.nbCellsX; x++) {
        switch (this.levelInfo[y].charAt(x)) {
        case 'E':
          this.cells[y][x] = TypeCell.EMPTY;
          break;
        case 'X':
          this.cells[y][x] = TypeCell.OBSTACLE;
          break;
        case 'S':
          this.cells[y][x] = TypeCell.SPACESHIP;
          break;
        case 'I':
          this.cells[y][x] = TypeCell.INVADER;
          break;
        default:
          this.cells[y][x] = TypeCell.EMPTY;
        }
      }
    }
  }

  PVector getCellCenter(int i, int j) {
    // Calculate the center position of a cell
    return new PVector(
      this.position.x + j * this.cellSize + (this.cellSize * 0.5),
      this.position.y + i * this.cellSize + (this.cellSize * 0.5)
      );
  }

  void drawIt() {
    stroke(255, 0, 0); // Red border
    strokeWeight(2);

    rectMode(CORNER);
    for (int i = 0; i < this.nbCellsX * this.nbCellsY; i++) {
      int column = i % this.nbCellsX;
      int row = i / this.nbCellsX;

      TypeCell cellType = this.cells[row][column];

      switch (cellType) {
      case EMPTY:
        fill(255); // White for empty cells
        break;
      case SPACESHIP:
        fill(0, 0, 255); // Blue for spaceship
        break;
      case INVADER:
        fill(255, 0, 0); // Red for invader
        break;
      case OBSTACLE:
        fill(0, 255, 0); // Green for obstacle
        break;
      default:
        fill(255);
        break;
      }

      float cellX = this.position.x + column * CELL_SIZE;
      float cellY = this.position.y + row * CELL_SIZE;

      rect(cellX, cellY, CELL_SIZE, CELL_SIZE);
    }
  }
  // Method to get the board layout as a string array
  String[] getBoardLayout() {
    String[] boardLayout = new String[nbCellsY];  // Array to hold each row of the board as a string

    for (int y = 0; y < nbCellsY; y++) {
      String row = "";  // Start with an empty string for the row
      for (int x = 0; x < nbCellsX; x++) {
        // Convert each cell type to a corresponding character
        switch (cells[y][x]) {
        case EMPTY:
          row += 'E';  // Concatenate 'E' for empty cells
          break;
        case OBSTACLE:
          row += 'X';  // Concatenate 'X' for obstacles
          break;
        case SPACESHIP:
          row += 'S';  // Concatenate 'S' for spaceship
          break;
        case INVADER:
          row += 'I';  // Concatenate 'I' for invader
          break;
        default:
          row += 'E';  // Default to empty if undefined
          break;
        }
      }
      boardLayout[y] = row; // Store the row as a string
    }

    return boardLayout;
  }
}
