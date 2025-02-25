class Star {
  float x, y; // Position of the star
  float size; // Size of the star
  float speed;

  Star(float x, float y, float size, float speed) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.speed = speed;
  }

  Star() {
    this.x = random(width);
    this.y = random(height);
    this.size = random(1, 3);
    this.speed = 0.8;
  }

  void update() {
    // Move the star downward
    this.y += this.speed;

    // Reset position when the star moves off the screen
    if (this.y > height) {
      this.y = 0;
      this.x = random(width);
    }
  }

  void drawIt(PGraphics pg) {
    pg.fill(255, random(150, 255)); // Add shimmer effect
    pg.noStroke();
    pg.ellipse(this.x, this.y, this.size, this.size);
  }
}
