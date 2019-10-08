package ui;

import h2d.Scene;
import h2d.RenderContext;
import h2d.HtmlText;

class Log extends HtmlText{
  private static var messages: Array<String> = [];
  private static var inst: Log;

  public static function info (msg: String) {
    messages.push(msg);
    inst.text += '<font color="#fff">${msg}</font>';
    inst.text += "<br/>";
    inst.scroll();
  }

  public static function warn (msg: String) {
    messages.push(msg);
    inst.text += '<font color="#d33">${msg}</font>';
    inst.text += "<br/>";
    inst.scroll();
  }

  private var maxHeight: Int;
  private var baseY: Int;

  public function new () {
    super(hxd.Res.font.pixel_font.toFont());
    inst = this;
    font.resizeTo(4);
    letterSpacing = 1/4;
  }

  private function scroll () {
    if (textHeight > maxHeight) {
      y = baseY - (textHeight - maxHeight);
    }
  }

  public function onResize (s2d: Scene) {
    var width = s2d.width/UI.uiScale;
    var height = s2d.height/UI.uiScale;
    maxWidth =  width * 0.4;
    x = -width*0.15;

    baseY = cast -height/2;
    y = baseY;
    maxHeight = cast height * 0.2;
    scroll();
  }
}