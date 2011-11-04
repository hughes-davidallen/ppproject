import x10.io.File;

public class InputParser {
	/*
	 * Takes a data file as input and produces a 3-dimensional array that
	 * can be read by the heat-flow program thermal.
	 * The first three lines of the input file must contain the dimensions
	 * of the array, one integer per line with no other characters on the
	 * line.  After that, any number of blank lines will be tolerated.  The
	 * data must appear as follows:  all data from one row must appear on
	 * the same line, and values must be separated by commas.  Whitespace
	 * is insignificant.  Values must be in a format recognizable as a
	 * double-precision floating-point number.  No other punctuation is
	 * allowed in the file.
	 */
	static def parse(filename:String) {

		val x:Int;
		val y:Int;
		val z:Int;

		val input = new File(filename);
		val lines = input.lines();

		//Get dimensions from first three lines
		x = Int.parse(lines.next().trim());
		y = Int.parse(lines.next().trim());
		z = Int.parse(lines.next().trim());

		//use the dimensions to define a region
		val reg = (1..x)*(1..y)*(1..z);
		val data = new Array[Double](reg);

		var line:String;
		var temps:Array[String];

		//Populate the array with data from the file
		for (k in 1..z) {
			for (j in 1..y) {
                line = lines.next();
                while (line.length() < 2) { //skip blank lines
					line = lines.next();
				}
				temps = line.split(","); //listify the input line
				for (i in 1..x) {
					data(i,j,k) = Double.parse(temps(i-1).trim());
				}
			}
		}
		return data;
	}
}
