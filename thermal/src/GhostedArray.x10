public class GhostedArray[T] extends Array[T] {

	private val top:Array[T](2);
	private val bottom:Array[T](2);
	private val left:Array[T](2);
	private val right:Array[T](2);
	private val front:Array[T](2);
	private val back:Array[T](2);

	public val TOP:Int = 0;
	public val BOTOM:Int = 1;
	public val LEFT:Int = 2;
	public val RIGHT:Int = 3;
	public val FRONT:Int = 4;
	public val BACK:Int = 5;

	public def fill():void {
		//fill in the borders
	}

	public def get(position:Int):Array[T](2) {
		switch (position) {
			case TOP:
				return top;
		}
	}

}
