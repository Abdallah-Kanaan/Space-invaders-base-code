class Invader {
  PVector position;  // Screen position
  int cellX, cellY; // board position
  float size;
  int level;
  Skin skin;
  PImage projectileImg;

  Invader(PVector position, int cellX, int cellY, float size, Skin skin) {
    this.position = position.copy();
    this.cellX = cellX;
    this.cellY = cellY;
    this.size = size;
    this.skin = skin;
    
    switch (skin) {
    case CYAN1:
    case CYAN2:
      projectileImg = cyanShot;
      break;
    case RED1:
    case RED2:
      projectileImg = redShot;
      break;
    case YELLOW1:
    case YELLOW2:
      projectileImg = yellowShot;
      break;
    case GREEN1:
    case GREEN2:
      projectileImg = greenShot;
      break;
    default:
      projectileImg = greenShot;
      break;
    }
  }

  void move(int direction) {
    this.position.x += CELL_SIZE * direction; // Move horizontally
    this.skin = this.skin.nextSkin();
  }

  void moveDown() {
    this.position.y += CELL_SIZE; // Move vertically
    this.skin = this.skin.nextSkin();
  }

  void drawIt() {
    stroke(255, 0, 0);
    strokeWeight(10);
    imageMode(CENTER);

    switch (this.skin) {
    case CYAN1:
      image(cyanInvader1, this.position.x, this.position.y, CELL_SIZE - 5, CELL_SIZE);
      break;
    case CYAN2:
      image(cyanInvader2, this.position.x, this.position.y, CELL_SIZE - 5, CELL_SIZE);
      break;
    case GREEN1:
      image(greenInvader1, this.position.x, this.position.y, CELL_SIZE - 5, CELL_SIZE);
      break;
    case GREEN2:
      image(greenInvader2, this.position.x, this.position.y, CELL_SIZE - 5, CELL_SIZE);
      break;
    case RED1:
      image(redInvader1, this.position.x, this.position.y, CELL_SIZE - 5, CELL_SIZE);
      break;
    case RED2:
      image(redInvader2, this.position.x, this.position.y, CELL_SIZE - 5, CELL_SIZE);
      break;
    case YELLOW1:
      image(yellowInvader1, this.position.x, this.position.y, CELL_SIZE - 5, CELL_SIZE);
      break;
    case YELLOW2:
      image(yellowInvader2, this.position.x, this.position.y, CELL_SIZE - 5, CELL_SIZE);
      break;

    default:
      image(yellowInvader2, this.position.x, this.position.y, CELL_SIZE - 5, CELL_SIZE);
      break;
    }
  }

  void shoot(ArrayList<Projectile> listProjectiles) {
    int direction = 1; // Invaders shoot downwards
    int projectileSize = 40;
    Projectile projectile = new Projectile(this.position.copy(), this.cellX, this.cellY, direction, PROJECTILE_SPEED, projectileSize, projectileImg);
    listProjectiles.add(projectile);
  }
}
