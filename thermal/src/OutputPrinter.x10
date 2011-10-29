import x10.io.File;
import x10.io.Printer;

public class OutputPrinter {
	/**
	 * Prints the contents of 3-dimensional Array mat
	 * to standard output.
	 */
	public static def printm(mat:Array[Double](3)) {
		printm(Console.OUT, mat);
	}

	/**
	 * Prints the contents of 3-dimensional Array mat
	 * to a file name by filename.
	 */
	public static def printm(filename:String, mat:Array[Double](3)) {
		val file = new File(filename);
		printm(file, mat);
	}

	/**
	 * Prints the contents of 3-dimensional Array mat to file
	 */
	public static def printm(file:File, mat:Array[Double](3)) {
		printm(file.printer(), mat);
	}

	/**
	 * Prints the contents of 3-dimensional Array mat using
	 * Printer p
	 */
	public static def printm(p:Printer, mat:Array[Double](3)) {
		val x_size = mat.region.max(0);
		val y_size = mat.region.max(1);
		val z_size = mat.region.max(2);

		for (k in 0..z_size) 
		{
			for (j in 0..y_size) 
			{
				for (i in 0..x_size)
					p.print(mat(i,j,k) + ((i == x_size)?"":", "));
				p.println((j == y_size)?";":":");
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
