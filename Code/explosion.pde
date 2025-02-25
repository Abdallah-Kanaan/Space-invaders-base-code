class Explosion {
    PVector position;
    int currentFrame;
    int totalFrames;
    int frameDuration; // Time each frame is displayed in milliseconds
    int frameStartTime;

    Explosion(PVector position, int frameDuration) {
        this.position = position;
        this.currentFrame = 0;
        this.totalFrames = explosionImages.length;
        this.frameDuration = frameDuration;
        this.frameStartTime = millis();
    }

    void update() {
        // Advance to the next frame if enough time has passed
        if (millis() - this.frameStartTime > this.frameDuration) {
            this.frameStartTime = millis();
            this.currentFrame++;
        }
    }  

    void drawIt() {
        if (this.currentFrame < this.totalFrames) {
            imageMode(CENTER);
            image(explosionImages[this.currentFrame], this.position.x, this.position.y);
        }
    }

    boolean isFinished() {
        return this.currentFrame >= this.totalFrames;
    }
}
