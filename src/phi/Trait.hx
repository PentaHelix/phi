package phi;

import haxe.macro.Context;

#if !macro
interface Trait {
  public function hashCode(): Int;
}
#else
class Trait {
  public static function build () {

  }

  private static var component_count: Int = 0;
  private static var component_type_map:StringMap<Int> = new StringMap<Int>();

  public static function getTypeId (name: String) {
    if(component_type_map.exists(name)) {
      return component_type_map.get(name);
    }

    component_type_map.set(name, component_count);
    return component_count++;
  }
}
#end