class Menu {
  int buttonWidth;   // Button width (in pixels)
  int buttonHeight;  // Button height (in pixels)
  MenuLevel menuLevel;  // Tracks the current menu level (Start or Stats)

  // Constructor to initialize button sizes and set the default menu level
  Menu() {
    this.buttonWidth = CELL_SIZE * 9;   // Button width proportional to CELL_SIZE
    this.buttonHeight = CELL_SIZE * 2;  // Button height proportional to CELL_SIZE
    this.menuLevel = MenuLevel.STARTMENU;  // Default menu level is the start menu
  }

  void update() {
    // If the game is over update the menu level to gameovermenu
    if (gameStatus == GameStatus.GAMEOVER) {
      menuLevel = MenuLevel.GAMEOVERMENU;
    }
    // Mute and Unmute button should be handled at all times
    handleMuteUnmuteButton();
    // Handle updates based on game status and current menu level
    if (gameStatus == GameStatus.STANDBY) {
      if (this.menuLevel == MenuLevel.STARTMENU) {
        // Start Menu: handle Start, Stats, Load and Exit buttons
        handleStartMenu();
      } else if (this.menuLevel == MenuLevel.STATSMENU) {
        // Stats Menu: handle Back button
        this.handleStatsMenu();
      } else if (this.menuLevel == MenuLevel.LOADMENU) {
        // Load Menu: handle Back and the save level buttons
        this.handleLoadMenu();
      }
    } else if (gameStatus == GameStatus.PAUSED) {
      if (menuLevel == MenuLevel.SAVEMENU) {
        this.handleSaveMenu();
      } else {
        // Paused: handle Resume Load, Restart and Main Menu buttons
        this.handlePausedMenu();
      }
    } else if (gameStatus == GameStatus.GAMEOVER) {
      // Game Over: handle Restart and Main Menu buttons
      this.handleGameOverMenu();
    }
  }

  // Check if the mouse is hovering over a given button
  boolean buttonHovering(float buttonX, float buttonY, int buttonWidth, int buttonHeight) {
    return mouseX > buttonX && mouseX < buttonX + buttonWidth &&
      mouseY > buttonY && mouseY < buttonY + buttonHeight;
  }

  // Handle Start Menu button actions (Start, Load, Stats, Exit)
  void handleStartMenu() {
    handleStartButton();
    handleLoadButton();
    handleStatsButton();
    handleExitButton();
  }

  // Handle Stats Menu button actions (Back)
  void handleStatsMenu() {
    handleBackButton();
  }

  // Handle Load Menu button actions (Save 1, Save 2, Save 3, Save 4, Save5, Back)
  void handleLoadMenu() {
    if (this.buttonHovering(7 * CELL_SIZE, 6 * CELL_SIZE, this.buttonWidth, this.buttonHeight)) {
      game = new Game(1);
      game.updateGameStatus(GameStatus.RUNNING);
      println("Loaded game saved 1");
    } else if (this.buttonHovering(7 * CELL_SIZE, 8.5 * CELL_SIZE, this.buttonWidth, this.buttonHeight)) {
      game = new Game(3);
      game.updateGameStatus(GameStatus.RUNNING);
      println("Loaded game saved 2");
    } else if (this.buttonHovering(7 * CELL_SIZE, 11 * CELL_SIZE, this.buttonWidth, this.buttonHeight)) {
      game = new Game(3);
      game.updateGameStatus(GameStatus.RUNNING);
      println("Loaded game saved 3");
    } else if (this.buttonHovering(7 * CELL_SIZE, 13.5 * CELL_SIZE, this.buttonWidth, this.buttonHeight)) {
      game = new Game(4);
      game.updateGameStatus(GameStatus.RUNNING);
      println("Loaded game saved 4");
    } else if (this.buttonHovering(7 * CELL_SIZE, 16 * CELL_SIZE, this.buttonWidth, this.buttonHeight)) {
      game = new Game(5);
      game.updateGameStatus(GameStatus.RUNNING);
      println("Loaded game saved 5");
    }
    handleBackButton();
  }
  // Handle Save Menu button actions (Save 1, Save 2, Save 3, Save 4, Save5, Back)
  void handleSaveMenu() {
    if (this.buttonHovering(7 * CELL_SIZE, 6 * CELL_SIZE, this.buttonWidth, this.buttonHeight)) {
      game.saveGame(1);
    } else if (this.buttonHovering(7 * CELL_SIZE, 8.5 * CELL_SIZE, this.buttonWidth, this.buttonHeight)) {
      game.saveGame(2);
    } else if (this.buttonHovering(7 * CELL_SIZE, 11 * CELL_SIZE, this.buttonWidth, this.buttonHeight)) {
      game.saveGame(3);
    } else if (this.buttonHovering(7 * CELL_SIZE, 13.5 * CELL_SIZE, this.buttonWidth, this.buttonHeight)) {
      game.saveGame(4);
    } else if (this.buttonHovering(7 * CELL_SIZE, 16 * CELL_SIZE, this.buttonWidth, this.buttonHeight)) {
      game.saveGame(5);
    }
    handleBackButton();
  }
  // Handle actions when the game is paused (Resume, Restart, Save,   Main Menu)
  void handlePausedMenu() {
    handleResumeButton();
    handleRestartButton();
    handleSaveButton();
    handleMainMenubutton();
  }

  // Handle actions when the game is over (Restart, Main Menu)
  void handleGameOverMenu() {
    handleRestartButton();
    handleMainMenubutton();
  }
  void handleStartButton() {
    float startX = 7 * CELL_SIZE;
    float startY = 9 * CELL_SIZE;
    if (this.buttonHovering(startX, startY, this.buttonWidth, this.buttonHeight)) {
      game = new Game();
      game.updateGameStatus(GameStatus.RUNNING);  // Start the game
    }
  }
  void handleLoadButton() {
    float loadX = 7 * CELL_SIZE;
    float loadY = 11.5 * CELL_SIZE;
    if (this.buttonHovering(loadX, loadY, this.buttonWidth, this.buttonHeight)) {
      this.menuLevel = MenuLevel.LOADMENU;  // Switch to Load menu
    }
  }

  void handleStatsButton() {
    float statsX = 7 * CELL_SIZE;
    float statsY = 14 * CELL_SIZE;
    if (this.buttonHovering(statsX, statsY, this.buttonWidth, this.buttonHeight)) {
      this.menuLevel = MenuLevel.STATSMENU;  // Switch to Stats menu
    }
  }
  void handleExitButton() {
    float exitX = 7 * CELL_SIZE;
    float exitY = 16.5 * CELL_SIZE;
    if (this.buttonHovering(exitX, exitY, this.buttonWidth, this.buttonHeight)) {
      exit();  // Exit the game
    }
  }
  void handleBackButton() {
    float backX = 1 * CELL_SIZE;
    float backY = 19 * CELL_SIZE;
    if (this.buttonHovering(backX, backY, this.buttonWidth / 3, this.buttonHeight) && gameStatus == GameStatus.STANDBY) {
      this.menuLevel = MenuLevel.STARTMENU;  // Go back to Start menu
    } else if (this.buttonHovering(backX, backY, this.buttonWidth / 3, this.buttonHeight) && menuLevel == MenuLevel.SAVEMENU) {
      this.menuLevel = MenuLevel.PAUSEMENU;  // Go back to Start menu
    }
  }

  void handleResumeButton() {
    float resumeX = 7 * CELL_SIZE;
    float resumeY = 9 * CELL_SIZE;
    if (this.buttonHovering(resumeX, resumeY, this.buttonWidth, this.buttonHeight)) {
      game.updateGameStatus(GameStatus.RUNNING);  // Resume the game
    }
  }
  void handleRestartButton() {
    float restartX = 7 * CELL_SIZE;
    float restartY = gameStatus == GameStatus.GAMEOVER ? 9 * CELL_SIZE : 11.5 * CELL_SIZE;
    if (this.buttonHovering(restartX, restartY, this.buttonWidth, this.buttonHeight)) {
      game.restartGame();  // Restart the game
      game.updateGameStatus(GameStatus.RUNNING);  // Set the game to running
    }
  }

  void handleSaveButton () {
    float saveX = 7 * CELL_SIZE;
    float saveY = 14 * CELL_SIZE;
    if (this.buttonHovering(saveX, saveY, this.buttonWidth, this.buttonHeight)) {
      menuLevel = MenuLevel.SAVEMENU;
    }
  }

  void handleMainMenubutton() {
    float mainMenuX = 7 * CELL_SIZE;
    float mainMenuY = gameStatus == GameStatus.GAMEOVER ? 11.5 * CELL_SIZE : 16.5 * CELL_SIZE;
    if (this.buttonHovering(mainMenuX, mainMenuY, this.buttonWidth, this.buttonHeight)) {
      if (!isMuted) {
        goatScreamSound.play();
      }
      game.disposeGame();  // Dispose the game and return to Standby
      game.updateGameStatus(GameStatus.STANDBY);
      menuLevel = MenuLevel.STARTMENU;
    }
  }
  void handleMuteUnmuteButton() {
    float muteUnmuteX = 22 * CELL_SIZE;
    float muteUnmuteY = 0 * CELL_SIZE;
    if (this.buttonHovering(muteUnmuteX, muteUnmuteY, this.buttonWidth, this.buttonHeight)) {
      isMuted = isMuted? false : true;
    }
  }
  void drawIt() {
    // Mute Unmute button should be displayed at all times
    displayMuteUnmuteButton();
    // Draw the appropriate menu screen based on game status
    if (gameStatus == GameStatus.STANDBY) {
      if (this.menuLevel == MenuLevel.STARTMENU) {
        // Draw Start menu
        this.displayStartMenu();
      } else if (this.menuLevel == MenuLevel.STATSMENU) {
        // Draw Stats menu
        this.displayBackButton();
      } else if (this.menuLevel == MenuLevel.LOADMENU) {
        this.displaySaveLoadMenu();
      }
    }
    if (gameStatus == GameStatus.PAUSED) {
      if (menuLevel == MenuLevel.SAVEMENU) {
        this.displaySaveLoadMenu();
      } else {
        // Draw Pause menu
        this.displayPauseMenu();
      }
    }
    if (gameStatus == GameStatus.GAMEOVER) {
      // Draw Game Over menu
      this.displayGameOverMenu();
    }
  }

  // Display the game title at the top of the screen
  void displayGameTitle() {
    float titleX = width / 2;  // Center horizontally
    float titleY = 3 * CELL_SIZE;  // Positioned above the buttons
    fill(0, 255, 0);
    textAlign(CENTER, CENTER);
    textSize(150);
    text("SPACE ALIEN", titleX, titleY);  // Title of the game
    fill(255, 0, 0);
    text("INVADERS", titleX, titleY * 2);  // Subtitle
  }

  // Display different buttons on the Start Menu
  void displayStartButton() {
    float buttonX = 7 * CELL_SIZE;
    float buttonY = 9 * CELL_SIZE;
    this.displayButton("Start", buttonX, buttonY, this.buttonWidth, this.buttonHeight);
  }

  void displayLoadButton() {
    float buttonX = 7 * CELL_SIZE;
    float buttonY = 11.5 * CELL_SIZE;
    this.displayButton("Load", buttonX, buttonY, this.buttonWidth, this.buttonHeight);
  }

  void displayStatsButton() {
    float buttonX = 7 * CELL_SIZE;
    float buttonY = 14 * CELL_SIZE;
    this.displayButton("Stats", buttonX, buttonY, this.buttonWidth, this.buttonHeight);
  }

  void displayExitButton() {
    float buttonX = 7 * CELL_SIZE;
    float buttonY = 16.5 * CELL_SIZE;
    this.displayButton("Exit", buttonX, buttonY, this.buttonWidth, this.buttonHeight);
  }

  // Display the Back button in the Stats menu
  void displayBackButton() {
    float buttonX = 1 * CELL_SIZE;
    float buttonY = 19 * CELL_SIZE;
    this.displayButton("Back", buttonX, buttonY, this.buttonWidth / 3, this.buttonHeight);
  }

  // Display buttons for the Pause and Game Over menus
  void displayResumeButton() {
    float buttonX = 7 * CELL_SIZE;
    float buttonY = 9 * CELL_SIZE;
    this.displayButton("Resume", buttonX, buttonY, this.buttonWidth, this.buttonHeight);
  }
  void displaySaveButton() {
    float buttonX = 7 * CELL_SIZE;
    float buttonY = 14 * CELL_SIZE;
    this.displayButton("Save", buttonX, buttonY, this.buttonWidth, this.buttonHeight);
  }
  void displayBackToMainMenuButton() {
    float buttonX = 7 * CELL_SIZE;
    float buttonY = gameStatus == GameStatus.GAMEOVER ? 11.5 * CELL_SIZE : 16.5 * CELL_SIZE;
    this.displayButton("Main Menu", buttonX, buttonY, this.buttonWidth, this.buttonHeight);
  }

  void displayRestartButton() {
    float buttonX = 7 * CELL_SIZE;
    float buttonY = gameStatus == GameStatus.GAMEOVER ? 9 * CELL_SIZE : 11.5 * CELL_SIZE;
    this.displayButton("Restart", buttonX, buttonY, this.buttonWidth, this.buttonHeight);
  }
  // Draw the Start Menu
  void displayStartMenu() {
    this.displayGameTitle();
    this.displayStartButton();
    this.displayStatsButton();
    this.displayLoadButton();
    this.displayExitButton();
  }
  // Draw the Pause menu (with blurred background)
  void displayPauseMenu() {
    this.blurBackground();
    this.displayResumeButton();
    this.displayRestartButton();
    this.displaySaveButton();
    this.displayBackToMainMenuButton();
  }

  // Draw the Save Load menu
  void displaySaveLoadMenu() {
    blurBackground();
    this.displayButton("Save 1", 7 * CELL_SIZE, 6 * CELL_SIZE, this.buttonWidth, this.buttonHeight);
    this.displayButton("Save 2", 7 * CELL_SIZE, 8.5 * CELL_SIZE, this.buttonWidth, this.buttonHeight);
    this.displayButton("Save 3", 7 * CELL_SIZE, 11 * CELL_SIZE, this.buttonWidth, this.buttonHeight);
    this.displayButton("Save 4", 7 * CELL_SIZE, 13.5 * CELL_SIZE, this.buttonWidth, this.buttonHeight);
    this.displayButton("Save 5", 7 * CELL_SIZE, 16 * CELL_SIZE, this.buttonWidth, this.buttonHeight);
    displayBackButton();
  }

  // Draw the Game Over menu (with blurred background)
  void displayGameOverMenu() {
    this.blurBackground();
    float titleX = width / 2;  // Centered horizontally
    float titleY = 6 * CELL_SIZE; // Position above the "Main Menu" button
    fill(255, 0, 0);  // Red color for Game Over text
    textAlign(CENTER, CENTER);  // Center alignment
    textSize(150);  // Large text size
    text("GAME OVER", titleX, titleY);
    this.displayRestartButton();
    this.displayBackToMainMenuButton();
  }
  void displayMuteUnmuteButton() {
    float buttonX = 22 * CELL_SIZE;
    float buttonY = 0 * CELL_SIZE;
    imageMode(CORNER);
    if (isMuted) {
      image(muteLogo, buttonX, buttonY, CELL_SIZE, CELL_SIZE);
    } else {
      image(unmuteLogo, buttonX, buttonY, CELL_SIZE, CELL_SIZE);
    }
  }
  // Apply a blur effect to the background (darkens it)
  void blurBackground() {
    fill(0, 0, 0, 220);  // Semi-transparent black overlay
    rect(0, 0, width, height);  // Full screen rectangle
  }

  // Generic function to display buttons with hover effect
  void displayButton(String label, float buttonX, float buttonY, int buttonWidth, int buttonHeight) {
    boolean isHovering = this.buttonHovering(buttonX, buttonY, buttonWidth, buttonHeight);

    // Change button color if hovering
    if (isHovering) {
      fill(100, 200, 100);  // Lighter green on hover
    } else {
      fill(50, 150, 50);  // Normal button color
    }

    // Draw the button
    stroke(255);
    strokeWeight(2);
    rect(buttonX, buttonY, buttonWidth, buttonHeight, 20);  // Rounded corners

    // Draw the button label
    fill(255);  // White text
    textAlign(CENTER, CENTER);
    textSize(24);
    text(label, buttonX + buttonWidth / 2, buttonY + buttonHeight / 2);  // Centered label
  }
}
