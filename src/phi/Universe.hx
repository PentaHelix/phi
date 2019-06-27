package phi;

class Universe {
  private var passes:Array<Pass> = [];
  public function addPass(p: Pass) {
    passes.push(p);
  }
}