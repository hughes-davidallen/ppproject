public class GhostedArray {

	private val top:Array[Double](2);
	private val bottom:Array[Double](2);
	private val left:Array[Double](2);
	private val right:Array[Double](2);
	private val front:Array[Double](2);
	private val back:Array[Double](2);

	public static val TOP:Int = 0;
	public static val BOTTOM:Int = 1;
	public static val LEFT:Int = 2;
	public static val RIGHT:Int = 3;
	public static val FRONT:Int = 4;
	public static val BACK:Int = 5;

	public def this(xdim:Int, ydim:Int, zdim:Int) {
		val fb = (0..xdim)*(0..ydim);
		val tb = (0..xdim)*(0..zdim);
		val rl = (0..ydim)*(0..zdim);

		front = new Array[Double](fb, 0.0);
		back = new Array[Double](fb, 0.0);
		top = new Array[Double](tb, 0.0);
		bottom = new Array[Double](tb, 0.0);
		right = new Array[Double](rl, 0.0);
		left = new Array[Double](rl, 0.0);
	}

	public def fill():void {
		//fill in the borders
	}

	public def get(position:Int):Array[Double](2) {
		switch (position) {
			case TOP:
				return top;
			case BOTTOM:
				return bottom;
			case LEFT:
				return left;
			case RIGHT:
				return right;
			case FRONT:
				return front;
			case BACK:
				return back;
			default:
				throw new Exception("Invalid argument to GhostedArray.get");
		}
	}

}
