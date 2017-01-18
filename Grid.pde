class Grid{
  public int transitionMode = 0; //0:default, 1:increace, 2:decreace
  PImage gridImage;
  int x, y;
  float gridAlpha = 0;
  float deg = 0;
  Grid(int _x, int _y){
    gridImage = loadImage("./img/grid.png");
    x = _x;
    y = _y;
  }
  void update(){
    if(transitionMode == 1 && gridAlpha < 255){
      gridAlpha += 0.4*dt;
    }
    if(transitionMode == 2 && 0 < gridAlpha){
      gridAlpha -= 0.4*dt;
    }
    pushMatrix();
    translate(x*80+gridImage.width/2, y*80+gridImage.height/2+12);
    rotate(radians(deg));
    tint(150, 150, 150, gridAlpha);
    imageMode(CENTER);
    image(gridImage, 0, 0);
    popMatrix();
  }
}