package phi;

import haxe.Int64;

abstract Traits(Int64) to Int64 from Int64 {
  public function new (?traits: Array<Int>) {
    this = 0;
    if (traits == null) traits = [];
    for (trait in traits) {
      set(trait);
    }
  }

  public inline function set (trait: Int) {
    this |= 1 << trait;
  }

  public inline function unset (trait: Int) {
    this &= ~(1 << trait);
  }

  public inline function match (mask: Traits) {
    return this & mask == mask;
  }

  @:from
  public static inline function fromInt (int: Int): Traits {
    return cast int;
  }
}