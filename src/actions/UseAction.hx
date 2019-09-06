package actions;

import rules.HexActorRule.Actor;
import items.Item;

class UseAction implements Action {
  var self: Actor;
  var item: Item;
  var actionName: String;

  public function new (self: Actor, item: Item, actionName: String) {
    this.self = self;
    this.item = item;
    this.actionName = actionName;
  }
  
  public function perform () {
    return item.actions.get(actionName)({
      name: actionName,
      user: self
    });
  }
}