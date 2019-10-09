package phi;

abstract Entity(Int) to Int from Int {
  #if !macro
  private static var entity_count = 0;
  public function new (t: Array<Trait>, ?u: Universe) {
    this = entity_count++;
    Game.registerEntity(this, u);
    addTraits(t);
    Game.match(this);
    if (u != null) warpTo(u);
  }

  public function addTraits (traits: Array<Trait>) {
    for (trait in traits) {
      phi.Game.entities.get(this).traits.set(trait.hashCode());
      phi.Game.entities.get(this).data.set(trait.hashCode(), trait);
    }
  }

  public function getTrait (id: Int) {
    return Game.entities.get(this).data.get(id);
  }

  public function warpTo (u: Universe) {
    var data = Game.entities.get(this);
    data.universe = u;

    destroy();
    
    Game.entities.set(this, data);
    u.addEntity(this);
    Game.match(this);
  }

  public inline function destroy () {
    Game.removeEntity(this);
  }

  #end
  
  public macro function get<T> (e: ExprOf<Entity>, c: ExprOf<Class<T>>): ExprOf<T> {
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