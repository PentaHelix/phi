package items;

class Inventory {
  public var size: Int;
  private var items: Array<Item>;

  public function new (size: Int) {
    this.size = size;
    this.items = [];
  }

  public function add (item: Item):Bool {
    if (this.items.length == size) return false;
    this.items.push(item);
    return true;
  }
}