package phi;

class Pass {
  private var rules: Array<Rule<{}>> = [];
  public function new () {}

  public function add (rule: Rule<{}>) {
    rules.push(rule);
  }

  public function tick () {
    for (rule in rules) {
      rule.tick();
    }
  }

  public function match (e: Entity) {
    for (rule in rules) {
      rule.match(e);
    }
  }
}