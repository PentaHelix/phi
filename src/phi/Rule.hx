package phi;
import haxe.macro.Context;

#if !macro
@:autoBuild(Rule.build())
interface Rule {
  public function init (): Void;
  public function tick (): Void;
}

#else
class Rule {
  public static macro function build () {
    trace(Context.getBuildFields());
    return null;
  }
}
#end