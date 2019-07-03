package gen;

using Hex;
using Utils;

class Dungeon {
  public static inline var ROOM_MIN_SIZE = 8;
  public static inline var ROOM_MAX_SIZE = 18;

  public static function room (): Array<HexPos> {
    var hexes = [HexPos.ZERO];

    while (hexes.length < ROOM_MIN_SIZE || Math.random() > hexes.length / ROOM_MAX_SIZE) {
      var outline = hexes.outline();
      if (Math.random() > hexes.length / ROOM_MAX_SIZE * 1.2) {
        hexes.push(outline.random());
      } else {
        hexes = hexes.concat(outline);
      }
    }

    return hexes;
  }
}