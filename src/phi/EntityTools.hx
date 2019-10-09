package phi;

import haxe.macro.Expr;

class EntityTools {
  public static macro function get<T> (e: ExprOf<Entity>, c: ExprOf<Class<T>>): ExprOf<T> {
    var name = switch (c.expr) {
      case EField(_, name): name;
      case EConst(CIdent(name)): name; 
      default: null;
    }

    var type = Trait.getType(name);

    return {
      expr: ECast(macro $e{e}.getTrait($v{Trait.getTypeId(name)}), type),
      pos: c.pos,
    };
  }
}