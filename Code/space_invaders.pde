import processing.sound.*;
import ddf.minim.*;



SoundFile laserShotSound;
SoundFile explosionSound;
SoundFile goatScreamSound;
SoundFile mainMenuMusic;

boolean isMuted = false;
// Player for the game music so we can handle pause and resume
Minim minim;
AudioPlayer gameMusic;

Game game;
Menu menu;

// Spaceship Image
PImage spaceshipImg;

// Invaders Images
PImage cyanInvader1;
PImage cyanInvader2;
PImage redInvader1;
PImage redInvader2;
PImage yellowInvader1;
PImage yellowInvader2;
PImage greenInvader1;
PImage greenInvader2;

// Explosions
PImage[] explosionImages = new PImage[6];

// Laser Shots
// Cyan
PImage cyanShot;
// Red
PImage redShot;
// Yellow
PImage yellowShot;
// Green
PImage greenShot;
// Blue
PImage blueShot;

// Heart Filled Images
PImage heartFilled;
// Heart Empty Images
PImage heartEmpty;

// Mute and unmute images
PImage muteLogo;
PImage unmuteLogo;


// PGraphcis background
PGraphics spaceBackground;

ArrayList<Star> stars;



boolean keyIsHeld;
GameStatus gameStatus = GameStatus.STANDBY;

void setup() {
  size(920, 880, P2D);
  // Start a new Game
  game = new Game();

  // Generate a new Menu
  menu = new Menu();



  // Sounds
  // Game music
  minim = new Minim(this);
  gameMusic = minim.loadFile("sounds/gameMusic.mp3");
  mainMenuMusic = new SoundFile(this, "sounds/mainMenuMusic.mp3");

  mainMenuMusic.loop();


  // Invader down sound
  laserShotSound = new SoundFile(this, "sounds/laserShot.wav");

  //Explosion sound
  explosionSound = new SoundFile(this, "sounds/explosion.mp3");

  //Goat screaming
  goatScreamSound = new SoundFile(this, "sounds/screamingGoatMainMenu.mp3");
  // Assigning each PImage its image
  // Invaders
  cyanInvader1 = loadImage("data/invaders/cyan1.png");
  cyanInvader2 = loadImage("data/invaders/cyan2.png");
  greenInvader1 = loadImage("data/invaders/green1.png");
  greenInvader2 = loadImage("data/invaders/green2.png");
  redInvader1 = loadImage("data/invaders/red1.png");
  redInvader2 = loadImage("data/invaders/red2.png");
  yellowInvader1 = loadImage("data/invaders/yellow1.png");
  yellowInvader2 = loadImage("data/invaders/yellow2.png");

  // Spaceship
  spaceshipImg = loadImage("data/spaceship/spaceship1.png");

  // Hearts
  heartFilled = loadImage("data/heart/heartFilled.png");
  heartEmpty = loadImage("data/heart/heartEmpty.png");

  // Laser shots
  // Spaceship has a blue laser shot
  blueShot = loadImage("data/laserShots/laserShotSpaceship.png");

  // Red Shot

  redShot = loadImage("data/laserShots/laserShotRedInvader.png");

  // Yellow Shot
  yellowShot = loadImage("data/laserShots/laserShotYellowInvader.png");

  // Green Shot
  greenShot = loadImage("data/laserShots/laserShotGreenInvader.png");

  // Cyan Shot
  cyanShot = loadImage("data/laserShots/laserShotCyanInvader.png");

  // Explosions Images
  for (int i = 0; i < explosionImages.length; i++) {
    explosionImages[i] = loadImage("explosions/explosion" + i + ".png"); // explosion0.png, explosion1.png, etc.
  }
  // Mute and Unmute options
  muteLogo = loadImage("data/soundOptions/mute.png");
  unmuteLogo = loadImage("data/soundOptions/unmute.png");

  // Create the PGraphcis background
  spaceBackground = createGraphics(width, height);
  // Initialize the stars and planets
  stars = new ArrayList<Star>();



  // Adding stars
  for (int i = 0; i < 500; i++) {
    stars.add(new Star());
  }
}

void draw() {
  imageMode(CORNER); // Because each time draw() calls game.drawIt() the image mode is set to CENTER Mode due to spaceship and invader drawIt()

  updateSpaceBackground(); // Update the PGraphics content every frame
  image(spaceBackground, 0, 0); // Draw the updated PGraphics at (0, 0) on the main canvas
   if (isMuted) {
      mainMenuMusic.amp(0);  // Mute the music by setting the amplitude to 0
      gameMusic.setGain(-80);
    } else {
      mainMenuMusic.amp(1);  // Restore the volume to the original level
      gameMusic.setGain(0);
    }
  if (game != null) {
    // Display the actual game
    if (gameStatus == GameStatus.RUNNING) {
      game.update();
    }

    if (gameStatus != GameStatus.STANDBY) {
      game.drawIt();
    }
  }
  //Menu should be drawn at all times
  menu.drawIt();
}

void updateSpaceBackground() {
  spaceBackground.beginDraw();
  spaceBackground.background(0); // New navy blue background

  // Update and draw the pre-generated animated stars
  for (Star star : stars) {
    star.update();
    star.drawIt(spaceBackground);
  }

  spaceBackground.endDraw(); // Finish drawing on the PGraphics
}

void keyPressed() {
  if (game != null) {
    game.handleKey(keyCode, true);
  }
}


void keyReleased() {
  if (game != null) {
    game.handleKey(keyCode, false);
  }
}

void mousePressed() {
  menu.update();
}
