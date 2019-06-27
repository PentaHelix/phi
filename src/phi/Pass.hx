package phi;

class Pass {
  private var rules: Array<Rule> = [];
  public function new () {}
  public function add (rule: Rule) {
    rules.push(rule)
  }
}