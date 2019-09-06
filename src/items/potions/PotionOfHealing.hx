package items.potions;

import ui.Log;
import items.Item.ItemEvent;

class PotionOfHealing extends Potion {
  override public function new () {
    super("potion_of_healing", (ev: ItemEvent) -> {
      ev.user.actor.health += 15 + 10 * level;
      Log.info('${ev.user.actor.name} drank a Potion of Healing and recovered ${15 + 10 * level}hp');
      return true;
    }, (ev: ItemEvent) -> {
      return true;
    });
  }
}