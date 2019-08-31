package;

class Utils {
  public static function random<T> (arr:Array<T>): T {
    return arr[Math.floor(Math.random() * arr.length)];
  }

	public static function popRandom<T> (arr:Array<T>): T {
		return arr.splice(Math.floor(Math.random() * arr.length), 1)[0];
  }

  public static inline function int (from:Int, to:Int): Int {
		return from + Math.floor(((to - from + 1) * Math.random()));
	}
  
  public static function shuffle<T> (arr:Array<T>): Array<T> {
		if (arr!=null) {
			for (i in 0...arr.length) {
				var j = int(0, arr.length - 1);
				var a = arr[i];
				var b = arr[j];
				arr[i] = b;
				arr[j] = a;
			}
		}
		return arr;
	}
}