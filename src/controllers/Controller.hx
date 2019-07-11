package controllers;

import actions.Action;

interface Controller {
  public function getAction (): Action;
}