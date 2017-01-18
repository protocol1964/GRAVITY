class Stage {
  Grid grid[][] = new Grid[16][9];
  Player player;
  Goal goal;
  ArrayList<UserMass> userMass;
  PVector massPos[];
  PVector goalPos;
  PImage stageNumberImage;
  PImage numberImage[];
  PImage massStockImage = loadImage("./img/massStock.png");
  PImage massImageSample = loadImage("./img/massImageSample.png");
  PImage userMassImage = loadImage("./img/userMassImageSample.png");
  PImage failedResultImage = loadImage("./img/failed.png");
  PImage clearResultImage = loadImage("./img/clear.png");
  PImage arrowImage = loadImage("./img/arrow.png");
  int stageNumber;
  int massStock;
  int counterForErrorClick = 0;
  float massAlpha[];
  float gameOverTint = 0;
  float stageNumberAlpha = 0;
  float massStockAlpha = 0;
  float resultImageAlpha = 0;
  float resultImagePos = 0;
  float startEffectTimer = 0;
  float goalEffectTimer = 0;
  float arrowImageAlpha = 0;
  float arrowImagePos = 0;
  float clearImagePos = 1280/2-20;
  boolean isMassHit = false;
  boolean isReady = false;
  boolean isStarted = false;
  boolean isLeftClickedInLastFrame = false;
  boolean isFinished = false;
  boolean isGoaled = false;
  boolean isMassHid = false;
  boolean isGoalAnimationFinished = false;
  boolean isClickedToNextStage = false;
  int debug = 0;

  Stage(int _stageNumber) {
    stageNumber = _stageNumber;
    player = new Player(stages.getJSONObject(stageNumber-1).getJSONArray("start").getInt(0), stages.getJSONObject(stageNumber-1).getJSONArray("start").getInt(1));
    //make grid
    for (int i = 0; i < 16; i++) {
      for (int j = 0; j < 9; j++) {
        grid[i][j] = new Grid(i, j);
        grid[i][j].transitionMode = 1; //start to increace animation
      }
    }
    userMass = new ArrayList<UserMass>();
    //make array of mass position & alpha
    massPos = new PVector[stages.getJSONObject(stageNumber-1).getJSONArray("mass").size()];
    massAlpha = new float[stages.getJSONObject(stageNumber-1).getJSONArray("mass").size()];
    massStock = stages.getJSONObject(stageNumber-1).getInt("stock");
    for (int i = 0; i < massAlpha.length; i++) {
      massAlpha[i] = 0;
    }
    //make goal
    goalPos = new PVector(stages.getJSONObject(stageNumber-1).getJSONArray("goal").getInt(0), stages.getJSONObject(stageNumber-1).getJSONArray("goal").getInt(1));
    goal = new Goal((int)goalPos.x, (int)goalPos.y);
    //load stage number
    stageNumberImage = loadImage("./img/stage" + str(stageNumber) + ".png");
    //make array of number image
    numberImage = new PImage[10];
    for (int i = 0; i < 10; i++) {
      numberImage[i] = loadImage("./img/" + str(i) + ".png");
    }
  }

  boolean update() {
    startEffectTimer += dt;
    background(255);
    imageMode(CORNER);
    tint(255, 255, 255, 255);
    image(backgroundWhiteImage, 0, 0);
    tint(gameOverTint, 0, 0, 255);
    image(whiteVignetteImage, 0, 0);
    //grid image
    for (int i = 0; i < 16; i++) {
      for (int j = 0; j < 9; j++) {
        grid[i][j].update();
      }
    }
    //stage number image
    imageMode(CENTER);
    tint(0, 0, 0, stageNumberAlpha);
    image(stageNumberImage, 1280/2, 768/2);
    if (startEffectTimer < 1500 && stageNumberAlpha < 255) {
      stageNumberAlpha += fadeInOut*dt;
    } else if (!isGoaled && 1500 < startEffectTimer) {
      if (0 < stageNumberAlpha) {
        stageNumberAlpha -= fadeInOut*dt;
      }
      for (int i = 0; i < massAlpha.length; i++) {
        if (1500 + i*100 < startEffectTimer && massAlpha[i] < 255) {
          massAlpha[i] += fadeInOut*dt;
        }
      }
      if (255 <= massAlpha[massAlpha.length-1]) {
        isReady = true;
      }
    }
    //mass stock text show
    if (isReady) {
      imageMode(CENTER);
      tint(20, 20, 20, massStockAlpha);
      image(massStockImage, 1280/2 - 32, 768/2);
      image(numberImage[massStock], 1280/2 + 156, 768/2);
      if (!isStarted && massStockAlpha < 255) {
        massStockAlpha += fadeInOut*dt;
      }
      if (isStarted && 0 < massStockAlpha) {
        massStockAlpha -= fadeInOut*dt;
      }
      if (keyPressed == true) {
        keyPressed = false;
        if (key == ' ') {
          if (isStarted && !isGoaled) {
            isStarted = false;
            player = new Player(stages.getJSONObject(stageNumber-1).getJSONArray("start").getInt(0), stages.getJSONObject(stageNumber-1).getJSONArray("start").getInt(1));
          } else {
            isStarted = true;
          }
        }
      }
    }
    //goal
    goal.update();
    //reset method
    if (isReady && !isStarted) {
      isMassHit = false;
      if (0 < gameOverTint) {
        gameOverTint -= fadeInOut*dt;
      }
      //method of set a mass
      if (mouseButton == LEFT && !isLeftClickedInLastFrame && 0 < massStock) {
        isLeftClickedInLastFrame = true;
        massStock--;
        userMass.add(new UserMass(mouseX, mouseY, 32));
      }
      //method of delete a mass
      if (mouseButton == RIGHT) {
        for (int i = 0; i < userMass.size(); i++) {
          if (sqrt(pow(mouseX-userMass.get(i).pos.x, 2)+pow(mouseY-userMass.get(i).pos.y, 2)) < 40) {
            userMass.get(i).hide();
            break;
          }
        }
      }
      mouseButton = 0;
      //counterplan for error click
      if (isLeftClickedInLastFrame) {
        counterForErrorClick += dt;
        if (500 < counterForErrorClick) {
          counterForErrorClick = 0;
          isLeftClickedInLastFrame = false;
        }
      }
    }
    //user mass image show
    for (int i = 0; i < userMass.size(); i++) {
      userMass.get(i).update();
      if (userMass.get(i).isHid) {
        userMass.remove(i);
        massStock++;
      }
      //add force
      if (isReady && isStarted && !isGoaled) {
        player.addGravity(32, new PVector(userMass.get(i).pos.x, userMass.get(i).pos.y));
        if (userMass.get(i).pos.dist(player.pos) < 40) {
          isMassHit = true;
        }
      }
    }

    //mass image show
    for (int i = 0; i < stages.getJSONObject(stageNumber-1).getJSONArray("mass").size(); i++) {
      massPos[i] = new PVector(stages.getJSONObject(stageNumber-1).getJSONArray("mass").getJSONArray(i).getInt(1), stages.getJSONObject(stageNumber-1).getJSONArray("mass").getJSONArray(i).getInt(2));
      if (isReady && isStarted && !isGoaled) {
        player.addGravity(stages.getJSONObject(stageNumber-1).getJSONArray("mass").getJSONArray(i).getInt(0), new PVector(stages.getJSONObject(stageNumber-1).getJSONArray("mass").getJSONArray(i).getInt(1), stages.getJSONObject(stageNumber-1).getJSONArray("mass").getJSONArray(i).getInt(2)));
      }
      imageMode(CENTER);
      tint(255, 255, 255, massAlpha[i]);
      image(massImageSample, massPos[i].x, massPos[i].y);
      //mass hit detect
      if (massPos[i].dist(player.pos) < 50) {
        isMassHit = true;
      }
    }
    if (goalPos.dist(player.pos) < 55) {
      isGoaled = true;
      player.goalEffect();
    }
    if (!isMassHit) {
      player.update();
      if (!isGoaled) {
        resultImagePos = 0;
        resultImageAlpha = 0;
      }
    }
    if (isGoaled) {
      goalEffectTimer += dt;
      for (int i = 0; i < massAlpha.length; i++) {
        if (500 + i*100 < goalEffectTimer && 0 < massAlpha[i]) {
          massAlpha[i] -= fadeInOut*dt;
        }
      }
      if (massAlpha[massAlpha.length-1] <= 0) {
        isMassHid = true;
      }
      for (int i = 0; i < userMass.size(); i++) {
        if (500 + (massAlpha.length+1)*100 + i*100 < goalEffectTimer) {
          userMass.get(i).hide();
        }
      }
      if(!isClickedToNextStage){
        if (1000 + (massAlpha.length+1)*100 < goalEffectTimer) {
          if (arrowImageAlpha < 255) {
            arrowImageAlpha += fadeInOut * dt;
          }
          for (int i = 0; i < 16; i++) {
            for (int j = 0; j < 9; j++) {
              grid[i][j].transitionMode = 2; //start to decreace animation
            }
          }
          arrowImagePos += ((1280/2+20) - arrowImagePos) * 0.010 * dt;
        }
        resultImagePos += (768/2 - resultImagePos) * 0.014 * dt;
        resultImageAlpha = (70 - abs(768/2 - resultImagePos)) / 70 * 255;
      }
      if(isClickedToNextStage){
        if(player.playerAlpha <= -255){
          return true;
        }
        clearImagePos += (arrowImagePos-1280/2-15) * 0.020*dt;
        arrowImagePos += (arrowImagePos-1280/2-15) * 0.020*dt;
        if (0 < arrowImageAlpha) {
            arrowImageAlpha -= 0.8 * dt;
            resultImageAlpha -= 0.8 * dt;
        }
        player.isHide = true;
        goal.isHide = true;
      }
      imageMode(CENTER);
      tint(0, 0, 0, arrowImageAlpha);
      image(arrowImage, arrowImagePos, 768/2+3);
      imageMode(CENTER);
      tint(arrowImageAlpha, arrowImageAlpha, arrowImageAlpha, resultImageAlpha);
      image(clearResultImage, clearImagePos, resultImagePos);
      if(1500 + (massAlpha.length+1)*100 < goalEffectTimer && mouseButton == LEFT){
        mouseButton = 0;
        isClickedToNextStage = true;
      }
    }
    //failed animation
    if (isMassHit) {
      if (gameOverTint < 255) {
        gameOverTint += fadeInOut * dt;
      }
      imageMode(CENTER);
      tint(0, 0, 0, resultImageAlpha);
      image(failedResultImage, 1280/2, resultImagePos);
      resultImagePos += (768/2 - resultImagePos) * 0.014 * dt;
      resultImageAlpha = (70 - abs(768/2 - resultImagePos)) / 70 * 255;
    }
    return false;
  }
}