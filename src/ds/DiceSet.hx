package ds;

typedef Dices = {
  var faces: Int;
  var amount: Int;
  var coef: Int;
}

class DiceSet {
  private static var regex = ~/[+-]?([0-9]+(d[0-9]+)?)+/;
  var dices: Array<Dices> = [];
  var constant: Int = 0;

  public function new (str: String) {
    while (regex.match(str)) {
      var dices = regex.matched(1);
      var coef = dices.charAt(0) == '-' ? -1 : 1;
      var amount = Std.parseInt(dices.split('d')[0]);
      if (str.indexOf('d') != -1) {
        amount *= coef;
        var faces = Std.parseInt(dices.split('d')[1]);
        this.dices.push({
          faces: faces,
          amount: amount,
          coef: coef
        });
      } else {
        constant += amount;
      }
      str = regex.matchedRight();
    }
  }

  public function roll (): Int {
    var res = constant;
    for (d in dices) {
      for (_ in 0...d.amount) res += Math.floor((Math.random() * d.faces) + 1);
    }
    return res;
  }
}