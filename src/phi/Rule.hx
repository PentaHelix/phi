package phi;

import haxe.macro.Context;
import haxe.macro.Expr;

#if !macro
@:autoBuild(phi.Rule.build())
interface Rule<T:{}> {
  public function init (): Void;
  public function tick (): Void;
  public function match (e: Entity): Void;
}

#else

class Rule {
  public static function build () {
    var fields: Array<Field> = Context.getBuildFields();
    var type = Context.getLocalType();
    var p: haxe.macro.ComplexType;
    switch(type) {
      case TInst(classType, _):
        p = Context.toComplexType(classType.get().interfaces[0].params[0]);
      default:
    }

    fields.push({
      name: 'entities',
      kind: FVar(
        TPath({
          name: 'Array',
          pack: [],
          params: [
            TPType(p)
          ]
        })
      ),
      access: [APublic],
      meta: null,
      pos: Context.currentPos()
    });


    return fields;
  }

  private static function matcher (t: haxe.macro.Type): Field {
    
    return {
      name: 'match',
      kind: FFun({
        args: [{
          name: 'entity',
          meta: null,
          opt: false,
          value: null,
          type: TPath({
            name: 'Entity',
            pack: ['phi'],
            params: null,
            sub: null
          })
        }],
        params: null,
        expr: macro $b{body}
      })
    };
  }
}

#end