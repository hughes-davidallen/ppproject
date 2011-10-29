import x10.io.File;

public class InputParser{
	static def parse(filename:String) {

		val x:Int;
		val y:Int;
		val z:Int;

		val input = new File(filename);
		val lines = input.lines();

		x = Int.parse(lines.next().trim());
		y = Int.parse(lines.next().trim());
		z = Int.parse(lines.next().trim());

		val reg = (1..x)*(1..y)*(1..z);
		val data = new Array[Double](reg);

		var temps:Array[String];

		for (k in 1..z) {
			for (j in 1..y) {
				temps = lines.next().split(",");
				for (i in 1..x) {
					data(i,j,k) = Double.parse(temps(i-1).trim());
				}
			}
		}

		/*for (k in 1..z) {
			for (j in 1..y) {
				for (i in 1..x)
					Console.OUT.print(data(i,j,k) + " ");
				Console.OUT.println();
			}
			Console.OUT.println();
		}
		*/

		return data;
	}
}
