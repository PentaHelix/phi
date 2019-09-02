package ui;

import h2d.RenderContext;
import h2d.HtmlText;

class Log extends HtmlText{
  private static var messages: Array<String> = [];
  private static var inst: Log;

  public static function info (msg: String) {
    messages.push(msg);
    inst.text += '<font color="#fff">${msg}</font>';
    inst.text += "<br/>";
    inst.resize();
  }

  public static function warn (msg: String) {
    messages.push(msg);
    inst.text += '<font color="#d33">${msg}</font>';
    inst.text += "<br/>";
    inst.resize();
  }

  private var maxHeight: Int;
  private var baseY: Int;

  public function new () {
    super(hxd.Res.font.pixel_font.toFont());
    inst = this;
    font.resizeTo(4);
    letterSpacing = 1/4;
  }

  public function resize () {
    if (textHeight > maxHeight) {
      y = baseY - (textHeight - maxHeight);
    }
  }

  override public function sync (ctx: RenderContext) {
    var width = ctx.scene.width;
    var height = ctx.scene.height;
    maxWidth =  width * 0.4;
    x = -width*0.15;

    baseY = cast -height/2;
    y = baseY;
    maxHeight = cast height * 0.2;
    resize();
  }
}