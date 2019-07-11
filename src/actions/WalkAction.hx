package actions;

class WalkAction implements Action {
  var actor: HexActor;
  var move: HexVec;

  public function new (actor: HexActor, move: HexVec) {
    this.actor = actor;
    this.move = move;
  }

  public function perform () {
    
    return false;
  }
}