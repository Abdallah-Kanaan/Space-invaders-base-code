class Game {
  // Initialize the classes necessary for the game to function
  Board board;
  Spaceship spaceship;
  ArrayList<Invader> listInvaders = new ArrayList<>();
  ArrayList<Projectile> listProjectiles = new ArrayList<>();
  ArrayList<Obstacle> listObstacles = new ArrayList<>();
  ArrayList<Explosion> explosions = new ArrayList<>();

  int currentLevel = 1;
  int score = 0;
  int lives = START_LIFES;

  // The game will handle Invaders movement pattern
  int invDirection = 1; // 1 = right, -1 = left
  int moveDelay = max(1200 - (currentLevel * 300), 200); // Time in milliseconds between invader movements
  int lastMoveTime = 0; // Tracks the last time invaders moved

  // The game will handle Invaders shooting pattern
  int shootIntervalInvader = max(2000 - (currentLevel * 200), 300);
  int lastShootTimeInvader = 0; // Tracks the last time an invader shot

  // The game will handle Spaceship shooting cooldown
  int shootIntervalSpaceship = 1000; // Time in milliseconds between shots
  int lastShootTimeSpaceship = 0; // Tracks the last time the spaceship shot
  boolean isShooting = false;

  Game() {
    this.newGame();
  }
  Game(int saveIdx) {
    this.loadSavedGame(saveIdx);
  }

  void update() {
    this.spaceship.update(this.board);

    int currentTime = millis();
    // Handle continuous shooting
    if (isShooting && currentTime - lastShootTimeSpaceship >= shootIntervalSpaceship) {
      spaceship.shoot(listProjectiles);
      lastShootTimeSpaceship = currentTime;
    }
    // Handle invader shooting
    if (currentTime - this.lastShootTimeInvader >= this.shootIntervalInvader && !this.listInvaders.isEmpty()) {
      this.lastShootTimeInvader = currentTime;
      Invader randomInv = this.listInvaders.get((int) random(this.listInvaders.size()));
      randomInv.shoot(this.listProjectiles);
    }

    // Handle invader movement
    if (currentTime - this.lastMoveTime >= this.moveDelay) {
      this.lastMoveTime = currentTime;

      boolean needsDirectionChange = false;
      for (Invader inv : this.listInvaders) {
        if (inv.cellX + this.invDirection < 0 || inv.cellX + this.invDirection >= this.board.nbCellsX) {
          needsDirectionChange = true;
          break;
        }
      }

      if (needsDirectionChange) {
        this.invDirection *= -1; // Reverse direction
        for (Invader inv : this.listInvaders) {
          inv.moveDown();
        }
      } else {
        for (Invader inv : this.listInvaders) {
          inv.move(this.invDirection);
        }
      }

      // Batch update all invaders on the board
      this.updateAllInvaders();
    }

    // Update projectiles
    for (Projectile proj : this.listProjectiles) {
      this.detectCollisions(proj);
      proj.update(this.board);
    }
    detectCollisionsBetweetnProjectiles();
    // Update explosions
    for (int i = this.explosions.size() - 1; i >= 0; i--) {
      Explosion explosion = this.explosions.get(i);
      explosion.update();
      explosion.drawIt();
      if (explosion.isFinished()) {
        this.explosions.remove(i); // Remove finished explosions
      }
    }

    if (this.isLevelCleared()) {
      this.nextLevel();
    }
  }

  void updateAllInvaders() {
    // Step 1: Clear all invader cells on the board
    for (int y = 0; y < this.board.nbCellsY; y++) {
      for (int x = 0; x < this.board.nbCellsX; x++) {
        if (this.board.cells[y][x] == TypeCell.INVADER) {
          this.board.cells[y][x] = TypeCell.EMPTY;
        }
      }
    }

    // Step 2: Mark new positions for all invaders on the board
    for (Invader inv : this.listInvaders) {
      int newCellX = (int) (inv.position.x / CELL_SIZE);
      int newCellY = (int) (inv.position.y / CELL_SIZE);

      // Update the invader's grid position
      inv.cellX = newCellX;
      inv.cellY = newCellY;

      // Mark the cell as occupied by an invader
      if (newCellY >= 0 && newCellY < this.board.nbCellsY && newCellX >= 0 && newCellX < this.board.nbCellsX) {
        this.board.cells[newCellY][newCellX] = TypeCell.INVADER;
      }
    }
  }
  void detectCollisionsBetweetnProjectiles() {
    // Update projectiles and check for  collisions between projectiles
    for (int i = 0; i < listProjectiles.size(); i++) {
      Projectile projectile = listProjectiles.get(i);

      if (projectile.isActive) {
        // Check for collision with other projectiles
        for (int j = i + 1; j < listProjectiles.size(); j++) { // Start from i+1 to avoid checking the same pair twice
          Projectile otherProjectile = listProjectiles.get(j);

          if (otherProjectile.isActive) {
            // Collision detection using distance
            if (dist(projectile.position.x, projectile.position.y, otherProjectile.position.x, otherProjectile.position.y) < (projectile.size + otherProjectile.size) / 2) {
              // Handle collision between projectiles
              projectile.isActive = false; // Deactivate the first projectile
              otherProjectile.isActive = false; // Deactivate the second projectile

              // Create explosion at the midpoint of both projectiles
              PVector explosionPosition = new PVector(
                (projectile.position.x + otherProjectile.position.x) / 2,
                (projectile.position.y + otherProjectile.position.y) / 2
                );
              this.explosions.add(new Explosion(explosionPosition, 100));  // Explosion effect
              explosionSound.play();  // Play explosion sound
            }
          }
        }
      }
    }
  }
  void detectCollisions(Projectile projectile) {
    if (projectile.isActive) {
      detectCollisionsBottomScreen(projectile);
      detectCollisionsSpaceship(projectile);
      detectCollisionsInvaders(projectile);
      detectCollisionsObstacles(projectile);
    }
  }

  void detectCollisionsBottomScreen(Projectile projectile) {
    // Collision with the bottom of the screen
    if (dist(projectile.position.x, projectile.position.y, projectile.position.x, height) < (CELL_SIZE / 2)) {
      projectile.isActive = false;
      return;
    }
  }

  void detectCollisionsSpaceship(Projectile projectile) {
    // Collision with spaceship
    if (projectile.direction == 1) { // Invader's projectile moves down
      if (dist(projectile.position.x, projectile.position.y, this.spaceship.position.x, this.spaceship.position.y) < (projectile.size + this.spaceship.size) / 2) {
        println("Spaceship hit!");
        projectile.isActive = false; // Deactivate projectile
        this.lives--; // Decrease lives
        this.checkGameOver(); // Check if the game should end
        return;
      }
    }
  }

  void detectCollisionsInvaders(Projectile projectile) {
    // Detect collision with invaders
    for (int i = 0; i < this.listInvaders.size(); i++) {
      Invader inv = this.listInvaders.get(i);

      // Collision detection using distance
      if (dist(projectile.position.x, projectile.position.y, inv.position.x, inv.position.y) < (projectile.size + inv.size) / 2 &&
        projectile.direction == -1) {
        this.score += SCORE_KILL;
        projectile.isActive = false; // Deactivate projectile
        this.listInvaders.remove(i); // Remove the invader from the list

        PVector explosionPosition = new PVector(inv.position.x, inv.position.y);
        this.explosions.add(new Explosion(explosionPosition, 100)); // 100 ms per frame
        explosionSound.play(); // Play the explosion sound
        return; // Exit after detecting a collision
      }
    }
  }

  void detectCollisionsObstacles(Projectile projectile) {
    // Detect collision with obstacles
    for (int i = 0; i < this.listObstacles.size(); i++) {
      Obstacle obs = this.listObstacles.get(i);

      // Collision detection using distance
      if (dist(projectile.position.x, projectile.position.y, obs.position.x, obs.position.y) < (projectile.size + CELL_SIZE) / 2) {
        projectile.isActive = false; // Deactivate projectile
        obs.update(this.board);
        if (obs.status == Status.DEAD) {
          this.listObstacles.remove(i);
        }
        return; // Exit after detecting a collision
      }
    }
  }

  void updateGameStatus(GameStatus newStatus) {
    if (newStatus == GameStatus.RUNNING) {
      // Transitioning to the game
      if (mainMenuMusic.isPlaying()) {
        mainMenuMusic.stop(); // Stop main menu music
      }

      if (gameStatus == GameStatus.PAUSED) {
        // Resume game music from paused position
        if (!gameMusic.isPlaying()) {
          gameMusic.play();
        }
      } else if (gameStatus == GameStatus.STANDBY) {
        // Start game music fresh (rewind)
        gameMusic.rewind();
        gameMusic.play();
      }
    } else if (newStatus == GameStatus.STANDBY) {
      // Transitioning to the main menu
      if (gameMusic.isPlaying()) {
        gameMusic.pause(); // Pause game music to allow resume later
      }
      mainMenuMusic.loop(); // Start looping main menu music from the beginning
    } else if (newStatus == GameStatus.PAUSED) {
      // Pausing the game
      if (gameMusic.isPlaying()) {
        gameMusic.pause(); // Pause game music and retain position
      }
    }

    // Update the game status
    gameStatus = newStatus;
  }


  void drawIt() {
    // this.board.drawIt();
    this.spaceship.drawIt();
    for (Invader inv : this.listInvaders) {
      inv.drawIt();
    }
    for (Projectile proj : this.listProjectiles) {
      proj.drawIt();
    }
    for (Obstacle obs : this.listObstacles) {
      obs.drawIt();
    }
    this.displayScore();
    this.displayLives();
  }

  void displayScore() {
    fill(255); // White color
    textAlign(CENTER, TOP);
    textSize(24);
    text("Score: " + this.score, width / 2, 10); // Score at top middle
  }

  void displayLives() {
    float heartSize = 30; // Size of each heart
    float spacing = 10;   // Spacing between hearts
    float startX = 10;    // Horizontal position for the label and hearts
    float startY = 10;    // Top position for the row

    // Display the "Lives" label
    textAlign(LEFT, CENTER);       // Align text to the left and center vertically
    textSize(24);                  // Set font size for the label
    fill(255);                     // Set text color to white
    float labelY = startY + heartSize / 2; // Vertically center the label with the hearts
    text("Lives:", startX, labelY); // Draw label at the correct vertical position

    // Adjust the startX for the hearts to appear after the label
    startX += textWidth("Lives: ") + 2 * spacing;

    // Display the hearts
    float heartYOffset = CELL_SIZE / 2 - 5; // Adjust hearts downward slightly
    for (int i = 0; i < START_LIFES; i++) {
      if (i < this.lives) {
        image(heartFilled, startX + i * (heartSize + spacing), startY + heartYOffset, heartSize, heartSize);
      } else {
        image(heartEmpty, startX + i * (heartSize + spacing), startY + heartYOffset, heartSize, heartSize);
      }
    }
  }

  void newGame() {
    this.score = 0;  // Reset score
    this.lives = START_LIFES; // Reset Lives
    this.listInvaders.clear();    // Clear invaders
    this.listObstacles.clear();   // Clear obstacles
    this.listProjectiles.clear(); // Clear projectiles
    String[] levelInfo = loadStrings("levels/level1.txt");

    // Initialize board
    PVector boardPosition = new PVector(0, 0);
    this.board = new Board(boardPosition, width / CELL_SIZE, height / CELL_SIZE, levelInfo);

    // Initialize spaceship and obstacles
    for (int y = 0; y < levelInfo.length; y++) {
      for (int x = 0; x < levelInfo[y].length(); x++) {
        PVector pos = new PVector(boardPosition.x + x * CELL_SIZE + CELL_SIZE / 2,
          boardPosition.y + y * CELL_SIZE + CELL_SIZE / 2);

        switch (levelInfo[y].charAt(x)) {
        case 'S':
          this.spaceship = new Spaceship(pos, x, y, CELL_SIZE, blueShot);
          break;
        case 'I':
          Skin[] levelColors = this.getInvaderColorCombination(1);
          Skin skin = levelColors[y % levelColors.length];
          this.listInvaders.add(new Invader(pos, x, y, CELL_SIZE, skin));
          break;
        case 'X':
          Obstacle obstacle = new Obstacle(pos, x, y, 20);
          this.listObstacles.add(obstacle);
          break;
        }
      }
    }
  }

  void loadLevel(int level) {
    // Clear invaders for the new level
    level = level < 4 ? level : 4;
    this.listInvaders.clear();

    // Load level data
    String[] levelInfo = loadStrings("levels/level" + level + ".txt");

    // Add new invaders for the level
    PVector boardPosition = new PVector(0, 0);
    for (int y = 0; y < levelInfo.length; y++) {
      for (int x = 0; x < levelInfo[y].length(); x++) {
        float posX = boardPosition.x + x * CELL_SIZE + CELL_SIZE / 2;
        float posY = boardPosition.y + y * CELL_SIZE + CELL_SIZE / 2;
        PVector pos = new PVector(posX, posY);

        switch (levelInfo[y].charAt(x)) {
        case 'I': // Add invaders
          Skin[] levelColors = this.getInvaderColorCombination(level);
          Skin skin = levelColors[y % levelColors.length]; // Cycle through level colors
          this.listInvaders.add(new Invader(pos, x, y, CELL_SIZE, skin));
          break;
        default:
          break; // Do nothing for other cases
        }
      }
    }
  }

  void nextLevel() {
    this.currentLevel++;      // Increment the level
    this.loadLevel(this.currentLevel); // Load the next level
    println("Level " + this.currentLevel + " started!");
  }

  boolean isLevelCleared() {
    return this.listInvaders.isEmpty(); // Level is cleared when no invaders remain
  }


  void checkGameOver() {
    if (this.lives <= 0) {
      this.listInvaders.clear(); // Clear the invaders list
      this.updateGameStatus(GameStatus.GAMEOVER); // End the game if no lives remain
      println("Game Over!");
    }
  }

  void disposeGame() {
    if (this.listProjectiles != null) this.listProjectiles.clear();  // Clear projectiles
    if (this.listInvaders != null) this.listInvaders.clear();        // Clear invaders
    if (this.listObstacles != null) this.listObstacles.clear();      // Clear obstacles
    this.board = null;                                               // Remove board reference
    this.spaceship = null;                                           // Remove spaceship reference
    println("Game disposed.");
  }

  void saveGame(int saveIdx) {

    // Get the board layout as a string array
    String[] boardLayout = this.board.getBoardLayout();

    // Save the game info (score, lives, level) as strings
    String[] gameInfo = {
      "score=" + score,
      "lives=" + lives,
      "currentLevel=" + currentLevel
    };

    // Save game data to the file using Processing's saveStrings
    saveStrings("saves/save" + saveIdx + "/gameInfo.txt", gameInfo);

    // Save the board layout to the file using Processing's saveStrings
    saveStrings("saves/save" + saveIdx + "/boardInfo.txt", boardLayout);

    println("Game saved in saves/save" + saveIdx);
  }


  void loadSavedGame(int saveIdx) {
    String saveDir = "saves/save" + saveIdx;

    // Load the game info
    String[] gameInfo = loadStrings(saveDir + "/gameInfo.txt");
    if (gameInfo != null) {
      for (String line : gameInfo) {
        // Split the line into key and value based on '=' delimiter
        String[] parts = line.split("=");

        if (parts.length == 2) {  // Ensure the split result has two parts
          String key = parts[0];  // Key before '='
          String value = parts[1];  // Value after '='

          // Assign values based on key
          if (key.equals("score")) {
            score = Integer.parseInt(value);  // Convert to integer
          } else if (key.equals("lives")) {
            lives = Integer.parseInt(value);  // Convert to integer
          } else if (key.equals("currentLevel")) {
            currentLevel = Integer.parseInt(value);  // Convert to integer
          }
        }
      }
    }

    // Load the board layout
    String[] boardInfo = loadStrings(saveDir + "/boardInfo.txt");
    if (boardInfo != null) {
      this.listInvaders.clear();    // Clear invaders
      this.listObstacles.clear();   // Clear obstacles
      this.listProjectiles.clear(); // Clear projectiles


      // Initialize board
      PVector boardPosition = new PVector(0, 0);
      this.board = new Board(boardPosition, width / CELL_SIZE, height / CELL_SIZE, boardInfo);

      // Initialize spaceship and obstacles
      for (int y = 0; y < boardInfo.length; y++) {
        for (int x = 0; x < boardInfo[y].length(); x++) {
          PVector pos = new PVector(boardPosition.x + x * CELL_SIZE + CELL_SIZE / 2,
            boardPosition.y + y * CELL_SIZE + CELL_SIZE / 2);

          switch (boardInfo[y].charAt(x)) {
          case 'S':
            this.spaceship = new Spaceship(pos, x, y, CELL_SIZE, blueShot);
            break;
          case 'I':
            Skin[] levelColors = this.getInvaderColorCombination(1);
            Skin skin = levelColors[y % levelColors.length];
            this.listInvaders.add(new Invader(pos, x, y, CELL_SIZE, skin));
            break;
          case 'X':
            Obstacle obstacle = new Obstacle(pos, x, y, 20);
            this.listObstacles.add(obstacle);
            break;
          }
        }
      }

      // Now you have the loaded board and game info
      println("Game loaded from " + saveDir);
    }
  }


  void playGame() {
    this.updateGameStatus(GameStatus.RUNNING);
  }

  void pauseGame() {
    this.updateGameStatus(GameStatus.PAUSED);
  }

  void restartGame() {
    this.disposeGame();       // Clean up the current game state
    this.currentLevel = 1;    // Reset to the first level
    this.score = 0;           // Reset score
    this.lives = START_LIFES; // Reset lives
    this.newGame();           // Start a new game
    println("Game restarted!");
    this.updateGameStatus(GameStatus.RUNNING);
  }


  void handleKey(int k, boolean pressed) {
    if (gameStatus == GameStatus.RUNNING) {
      // if keyPressed and held is q or Q move the spaceship to the left
      if (key == 'q' || key == 'Q' || k == LEFT) {
        this.spaceship.isMoving = pressed ? -1 : 0;
      }

      // if keyPressed and held is d or D move the spaceship to the right
      if (k == 'd' || k == 'D' || k == RIGHT) {
        this.spaceship.isMoving = pressed ? 1 : 0;
      }
      // Handle shooting when spacebar is pressed
      if (k == ' ' && pressed) {
        // Start shooting when spacebar is pressed
        isShooting = true;
      } else if (k == ' ' && !pressed) {
        // Stop shooting when spacebar is released
        isShooting = false;
      }

      // if Escape button is pressed we toggle the game status between 1 and 2
      if (key == 112) {
        if (gameStatus == GameStatus.RUNNING && pressed) {
          this.pauseGame();
        } else if (gameStatus == GameStatus.PAUSED && pressed) {
          this.playGame();
        }
      }
    }
  }


  Skin[] getInvaderColorCombination(int level) {
    // Define color combinations
    switch (level % 4) { // Cycle through combinations
    case 1:
      return new Skin[]{Skin.CYAN1, Skin.GREEN1, Skin.RED1, Skin.YELLOW1}; // First combination
    case 2:
      return new Skin[]{Skin.RED2, Skin.GREEN2, Skin.YELLOW1, Skin.CYAN1};  // Second combination
    default:
      return new Skin[]{Skin.GREEN1, Skin.CYAN2, Skin.YELLOW2, Skin.RED1}; // Default combination
    }
  }
}
