import x10.util.Timer;

public class thermalPlaces2
{
	static val TOP = 0;
	static val BOTTOM = 1;
	static val FRONT = 2;
	static val BACK = 3;
	static val LEFT = 4;
	static val RIGHT = 5;

private static def findRegion(x_size:Int, y_size:Int, z_size:Int, numDivs:Int, div:Int):Region(3)
{
	//needs more variety
	if (div == 0) {
		return 0..(x_size / 2 + 1)*0..(y_size + 1)*0..(z_size + 1);
	} else {
		return (x_size / 2 - 1)..(x_size + 1)*0..(y_size + 1)*0..(z_size + 1);
	}
}

private static def extractRegions(reg:Region(3)):Rail[Array[Double](2)]
{
	val shadows = new Rail[Array[Double](2)](6);
	val xx = reg.max(0);
	val yx = reg.max(1);
	val zx = reg.max(2);
	val xn = reg.min(0);
	val yn = reg.min(1);
	val zn = reg.min(2);

	shadows(TOP) = new Array[Double](xn..xx*zn..zx, 0.0);
	shadows(BOTTOM) = new Array[Double](xn..xx*zn..zx, 0.0);
	shadows(FRONT) = new Array[Double](xn..xx*yn..yx, 0.0);
	shadows(BACK) = new Array[Double](xn..xx*yn..yx, 0.0);
	shadows(LEFT) = new Array[Double](yn..yx*zn..zx, 0.0);
	shadows(RIGHT) = new Array[Double](yn..yx*zn..zx, 0.0);

	return shadows;
}

public static def main(args:Array[String](1)):void
{
	val source = InputParser.parse(args(0));
	val iterations = Int.parse(args(1));
	val num_subDivs = 2;

	val input_reg = source.region;
	val x_size = input_reg.max(0);
	val y_size = input_reg.max(1);
	val z_size = input_reg.max(2);

	val sub_reg = (0..x_size)*(0..y_size)*(0..z_size);

	val regions = new Rail[Region](num_subDivs);
	for (i in 0..(num_subDivs - 1)) {
		regions(i) = findRegion(x_size, y_size, z_size, num_subDivs, i);
	}

	val subdivs:Array[Array[Double](3)](1) = new Array[Array[Double](3)](num_subDivs);
	for (i in 0..(num_subDivs - 1)) {
		subdivs(i) = new Array[Double](regions(i), 0.0);
	}

	val subDiv_out = PlaceLocalHandle.make[Array[Double](3)](Dist.makeUnique(PlaceGroup.WORLD), null);
	val shadow = PlaceLocalHandle.make[Rail[Array[Double](2)]](Dist.makeUnique(PlaceGroup.WORLD), null);
	for (p in Place.places()) {
		at (p) {
			shadow() = extractRegions(regions(p.id));
			subDiv_out() = new Array[Double](regions(p.id), 0.0);
		}
	}

	val outputArray = GlobalRef[Array[Double](3)](new Array[Double](input_reg, 0.0));

	//iterate over subdivisions
	clocked finish for (i in 0..(num_subDivs-1))
	{
		//assign subdivisions to places with asyncs, limit to numplaces
		clocked async at(Place.place(i % numPlaces))
		{
			//create working arrays
			var A:Array[Double](3) = new Array[Double](sub_reg, 0.0);
			var B:Array[Double](3) = new Array[Double](sub_reg, 0.0);

			//create neighbor array
			val neighbors:Rail[Boolean] = new Rail[Boolean](6, true);

			computeNeighbors(i, neighbors, x_divs, y_divs, z_divs);

			// copy input to arrays
			A = subdivs(i);
			B = subdivs(i);

			//do for all iterations
			for(j in 1..iterations)
			{
				// copy out borders to shadow array, pick correct array
				val even = (i % 2 == 0);  //*** could maybe make this a function based on even/odd
				if(even)
					borderFillToShadow(B, x_max_sub, y_max_sub, z_max_sub, shadow, neighbors);
				else
					borderFillToShadow(A, x_max_sub, y_max_sub, z_max_sub, shadow, neighbors);
				
				// blocking clock
				Clock.advanceAll();
	
				// copy required borders from shadow array, pick correct array
				if(even) {
					borderFillFromShadow(A, x_max_sub, y_max_sub, z_max_sub, shadow, neighbors);
					calc(A, B, x_max_sub, y_max_sub, z_max_sub, x_divs, y_divs, z_divs);
					
					//if last iteration
					if(j == (iterations))
						subDiv_out() = A;
				} else {
					borderFillFromShadow(B, x_max_sub, y_max_sub, z_max_sub, shadow, neighbors);
					calc(B, A, x_max_sub, y_max_sub, z_max_sub, x_divs, y_divs, z_divs);
					
					//if last iteration
					if(j == (iterations))
						subDiv_out() = B;
				}
			}
		}
	}

	// copy each subdiv into output array
	for(i in 0..num_subDivs)
	{
		//basically invert process that did subdivisions
		at(Place.place(i % numPlaces)) 
		{
			//Do this better
			for ([i,j,k] in subDiv_out())
				outputArray(i, j, k) = subDiv_out(i, j, k);
		}
	}

	/* STOP TIMING */
	val stoptime = Timer.milliTime() - starttime;

	//DONE
	Console.OUT.println("DONE in " + stoptime + " milliseconds");
	//Print final results to output file
	OutputPrinter.printm("outputPar.txt", outputArray );
}

public static def computeNeighbors(i:Int, neighbors:Rail[Boolean], x_divs:Int, y_divs:Int, z_divs:Int)
{
	/* 
	 * Mapping of indices to faces:
	 * 0: Top		4: Left
	 * 1: Bottom	5: Right
	 * 2: Front
	 * 3: Back
	 */

	//checking if along right and left sides of cube
	val xpos = i % x_divs;
	if(xpos == x_divs-1) {
		neighbors(RIGHT) = false;
	} else if((i%x_divs) == 0) {
		neighbors(LEFT) = false;
	}

	//checking if along top and bottom sides of cube
	val ypos = (i / y_divs) % y_divs;
	if(ypos == y_divs-1) {
		neighbors(TOP) = false;
	} else if (ypos == 0) {
		neighbors(BOTTOM) = false;
	}

	//checking if along back and front sides of cube
	val zpos = ((i / y_divs) / z_divs) % z_divs;
	if(zpos == z_divs-1) {
		neighbors(BACK) = false;
	} else if (zpos == 0) {
		neighbors(FRONT) = false;
	}
}

//depending on how shadow is implemented, this will need to be tweaked to make
//sure we're writing to the correct places
public static def borderFillToShadow(A:Array[Double](3), x_max:Int, y_max:Int,
									z_max:Int, shadow:Rail[Array[Double](2)],
									neighbors:Rail[Boolean])
{
	//top
	if(neighbors(0)) {
		for (i in 0..x_max)
			for (k in 0..z_max) ((shadow())(0))(i,k) = A(i, y_max, k);
	}

	//bottom
	if(neighbors(1)) {
		for (i in 0..x_max)
			for (k in 0..z_max) ((shadow())(1))(i,k) = A(i, 0, k);
	}

	//front
	if(neighbors(2)) {
		for (i in 0..x_max)
			for (j in 0..y_max) ((shadow())(2))(i,j) = A(i, j, 0);
	}

	//back
	if(neighbors(3)) {
		for (i in 0..x_max)
			for (j in 0..y_max) ((shadow())(3))(i,j) = A(i, j, z_max);
	}

	//left
	if(neighbors(4)) {
		for (j in 0..y_max)
			for (k in 0..z_max) ((shadow())(4))(j,k) = A(0, j, k);
	}

	//right
	if(neighbors(5)) {
		for (j in 0..y_max)
			for (k in 0..z_max) ((shadow())(5))(j,k) = A(x_max, j, k);
	}
}

//depending on how shadow is implemented, this will need to be tweaked to make
//sure we're reading from the correct places
public static def borderFillFromShadow(A:Array[Double](3), x_max:Int, y_max:Int,
									z_max:Int, shadow:Rail[Array[Double](2)],
									neighbors:Rail[Boolean])
{
	//Top and Bottom
	for (i in 0..x_max)
		for (j in 0..y_max) {
			//top
			A(i, j, 0) = (shadow(0))(i, j);

			//bottom
			A(i, j, z_max) = (shadow(1))(i, j);
		}

	//Front and Back
	for (i in 1..x_max)
		for (k in 1..z_max) {
			//front
			A(i, 0, k) = (shadow(2))(i, k);

			//back
			A(i, y_max, k) = (shadow(3))(i, k);
		}

	//Left and Right
	for (j in 1..y_max)
		for (k in 1..z_max) {
			//left
			A(0, j, k) = (shadow(4))(j, k);

			//right
			A(x_max, j, k) = (shadow(5))(j, k);
		}

}

//so far unchanged from thermalPar
public static def calc(A1:Array[Double](3), A2:Array[Double](3),
						x_size:Int, y_size:Int, z_size:Int,
						x_divs:Int, y_divs:Int, z_divs:Int)
{
	var zcount:Int = 0;
	val xlen = x_size / x_divs;
	val ylen = y_size / y_divs;
	val zlen = z_size / z_divs;
	finish for (x in 0..(x_divs - 1)) async {
		for (y in 0..(y_divs - 1)) async {
			for (z in 0..(z_divs - 1)) async {
				val xstart = x * xlen + 1;
				val xend = (x == (x_divs - 1))?x_size:xstart + xlen - 1;
				for (i in xstart..xend) {
					val ystart = y * xlen + 1;
					val yend = (y == (y_divs - 1))?y_size:ystart + ylen - 1;
					for (j in ystart..yend) {
						val zstart = z * zlen + 1;
						val zend = (z == (z_divs - 1))?z_size:zstart + zlen - 1;
						for (k in zstart..zend) {
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
		}
	}
}

}
