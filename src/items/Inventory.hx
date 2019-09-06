package items;

class Inventory {
  public var size: Int;
  private var items: Array<Item>;

  public function new (size: Int) {
    this.size = size;
    this.items = [];
  }

  public function add (item: Item): Int {
    for (i in 0...size) {
      if (items[i] == null) {
        items[i] = item;
        return i;
      }
    }

    return -1;
  }

  public function move (item: Item, to: Int) {
    items[items.indexOf(item)] = null;
    items[to] = item;
  }

  public function remove (item: Item): Int {
    throw 'TODO: implement';
    return -1;
  } 
}