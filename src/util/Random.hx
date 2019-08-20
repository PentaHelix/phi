package util;

class Random {
  public static function to (up: Int): Int{
    return cast (Math.random() * (up+1));
  }

  public static function range (from: Int, to: Int): Int {
    return cast (Math.random() * (to - from) + from);
  }
}