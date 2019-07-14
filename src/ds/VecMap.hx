package ds;

import haxe.ds.IntMap;

@:forward
abstract VecMap<T>(IntMap<T>) {
  public function new () {
    this = new IntMap<T>();
  }

  @:op([])
  public inline function get(idx: Int) {
    return this.get(idx);
  }

  @:op([])
  public inline function set(idx: Int, val:T) {
    return this.set(idx, val);
  }
}