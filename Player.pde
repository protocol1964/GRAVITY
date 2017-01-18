class Player{
  public PVector pos;
  public boolean isHide = false;
  PVector force;
  PImage playerImage = loadImage("./img/playerImage.png");
  public float playerAlpha = 0;
  float forceScale = 0.8;
  boolean isGoaled = false;
  
  Player(int _x, int _y){
    pos = new PVector(_x, _y);
    force = new PVector(0, 0);
  }
  void update(){
    if(!isHide && playerAlpha < 255){
      playerAlpha += fadeInOut*dt;
    }
    if(isHide && -255 <= playerAlpha){
      playerAlpha -= fadeInOut*dt;
    }
    if(isGoaled){
      force.mult(forceScale);
    }
    pos.add(force);
    imageMode(CENTER);
    tint(255, 255, 255, playerAlpha);
    image(playerImage, pos.x, pos.y);
  }
  void addGravity(int mass, PVector massPos){
    PVector dist = massPos.sub(pos);
    float abs = dist.mag();
    PVector add = dist.normalize().mult(mass*10*40).div(pow(abs, 2));
    force.add(add);
  }
  void goalEffect(){
    isGoaled = true;
  }
}