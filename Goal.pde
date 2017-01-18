class Goal{
  PImage goalCircleImage = loadImage("./img/goalCircle.png");
  PImage targetTextImage = loadImage("./img/targetText.png");
  public PVector pos;
  public boolean isHide = false;
  float deg = 0;
  float goalAlpha = 0;
  Goal(int _x, int _y){
    pos = new PVector(_x, _y);
  }
  void update(){
    if(!isHide && goalAlpha < 255){
      goalAlpha += fadeInOut*dt;
    }
    if(isHide && 0 <= goalAlpha){
      goalAlpha -= fadeInOut*dt;
    }
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(radians(deg));
    deg += 0.05*dt;
    imageMode(CENTER);
    tint(255, 255, 255, goalAlpha);
    image(goalCircleImage, 0, 0);
    popMatrix();
    imageMode(CENTER);
    tint(255, 255, 255, goalAlpha);
    image(targetTextImage, pos.x, pos.y);
  }
}