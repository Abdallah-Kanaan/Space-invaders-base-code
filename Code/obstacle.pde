class Obstacle {
  PVector position;
  int cellX;
  int cellY;
  int health;
  Status status;

  Obstacle(PVector position, int cellX, int cellY, int health) {
    this.position = position.copy();
    this.cellX = cellX;
    this.cellY = cellY;
    this.health = health;
    this.status = Status.ALIVE;
  }

  void update(Board board) {
    this.health--;

    if (this.health <= 0) {
      this.status = Status.DEAD;
      board.cells[this.cellY][this.cellX] = TypeCell.EMPTY;
    }
  }

  void drawIt() {
    float x = this.cellX * CELL_SIZE;
    float y = this.cellY * CELL_SIZE;

    // Draw the obstacle background
    stroke(0);
    strokeWeight(2);
    fill(128, 128, 128); // Grey background
    rect(x, y, CELL_SIZE, CELL_SIZE);

    // Draw the current health bar
    noStroke();
    fill(0, 255, 0); // Green health bar
    float healthBarWidth = (this.health / 20.0) * CELL_SIZE;
    rect(x, y, healthBarWidth, CELL_SIZE); // Shrinks as health decreases
  }
}
