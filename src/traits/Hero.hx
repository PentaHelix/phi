package traits;

import phi.Trait;

class Hero implements Trait {
  public var level: Int = 1;
  public var experience: Int = 0;
  public var cameraFocused: Bool = true;
  
  public function new () {}
}

enum EquipmentSlot {
  HEAD;
  BACK;
  TORSO;
  LEFT_ARM;
  LEFT_FINGER;
  RIGHT_ARM;
  RIGHT_FINGER;
  BELT;
  LEGS;
  FEET;
}