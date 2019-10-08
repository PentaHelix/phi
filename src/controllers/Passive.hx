package controllers;

import archetypes.Actor;

class Passive implements Controller {
  public var type: String = 'passive';
  public var self: Actor;
  
  public function getAction () {
    return null;
  }
}