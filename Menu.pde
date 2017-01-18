class Menu{
  PImage[] buttonBlurImage = new PImage[3];
  PImage[] buttonImage = new PImage[3];
  PImage[] descriptionImage = new PImage[3];
  PImage hyphenImage;
  float buttonBlurAlpha[] = {0, 0, 0};
  float buttonAlpha[] = {0, 0, 0};
  float descriptionAlpha[] = {0, 0, 0};
  float buttonTint[] = {255, 255, 255};
  float hyphenTargetPos[] = {90, 160, 120};
  float hyphenPos[] = {1000/2, 1000/2, 1000/2};
  float backgroundAlpha = 255;
  float whiteVignetteTint = 255;
  float hyphenImageAlpha[] = {0, 0, 0};
  boolean isSelected = false;
  boolean moveFlag = false;
  int transitionTo = -1;
  int moveTimer = 0;
  Menu(){
    buttonImage[0] = loadImage("./img/play.png");
    buttonImage[1] = loadImage("./img/tutorial.png");
    buttonImage[2] = loadImage("./img/credit.png");
    buttonBlurImage[0] = loadImage("./img/playBlur.png");
    buttonBlurImage[1] = loadImage("./img/tutorialBlur.png");
    buttonBlurImage[2] = loadImage("./img/creditBlur.png");
    descriptionImage[0] = loadImage("./img/playDescription.png");
    descriptionImage[1] = loadImage("./img/tutorialDescription.png");
    descriptionImage[2] = loadImage("./img/creditDescription.png");
    hyphenImage = loadImage("./img/hyphen.png");
  }
  void update(){
    background(0);
    //vignette & background image
    imageMode(CORNER);
    tint(255, 255 ,255 ,255);
    image(backgroundWhiteImage, 0, 0);
    tint(255, 255 ,255 ,backgroundAlpha);
    image(backgroundBlackImage, 0, 0);
    tint(whiteVignetteTint, whiteVignetteTint ,whiteVignetteTint ,255);
    image(whiteVignetteImage, 0, 0);
    //hyphen animation
    for(int i = 0; i < 3; i++){
      imageMode(CENTER);
      if(!isSelected){
        hyphenImageAlpha[i] = 255/(800/2-hyphenTargetPos[i])*(800/2-hyphenPos[i]);
      }
      else{
        if(0 < hyphenImageAlpha[i])
        hyphenImageAlpha[i] -= fadeInOut*dt;
      }
      tint(255, 255, 255, hyphenImageAlpha[i]);
      image(hyphenImage, 1280/2+hyphenPos[i], 768/8*(3+i)-4);
      image(hyphenImage, 1280/2-hyphenPos[i], 768/8*(3+i)-4);
    }
    //description
    for(int i = 0; i < 3; i++){
      imageMode(CENTER);
      tint(255, 255, 255, descriptionAlpha[i]);
      image(descriptionImage[i], 1280/2, 768/9*8);
    }
    //button control
    for(int i = 0; i < 3; i++){
      //button image
      if(!isSelected && buttonAlpha[i] < 255){
        buttonAlpha[i] += 0.5*dt;
      }
      imageMode(CENTER);
      tint(buttonTint[i], buttonTint[i], buttonTint[i], buttonAlpha[i]);
      image(buttonImage[i], 1280/2, 768/8*(3+i));
      
      //mouse hover
      if(1280/2-buttonImage[i].width/2 < mouseX && mouseX < 1280/2+buttonImage[i].width/2 && 768/8*(3+i)-buttonImage[i].height/2 < mouseY && mouseY < 768/8*(3+i)+buttonImage[i].height/2){
        if(!isSelected){
          //move hyphen
          hyphenPos[i] += (hyphenTargetPos[i] - hyphenPos[i])*0.014*dt;
          //button blur show
          if(buttonBlurAlpha[i] < 255){
            buttonBlurAlpha[i] += fadeInOut*dt;
          }
          //description show
          if(descriptionAlpha[i] < 255){
            descriptionAlpha[i] += dt;
          }
        }
        //detect mouse click
        if(mouseButton == LEFT && !isSelected){
          mouseButton = 0;
          isSelected = true;
          transitionTo = i;
        }
      }
      //un-hover
      else{
        //move hyphen
        hyphenPos[i] += (1000/2 - hyphenPos[i])*0.01*dt;
        //button blur hide
        if(0 < buttonBlurAlpha[i]){
          buttonBlurAlpha[i] -= fadeInOut*dt;
        }
        //description hide
        if(0 < descriptionAlpha[i]){
          descriptionAlpha[i] -= dt;
        }
      }
      imageMode(CENTER);
      tint((int)buttonTint[i], (int)buttonTint[i], (int)buttonTint[i],  (int)buttonBlurAlpha[i]);
      image(buttonBlurImage[i], 1280/2, 768/8*(3+i));
    }
    //after the button clicked
    if(isSelected){
      //description hide
      for(int i = 0; i < 3; i++){
        if(0 < descriptionAlpha[i]){
          descriptionAlpha[i] -= fadeInOut*dt;
        }
      }
      //background nega-posi
      if(0 < backgroundAlpha){
        backgroundAlpha -= fadeInOut*dt;
        whiteVignetteTint = backgroundAlpha; 
      }
      for(int i = 0; i < 3; i++){
        if(0 < buttonBlurAlpha[i]){
          buttonBlurAlpha[i] -= fadeInOut*dt;
        }
        if(i == transitionTo && 50 < buttonTint[i]){
          buttonTint[i] -= fadeInOut*dt;
        }
        //wait
        if(!moveFlag && i == transitionTo && buttonTint[i] < 50){
          moveTimer += dt;
          if(1000 < moveTimer){
            moveFlag = true;
          }
        }
        else if(i != transitionTo && 0 < buttonAlpha[i]){
          buttonAlpha[i] -= fadeInOut*dt;
          buttonBlurAlpha[i] -= fadeInOut*dt;
        }
        if(moveFlag && transitionTo == i){
          if(0 < buttonAlpha[i]){
             buttonAlpha[i] -= fadeInOut*dt; 
          }
          //move scene
          else if(i == 0){
            mouseButton = 0;
            scene = Scene.game;
          }
          else if(i == 1){
            title = new Title();
            mouseButton = 0;
            scene = Scene.title;
          }
          else if(i == 2){
            title = new Title();
            mouseButton = 0;
            scene = Scene.title;
          }
        }
      }
    }
  }
}