static float fadeInOut = 0.7;
int curTime, dt, lastTime;
Scene scene;
Title title;
Game game;
Menu menu;
Result result;
PImage whiteVignetteImage, backgroundBlackImage, backgroundWhiteImage;
JSONObject json;
JSONArray stages;

void setup(){
  size(1280, 768);
  frameRate(60);
  noStroke();
  lastTime = 0;
  whiteVignetteImage = loadImage("./img/whiteVignette.png");
  backgroundBlackImage = loadImage("./img/background.png");
  backgroundWhiteImage = loadImage("./img/backgroundWhite.png");
  json = loadJSONObject("./stages.json");
  stages = json.getJSONArray("stages");
  //set to default scene
  scene = Scene.title;
  title = new Title();
  game = new Game();
  menu = new Menu();
}

void draw(){
  curTime = millis();
  dt = curTime - lastTime;
  lastTime = curTime;
  if(scene == Scene.title){
    title.update();
  }
  if(scene == Scene.menu){
    menu.update();
  }
  if(scene == Scene.game){
    game.update();
  }
  if(scene == Scene.result){
    result.update();
  }
}