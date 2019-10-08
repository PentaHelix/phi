package controllers;

import archetypes.Actor;
import actions.Action;

interface Controller {
  public var self: Actor;
  public var type: String;
  public function getAction (): Action;
}