package controllers;

import rules.HexActorRule.Actor;
import actions.Action;

interface Controller {
  public var self: Actor;
  public var type: String;
  public function getAction (): Action;
}