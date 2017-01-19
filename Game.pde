class Game{
  Stage stage;
  int stageNumber = 1;
  int lastStageNumber = 0;
  Game(){
    stage = new Stage(1);
    lastStageNumber = stages.size();
  }
  void update(){
    if(stage.update()){
      if(stageNumber == lastStageNumber){
        scene = scene.title;
      }
      else{
        stage = new Stage(++stageNumber);
      }
    }
  }
}