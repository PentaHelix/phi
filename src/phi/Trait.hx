package phi;

import haxe.macro.Expr.ComplexType;
import haxe.macro.Context;
import haxe.ds.StringMap;

#if !macro
@:autoBuild(phi.Trait.build())
interface Trait {
  public function hashCode(): Int;
}
#else
class Trait {
  public static function build () {
    var id = getTypeId(Context.getLocalClass().get().name);
    var fields = Context.getBuildFields();
    fields.push({
      name: 'hashCode',
      pos: Context.currentPos(),
      access: [APublic, AInline],
      kind: FFun({
        args: [],
        ret: TPath({
          name: 'Int',
          pack: [],
          params: null,
          sub: null
        }),
        params: null,
        expr: macro { return $v{id} }
      })
    });
    return fields;
  }

  private static var trait_count: Int = 0;
  private static var trait_type_map:StringMap<{id: Int, ct: ComplexType}> = new StringMap<{id: Int, ct: ComplexType}>();

  public static function getTypeId (name: String, ?ct: ComplexType): Int {
    if(trait_type_map.exists(name)) {
      trait_type_map.get(name).ct = ct;
      return trait_type_map.get(name).id;
    }

    trait_type_map.set(name, {id: trait_count, ct: ct});
    return trait_count++;
  }

  public static function getType (name: String): ComplexType {
    return trait_type_map.get(name).ct;
  }
}
#end