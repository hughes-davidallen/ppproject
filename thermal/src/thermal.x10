public class thermal 
{
	public static def main(args:Array[String](1)):void 
	{
		//get source array from file
		val source = InputParser.parse(args(0));
		
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
		
		//fill in border data
		borderFill(A, x_source_size, y_source_size, z_source_size);
		borderFill(B, x_source_size, y_source_size, z_source_size);
		
		//do loop with calculations, alternating working arrays read/write
		//we'll start with 5 iterations for now
		for (i in 1..5)
		{
			Console.OUT.println("Iteration "+ i + ":");
			if(i % 2 == 0) calc(A, B, x_source_size, y_source_size, z_source_size);
			else calc(B, A, x_source_size, y_source_size, z_source_size);
		}
		
		//print results to output file
		
		//DONE
		Console.OUT.println("DONE");
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
		
		//print to console
		OutputPrinter.printm(A2);
		Console.OUT.println("--------------------------");
	}
	
	public static def borderFill(A:Array[Double](3), x_max:Int, y_max:Int, z_max:Int)
	{
		//x passes
		
		//bottom-front edge
		for(i in 1..(x_max-1)) A(i, 0, 0)			= A(i, 1, 0);
		//top-front edge
		for(i in 1..(x_max-1)) A(i, y_max, 0)		= A(i, (y_max - 1), 0);
		//bottom-back edge
		for(i in 1..(x_max-1)) A(i, 0, z_max) 		= A(i, 1, z_max);
		//top-back edge
		for(i in 1..(x_max-1)) A(i, y_max, z_max)	= A(i, (y_max - 1), z_max);
		
		//y passes
		
		//left-front edge
		for(i in 1..(y_max-1)) A(0, i, 0)			= A(1, i, 0);
		//right-front edge
		for(i in 1..(y_max-1)) A(x_max, i, 0)		= A((x_max-1), i, 0);
		//left-back edge
		for(i in 1..(y_max-1)) A(0, i, z_max)		= A(1, i, z_max);
		//right-back edge
		for(i in 1..(y_max-1)) A(x_max, i, z_max)	= A((x_max-1), i, z_max);
		
		
		//z passes
		
		//left-bottom edge
		for(i in 1..(z_max-1)) A(0, 0, i)			= A(1, 0, i);
		//right-bottom edge
		for(i in 1..(z_max-1)) A(x_max, 0, i)		= A((x_max-1), 0, i);
		//top-left edge
		for(i in 1..(z_max-1)) A(0, y_max, i)		= A(1, y_max, i);
		//top-right edge
		for(i in 1..(z_max-1)) A(x_max, y_max, i)	= A((x_max-1), y_max, i);
	}
}
