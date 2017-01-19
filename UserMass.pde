class UserMass{
  public PVector pos;
  public boolean isHid = false;
  PImage userMassImage = loadImage("./img/userMassImageSample.png");
  int mass;
  float userMassImageAlpha = 0;
  float imageSize = 80;
  float amaount = 0;
  boolean isDeleted = false;
  UserMass(int _x, int _y, int _mass){
    pos = new PVector(_x, _y);
    mass = _mass;
  }
  void update(){
    if(!isDeleted && userMassImageAlpha < 255){
      userMassImageAlpha += dt;
    }
    if(isDeleted && 0 < userMassImageAlpha){
      userMassImageAlpha -= dt;
      if(userMassImageAlpha <= 0){
        isHid = true;
      }
    }
    if(sqrt(pow(mouseX-pos.x, 2)+pow(mouseY-pos.y, 2)) < 40){
      imageSize += (100-imageSize) * 0.01 * dt;
    }
    else{
      imageSize += (80-imageSize) * 0.01 * dt;
    }
    
    imageMode(CENTER);
    tint(255, 255, 255, userMassImageAlpha);
    image(userMassImage, pos.x, pos.y, imageSize, imageSize);
  }
  void hide(){
    isDeleted = true;
  }
}