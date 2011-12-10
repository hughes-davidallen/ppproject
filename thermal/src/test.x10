public class test {
	public static def main(args:Array[String]):void {
		val r = (0..5)*(0..5)*(0..5);
		val ar:Array[Int](3) = new Array[Int](r, 0);

		Console.OUT.println(ar);

		val arr:Array[Array[Int]](1) = new Array[Array[Int]](5, (i:Int)=>new Array[Int](5, 0));
		arr(2)(4) = 6;

		for (i in 0..4) {
			for (j in 0..4) {
				Console.OUT.print(arr(i)(j) + " ");
			}
			Console.OUT.println();
		}
	}
}
