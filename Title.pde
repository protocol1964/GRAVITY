class Title{
  int timer = 0;
  boolean isStarted = false;
  float logoAlpha = 0;
  float blurAlpha = 0;
  float fadeout = 0;
  float pointerX = 1280/2;
  float pointerY = 768/2;
  PImage logoImage, startImage, startBlurImage;
  
  Title(){
    logoImage = loadImage("./img/titleLogo.png");
    startImage = loadImage("./img/start.png");
    startBlurImage = loadImage("./img/startBlur.png");
  }
  
  void update(){
    background(0);
    timer += dt;
    //background image
    imageMode(CORNER);
    tint(255, 255 ,255 , 255);
    image(backgroundBlackImage, 0, 0);
    //logo image
    if(2000 < timer && logoAlpha < 254){
      logoAlpha += 0.1*dt;
    }
    imageMode(CENTER);
    tint(255, 255 ,255 , (int)logoAlpha - (int)fadeout);
    image(logoImage, 1280/2, 768/7*3);
    //pointer image & mouse tracking
    /*
    float distanceX = mouseX - pointerX;
    float distanceY = mouseY - pointerY;
    pointerX += distanceX * 0.1;
    pointerY += distanceY * 0.1;
    imageMode(CENTER);
    image(pointer, pointerX, pointerY);
    */
    //vignette image
    imageMode(CORNER);
    tint(255, 255 ,255 , (int)logoAlpha);
    image(whiteVignetteImage, 0, 0);
    //start button
    imageMode(CENTER);
    tint(255, 255 ,255 , (int)logoAlpha - (int)fadeout);
    image(startImage, 1280/2, 768/5*3);
    //startBlur(mouse hover)
    if(1280/2-startImage.width/2 < mouseX && mouseX < 1280/2+startImage.width/2 && 768/5*3-startImage.height/2 < mouseY && mouseY < 768/5*3+startImage.height/2){
      if(blurAlpha < 254){
        blurAlpha += fadeInOut*dt;
      }
      if(mouseButton == LEFT){
        mouseButton = 0;
        isStarted = true;
      }
    }
    else if(0 < blurAlpha){
      blurAlpha -= fadeInOut*dt;
    }
    if(!isStarted){
      tint(255, 255 ,255 , (int)blurAlpha - (int)fadeout);
    }
    imageMode(CENTER);
    image(startBlurImage, 1280/2, 768/5*3);
    //after the start button clicked
    if(isStarted){
      //tint(255, 255, 255, fadeout);
      if(254 < fadeout){
        menu = new Menu();
        scene = Scene.menu;
      }
      else{
        fadeout += 0.4*dt;
      }
    }
  }
}