package items.potions;

import items.Item.ItemEvent;

class Potion extends Item {
  public function new (name: String, onDrink: ItemEvent->Bool, onThrow: ItemEvent->Bool) {
    super(name);
    actions.set("drink", onDrink);
    actions.set("throw", onThrow);
  }
}