import x10.util.Timer;

public class thermal 
{
	/**
	 * The command-line arguments to thermal are as follows:
	 * args(0) is a string and represents the name of the file
	 *         from which to read the input to the program
	 * args(1) is an integer and represents the number of
	 *         iterations for which to run the program
	 * args(2) is either 'true' or 'false' and signifies whether
	 *         the intermediate results of the computation
	 */
	public static def main(args:Array[String](1)):void 
	{
		//get source array from file
		val source = InputParser.parse(args(0));
		val iterations = Int.parse(args(1));
		val verbose = Boolean.parse(args(2));

		//get dimensions of source array
		val source_reg:Region = source.region;
		val x_source_size:Int = source_reg.max(0);
		val y_source_size:Int = source_reg.max(1);
		val z_source_size:Int = source_reg.max(2);

		//create new, larger region for border data
		val work_reg:Region = 
			((0..(x_source_size + 1))*(0..(y_source_size + 1))*(0..(z_source_size+1)));

		//create working arrays
		var A:Array[Double](3) = new Array[Double](work_reg, 0.0);
		var B:Array[Double](3) = new Array[Double](work_reg, 0.0);

		//copy source into working arrays
		for(i in 1..x_source_size)
		{
			for(j in 1..y_source_size)
			{
				for(k in 1..z_source_size)
				{
					A(i,j,k) = source(i,j,k);
					B(i,j,k) = source(i,j,k);
				}
			}
		}

		/* START TIMING */
		val starttime = Timer.milliTime();

		//do loop with calculations, alternating working arrays read/write
		//we'll start with 5 iterations for now
		for (i in 1..iterations)
		{
			//fill in border data
			borderFill(A, x_source_size, y_source_size, z_source_size);
			borderFill(B, x_source_size, y_source_size, z_source_size);

			//do cell averaging
			val even = (i % 2 == 0);
			if(even) calc(A, B, x_source_size, y_source_size, z_source_size);
			else calc(B, A, x_source_size, y_source_size, z_source_size);
		
			if (verbose) {
				Console.OUT.println("Iteration "+ i + ":");
				OutputPrinter.printm(even?B:A);
				Console.OUT.println("--------------------------");
			}
		}

		val stoptime = Timer.milliTime() - starttime;

		//DONE
		Console.OUT.println("DONE in " + stoptime + " milliseconds");
		//Print final results to output file
		OutputPrinter.printm("output.txt", A);
	}

	//actual thermal transfer vector calcuation
	public static def calc(A1:Array[Double](3), A2:Array[Double](3), x_size:Int, y_size:Int, z_size:Int)
	{
		for(i in 1..x_size)
		{
			for(j in 1..y_size)
			{
				for(k in 1..z_size)
				{
					//do math with A1 pixels, write to A2
					A2(i,j,k) =	(A1(i+1, j, k) +
								A1(i-1, j, k) +
								A1(i, j+1, k) +
								A1(i, j-1, k) +
								A1(i, j, k+1) +
							 	A1(i, j, k-1)) / 6;
				}
			}
		}
	}
	
	public static def borderFill(A:Array[Double](3), x_max:Int, y_max:Int, z_max:Int)
	{
		//Top and Bottom
		for (i in 1..x_max)
			for (j in 1..y_max) {
				A(i, j, 0) = A(i, j, 1);
				A(i, j, z_max + 1) = A(i, j, z_max);
			}

		//Front and Back
		for (i in 1..x_max)
			for (k in 0..z_max + 1) {
				A(i, 0, k) = A(i, 1, k);
				A(i, y_max + 1, k) = A(i, y_max, k);
			}

		//Left and Right
		for (j in 0..y_max + 1)
			for (k in 0..z_max + 1) {
				A(0, j, k) = A(1, j, k);
				A(x_max + 1, j, k) = A(x_max, j, k);
			}
	}
}
