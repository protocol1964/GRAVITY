class Game{
  Stage stage;
  int stageNumber = 1;
  Game(){
    stage = new Stage(1);
  }
  void update(){
    if(stage.update()){
      stage = new Stage(++stageNumber);
    }
  }
}