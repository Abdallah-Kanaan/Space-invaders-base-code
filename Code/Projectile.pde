class Projectile {
  PVector position;
  int cellX;
  int cellY;
  int direction; // 1 if shot by invader, -1 if shot by spaceship
  float size;
  float speed;
  PImage projectileImg;
  boolean isActive;

  Projectile(PVector position, int cellX, int cellY, int direction, float speed, float size, PImage projectileImg) {
    this.position = position.copy();
    this.cellX = cellX;
    this.cellY = cellY;
    this.speed = speed;
    this.size = size;
    this.direction = direction;
    this.projectileImg = projectileImg;
    this.isActive = true;
  }

  void update(Board board) {
    // Move the projectile
    this.move();

    // Calculate the new grid position
    int newCellY = (int) (this.position.y / CELL_SIZE);

    // Deactivate projectile if it moves out of bounds
    if (newCellY < 0 || newCellY >= board.nbCellsY) {
      this.isActive = false;
      return;
    }

    // Update cell position if the projectile has moved to a new grid cell
    if (newCellY != this.cellY) {
      this.cellY = newCellY;
    }
  }

  void move() {
    // Adjust projectile's vertical position
    this.position.y += this.speed * this.direction;
  }

  void drawIt() {
    if (this.isActive) {
      image(this.projectileImg, this.position.x, this.position.y, this.size, this.size);
    }
  }
}
