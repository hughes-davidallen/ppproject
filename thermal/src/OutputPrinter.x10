import x10.io.File;
import x10.io.Printer;

public class OutputPrinter {
	/**
	 * Prints the contents of 3-dimensional Array mat
	 * to standard output.
	 */
	public static def printm(mat:Array[Double]) {
		printm(Console.OUT, mat);
	}

	/**
	 * Prints the contents of 3-dimensional Array mat
	 * to a file name by filename.
	 */
	public static def printm(filename:String, mat:Array[Double]) {
		val file = new File(filename);
		printm(file, mat);
	}

	/**
	 * Prints the contents of 3-dimensional Array mat to file
	 */
	public static def printm(file:File, mat:Array[Double]) {
		printm(file.printer(), mat);
	}

	/**
	 * Prints the contents of 3-dimensional Array mat using
	 * Printer p
	 */
	public static def printm(p:Printer, mat:Array[Double]) {
		val R = mat.region;
		val x_min = R.min(0);
		val x_max = R.max(0);
		val y_min = R.min(1);
		val y_max = R.max(1);
		val z_min = R.min(2);
		val z_max = R.max(2);

		val x_size = x_max - x_min + 1;
		val y_size = y_max - y_min + 1;
		val z_size = z_max - z_min + 1;

		p.println(x_size);
		p.println(y_size);
		p.println(z_size);

		for (k in z_min..z_max) 
		{
			for (j in y_min..y_max) 
			{
				for (i in x_min..x_max)
					p.printf("%.4f%s", mat(i,j,k), ((i == x_size)?"":", "));
				p.println();
		 	}
			p.println();
		}
	}

	/**
	 * This main method is meant only to test the other 
	 * static methods defined above
	 */
	public static def main(args:Array[String]) {
		val reg = (0..3)*(0..3)*(0..3);
		val mat = new Array[Double](reg, 0);

		mat(1, 2, 2) = 35.7;
		mat(2, 2, 2) = 24.3;
		printm(Console.OUT, mat);
		printm("output.txt", mat);
	}
}
