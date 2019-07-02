package;

class Utils {
  public static function random<T> (arr:Array<T>): T {
    return arr[Math.floor(Math.random() * arr.length)];
  }
}