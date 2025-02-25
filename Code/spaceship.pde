class Spaceship {
  PVector position;
  int cellX;
  int cellY;
  float size;
  int isMoving;
  Skin skin;
  PImage projectileImg;

  Spaceship(PVector position, int cellX, int cellY, float size, PImage projectileImg) {
    this.position = position.copy();
    this.cellX = cellX;
    this.cellY = cellY;
    this.size = size;
    this.projectileImg = projectileImg;
    this.skin = Skin.SPACESHIP;
  }

  void move(Board board, PVector dir) {
    // Move left if within bounds
    if (dir.x == -1 && this.position.x - SPACESHIP_SPEED > board.position.x) {
      this.position.x -= SPACESHIP_SPEED;
    }

    // Move right if within bounds
    if (dir.x == 1 && this.position.x + SPACESHIP_SPEED < board.position.x + board.nbCellsX * CELL_SIZE) {
      this.position.x += SPACESHIP_SPEED;
    }

    // Update cell position if the spaceship has moved out of its current cell
    boolean isInside = this.position.x > this.cellX * CELL_SIZE && this.position.x < this.cellX * CELL_SIZE + CELL_SIZE;

    if (!isInside) {
      board.cells[this.cellY][this.cellX] = TypeCell.EMPTY;
      this.cellX = (int) (this.position.x / CELL_SIZE);
      board.cells[this.cellY][this.cellX] = TypeCell.SPACESHIP;
    }
  }

  void update(Board board) {
    PVector direction = new PVector(this.isMoving, 0);
    this.move(board, direction);
  }

  void drawIt() {
    stroke(0, 128, 0);
    strokeWeight(10);
    point(this.position.x, this.position.y);
    imageMode(CENTER);
    image(spaceshipImg, this.position.x, this.position.y, CELL_SIZE, CELL_SIZE);
  }

  void shoot(ArrayList<Projectile> listProjectiles) {
    int direction = -1; // Spaceship projectiles move upward
    int projectileSize = 20;
    Projectile projectile = new Projectile(this.position.copy(), this.cellX, this.cellY, direction, PROJECTILE_SPEED, projectileSize, this.projectileImg);
    listProjectiles.add(projectile);
    laserShotSound.play();
  }
}
