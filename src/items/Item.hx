package items;

typedef ItemOptions = {
  var ?throwable: Bool;
  var ?consumable: Bool;
  var ?equippable: Bool;
}

class Item {
  public var throwable: Bool;
  public var consumable: Bool;
  public var equippable: Bool;
}