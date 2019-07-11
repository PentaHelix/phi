package ds;

import haxe.ds.Vector;

@:generic
typedef Node<T> = {
  var data: T;
  var priority: Int;
  var position: Int;
}

@:generic
class PriorityQueue<T> {
	public var capacity(default, null):Int;

	var mData: Vector<Node<T>>;
	var mInitialCapacity: Int = 1;
	var mSize: Int = 0;
	
	public function new() {
		capacity = mInitialCapacity;
		mData = new Vector<Node<T>>(capacity + 1);
		mData[0] = null; //reserved
	}

	/**
		Returns the front element.
		
		This is the element with the highest priority.
	**/
	public inline function peek(): T {
		return mData[1].data;
	}
	
	/**
		Returns the rear element.
		
		This is the element with the lowest priority.
	**/
	public function back(): T {
		if (size == 1) return mData[1].data;
		
		var a = mData[1], b;
    for (i in 2...size + 1) {
      b = mData[i];
      if (a.priority < b.priority) a = b;
    }
		return a.data;
	}
	
	/**
		Enqueues `val`.
	**/
	public function enqueue(val:T, pri: Int): Void {
		if (size == capacity) grow();
		mData[++mSize] = {
      data: val,
      priority: pri,
      position: size
    }
		upheap(size);
	}
	
	/**
		Dequeues the front element.
	**/
	public function dequeue(): T {
		var x = mData[1];
		mData[1] = mData[size];
		downheap(1);
		
		mSize--;
		return x.data;
	}
	
	/**
		The total number of elements.
	**/
	public var size(get, never):Int;
	inline function get_size():Int
	{
		return mSize;
	}
	
	/**
		Returns true only if `this.size` is 0.
	**/
	public inline function isEmpty():Bool
	{
		return size == 0;
	}
	
	inline function upheap(index:Int) {
		var d = mData;
		var parent = index >> 1;
		var t = d[index];
		var p = t.priority;

    while (parent > 0) {
      var parentVal = d[parent];
      if (p - parentVal.priority < 0) {
        d[index] = parentVal;
        parentVal.position = index;
        
        index = parent;
        parent >>= 1;
      }
      else break;
    }
		
		d[index] = t;
		t.position = index;
	}
	
	inline function downheap(index:Int) {
		var d = mData;
		var child = index << 1;
		var childVal: Node<T>;
		var t = d[index];
		var p = t.priority;
    while (child < size) {
      if (child < size - 1)
        if (d[child].priority - d[child + 1].priority > 0)
          child++;
      
      childVal = d[child];
      if (p - childVal.priority > 0) {
        d[index] = childVal;
        childVal.position = index;
        t.position = child;
        index = child;
        child <<= 1;
      }
      else break;
    }
		
		d[index] = t;
		t.position = index;
	}
	
	function repair() {
		var i = size >> 1;
		while (i >= 1) {
			heapify(i, size);
			i--;
		}
	}
	
	function heapify(p:Int, s:Int) {
		var d = mData;
		var l = p << 1;
		var r = l + 1;
		var max = p;

    if (l <= s && (d[l].priority - d[max].priority) < 0) max = l;
    if (l + 1 <= s && (d[l + 1].priority - d[max].priority) < 0) max = r;
		
		var a, b, t;
		if (max != p) {
			a = d[max];
			b = d[p];
			d[max] = b;
			d[p] = a;
			t = a.position;
			a.position = b.position;
			b.position = t;
			heapify(max, s);
		}
	}
	
	function grow() {
		capacity = ((capacity * 3) >> 1) + 1;
		resizeContainer(capacity);
	}
	
	function resizeContainer(newSize:Int){
		var t = new Vector<Node<T>>(newSize + 1);
		Vector.blit(mData, 0, t, 0, mSize + 1);
		mData = t;
	}
}