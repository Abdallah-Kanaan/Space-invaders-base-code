// An enum is a special "class" that represents a group of constants.
enum TypeCell
{
  EMPTY,
    SPACESHIP,
    INVADER,
    OBSTACLE,
    PROJECTILE
}
enum GameStatus {
  RUNNING, // When the game is running
    PAUSED, // When the game is paused
    GAMEOVER, // When the game is over
    STANDBY, // When the game isn't started and it is on standby
}
enum MenuLevel {
  STARTMENU,
    PAUSEMENU,
    STATSMENU,
    LOADMENU,
    SAVEMENU,
    GAMEOVERMENU
}

enum Status {
  DEAD,
    ALIVE
}
enum Skin {
  CYAN1, CYAN2,
    GREEN1, GREEN2,
    RED1, RED2,
    YELLOW1, YELLOW2,
    SPACESHIP;

  // Get the next skin in the cycle
  Skin nextSkin() {
    switch (this) {
    case CYAN1:
      return CYAN2;
    case CYAN2:
      return CYAN1;
    case GREEN1:
      return GREEN2;
    case GREEN2:
      return GREEN1;
    case RED1:
      return RED2;
    case RED2:
      return RED1;
    case YELLOW1:
      return YELLOW2;
    case YELLOW2:
      return YELLOW1;
    default:
      return this; // SPACESHIP doesn't cycle
    }
  }
}
// Number of lifes.
final int START_LIFES = 3;
// Score for a kill.
final int SCORE_KILL = 10;
// Size of a cell
final int CELL_SIZE = 40;
// Speed of the spceship movement in pixel per second
final int SPACESHIP_SPEED = 5;
// Speed of the projectile
final int PROJECTILE_SPEED = 5;
