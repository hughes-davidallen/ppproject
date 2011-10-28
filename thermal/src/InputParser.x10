import x10.io.File;

public class InputParser{
	static def parse(filename:String) {

		val x:Int;
		val y:Int;
		val z:Int;

		val input = new File(filename);
		val lines = input.lines();

		x = Int.parse(lines.next().trim()) - 1;
		y = Int.parse(lines.next().trim()) - 1;
		z = Int.parse(lines.next().trim()) - 1;

		val reg = (0..x)*(0..y)*(0..z);

		val data = new Array[Double](reg, 0);

		var temps:Array[String];

		for (k in 0..z)
			for (j in 0..y) {
				temps = lines.next().split(",");
				for (i in 0..x) {
					data(i,j,k) = Double.parse(temps(i).trim());
				}
			}
/*
		for (k in 0..z) {
			for (j in 0..y) {
				for (i in 0..x)
					Console.OUT.print(data(i,j,k) + " ");
				Console.OUT.println();
			}
			Console.OUT.println();
		}
*/

		return data;
	}

	public static def main(args:Array[String](1)):void {
		parse(args(0));
	}
}
