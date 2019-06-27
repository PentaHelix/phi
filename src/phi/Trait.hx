package phi;

import haxe.macro.Context;

#if !macro
interface Trait {

}
#else
class Trait {
  public static function build () {

  }
}
#end