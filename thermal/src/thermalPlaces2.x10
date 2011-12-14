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
		return (x_size / 2)..(x_size + 1)*0..(y_size + 1)*0..(z_size + 1);
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

	/*
	 * Shadow arrays should have same coordinates as the working arrays
	 * to which they correspond
	 */
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
	val numPlaces = Place.numPlaces();

	val input_reg = source.region;
	val x_size = input_reg.max(0);
	val y_size = input_reg.max(1);
	val z_size = input_reg.max(2);

	val x_divs = 2;
	val y_divs = 1;
	val z_divs = 1;

	val regions = new Rail[Region](num_subDivs);
	for (i in 0..(num_subDivs - 1)) {
		regions(i) = findRegion(x_size, y_size, z_size, num_subDivs, i);
	}

	val subdivs:Array[Array[Double](3)](1) = new Array[Array[Double](3)](num_subDivs);
	for (n in 0..(num_subDivs - 1)) {
		subdivs(n) = new Array[Double](regions(n));
		val x_min = regions(n).min(0) + 1;
		val x_max = regions(n).max(0) - 1;
		val y_min = regions(n).min(1) + 1;
		val y_max = regions(n).max(1) - 1;
		val z_min = regions(n).min(2) + 1;
		val z_max = regions(n).max(2) - 1;

		for (i in x_min..x_max)
			for (j in y_min..y_max)
				for(k in z_min..z_max)
					subdivs(n)(i, j, k) = source(i, j, k);
	}

	val subDiv_out = PlaceLocalHandle.make[Rail[Array[Double](3)]](Dist.makeUnique(PlaceGroup.WORLD), ()=>new Rail[Array[Double](3)](1));
	val shadow = PlaceLocalHandle.make[Rail[Rail[Array[Double](2)]]](Dist.makeUnique(PlaceGroup.WORLD), ()=>new Rail[Rail[Array[Double](2)]](1));
	for (p in Place.places()) {
		at (p) {
			shadow()(0) = extractRegions(regions(p.id));
			subDiv_out()(0) = new Array[Double](regions(p.id), 0.0);
		}
	}

	val outputArray = new GlobalRef[Array[Double](3)](new Array[Double](input_reg, 0.0));

	//This may be the wrong place to start timing
	val starttime = Timer.milliTime();

	//iterate over subdivisions
	clocked finish for (i in 0..(num_subDivs - 1))
	{
		//assign subdivisions to places with asyncs, limit to numplaces
		clocked async at (Place.place(i % numPlaces))
		{
			//create working arrays
			var A:Array[Double](3) = new Array[Double](regions(i), 0.0);
			var B:Array[Double](3) = new Array[Double](regions(i), 0.0);

			//create neighbor array
			val neighbors:Rail[Boolean] = new Rail[Boolean](6, true);

			computeNeighbors(i, neighbors, x_divs, y_divs, z_divs);
			Console.OUT.println("Outside the function: " + neighbors);

			// copy input to arrays
			Array.copy(subdivs(i), B);

			//do for all iterations
			for (j in 1..iterations)
			{
				Console.OUT.println("This has run " + j);
				// copy out borders to shadow array, pick correct array
				borderFillLocal(A);
				borderFillLocal(B);
				val even = (j % 2 == 0);  //*** could maybe make this a function based on even/odd
				if (even) {
					borderFillToShadow(A, shadow()(0), neighbors);
				} else {
					borderFillToShadow(B, shadow()(0), neighbors);
				}

				// blocking clock
				Clock.advanceAll();
	
				// copy required borders from shadow array, pick correct array
				if (even) {
					borderFillFromShadow(A, shadow, neighbors, x_divs, y_divs, z_divs);
					calc(A, B, x_divs, y_divs, z_divs);
					
					//if last iteration
					if (j == (iterations))
						subDiv_out()(0) = B;
				} else {
					borderFillFromShadow(B, shadow, neighbors, x_divs, y_divs, z_divs);
					Console.OUT.println("Left: " + shadow()(0)(LEFT)(6, 6));
					Console.OUT.println("Right: " + shadow()(0)(RIGHT)(6, 6));
					calc(B, A, x_divs, y_divs, z_divs);
					
					//if last iteration
					if (j == (iterations))
						subDiv_out()(0) = A;
				}

				Clock.advanceAll();
			}
		}
	}

	// copy each subdiv into output array
	for (n in 0..(num_subDivs - 1)) //iterate with n to avoid name conflict
	{
		//basically invert process that did subdivisions
		at (Place.place(n % numPlaces)) 
		{
			val R = subDiv_out()(0).region;
			val x_min = R.min(0) + 1;
			val x_max = R.max(0) - 1;
			val y_min = R.min(1) + 1;
			val y_max = R.max(1) - 1;
			val z_min = R.min(2) + 1;
			val z_max = R.max(2) - 1;

			val temp = subDiv_out()(0);

			at (outputArray.home) {
				for (i in x_min..x_max)
					for (j in y_min..y_max)
						for (k in z_min..z_max)
							outputArray()(i, j, k) = temp(i, j, k);
			}
		}
	}

	/* STOP TIMING */
	val stoptime = Timer.milliTime() - starttime;

	//DONE
	Console.OUT.println("DONE in " + stoptime + " milliseconds");
	//Print final results to output file
	OutputPrinter.printm("outputPlaces.txt", outputArray());
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
	if (xpos == x_divs-1) {
		neighbors(RIGHT) = false;
	}
	if(xpos == 0) {
		neighbors(LEFT) = false;
	}

	//checking if along top and bottom sides of cube
	val ypos = (i / y_divs) % y_divs;
	if (ypos == y_divs-1) {
		neighbors(TOP) = false;
	}
	if (ypos == 0) {
		neighbors(BOTTOM) = false;
	}

	//checking if along back and front sides of cube
	val zpos = ((i / y_divs) / z_divs) % z_divs;
	if (zpos == z_divs-1) {
		neighbors(BACK) = false;
	}
	if (zpos == 0) {
		neighbors(FRONT) = false;
	}

	Console.OUT.println("Place " + here.id + ": " + neighbors);
}

public static def borderFillLocal(A:Array[Double](3))
{
	val reg = A.region;
	val x_min = reg.min(0) + 1;
	val x_max = reg.max(0) - 1;
	val y_min = reg.min(1) + 1;
	val y_max = reg.max(1) - 1;
	val z_min = reg.min(2) + 1;
	val z_max = reg.max(2) - 1;

	for (i in x_min..x_max)
		for (j in y_min..y_max) {
			A(i, j, z_min - 1) = A(i, j, z_min);
			A(i, j, z_max + 1) = A(i, j, z_max);
		}
	for (j in y_min..y_max)
		for (k in z_min..z_max) {
			A(x_min - 1, j, k) = A(x_min, j, k);
			A(x_max + 1, j, k) = A(x_max, j, k);
		}
	for (i in x_min..x_max)
		for (k in z_min..z_max) {
			A(i, y_min - 1, k) = A(i, y_min, k);
			A(i, y_max + 1, k) = A(i, y_max, k);
		}
			
}

//depending on how shadow is implemented, this will need to be tweaked to make
//sure we're writing to the correct places
public static def borderFillToShadow(A:Array[Double](3), shadow:Rail[Array[Double](2)], neighbors:Rail[Boolean])
{
	val reg = A.region;
	val x_min = reg.min(0);
	val x_max = reg.max(0);
	val y_min = reg.min(1);
	val y_max = reg.max(1);
	val z_min = reg.min(2);
	val z_max = reg.max(2);

	//top
	if(neighbors(TOP)) {
		for (i in x_min..x_max)
			for (k in z_min..z_max) (shadow(TOP))(i,k) = A(i, y_max, k);
	}

	//bottom
	if(neighbors(BOTTOM)) {
		for (i in x_min..x_max)
			for (k in z_min..z_max) (shadow(BOTTOM))(i,k) = A(i, y_min, k);
	}

	//front
	if(neighbors(FRONT)) {
		for (i in x_min..x_max)
			for (j in y_min..y_max) (shadow(FRONT))(i,j) = A(i, j, z_min);
	}

	//back
	if(neighbors(BACK)) {
		for (i in x_min..x_max)
			for (j in y_min..y_max) (shadow(BACK))(i,j) = A(i, j, z_max);
	}

	//left
	if(neighbors(LEFT)) {
		Console.OUT.println("Filling to the LEFT border of place " + here.id);
		for (j in y_min..y_max)
			for (k in z_min..z_max) {
				(shadow(LEFT))(j,k) = A(x_min, j, k);
				Console.OUT.println(shadow(LEFT)(j, k));
			}
	}

	//right
	if(neighbors(RIGHT)) {
		Console.OUT.println("Filling to the RIGHT border of place " + here.id);
		for (j in y_min..y_max)
			for (k in z_min..z_max) (shadow(RIGHT))(j,k) = A(x_max, j, k);
	}
}

//depending on how shadow is implemented, this will need to be tweaked to
//make sure we're reading from the correct places
public static def borderFillFromShadow(A:Array[Double](3), shadow:PlaceLocalHandle[Rail[Rail[Array[Double](2)]]], neighbors:Rail[Boolean], x_divs:Int, y_divs:Int, z_divs:Int)
{
	val reg = A.region;
	val x_min = reg.min(0);
	val x_max = reg.max(0);
	val y_min = reg.min(1);
	val y_max = reg.max(1);
	val z_min = reg.min(2);
	val z_max = reg.max(2);

	val GR = new GlobalRef[Array[Double](3)](A);

	if (neighbors(TOP)) at (here.next(x_divs)) {
		val shad = shadow()(0)(BOTTOM);
		at (GR.home) {
			for (i in x_min..x_max)
				for (k in z_min..z_max)
					GR()(i, y_max, k) = shad(i, k);
		}
	}

	if (neighbors(BOTTOM)) at (here.prev(x_divs)) {
		val shad = shadow()(0)(TOP);
		at (GR.home) {
			for (i in x_min..x_max)
				for (k in z_min..z_max)
					GR()(i, y_min, k) = shad(i, k);
		}
	}

	if (neighbors(FRONT)) at (here.prev(x_divs * y_divs)) {
		for (i in x_min..x_max)
			for (j in z_min..z_max)
				A(i, j, z_min) = shadow()(0)(BACK)(i, j);
	}

	if (neighbors(BACK)) at (here.next(x_divs * y_divs)) {
		for (i in x_min..x_max)
			for (j in z_min..z_max)
				A(i, j, z_max) = shadow()(0)(FRONT)(i, j);
	}

	if (neighbors(LEFT)) at (here.prev()) {
		Console.OUT.println("Filling from the LEFT border of place " + here.id);
		val shad = shadow()(0)(RIGHT);
		at (GR.home) {
			for (j in y_min..y_max)
				for (k in z_min..z_max)
					GR()(x_min, j, k) = shad(j, k);
		}
	}

	if (neighbors(RIGHT)) at (here.next()) {
		Console.OUT.println("Filling from the RIGHT border of place " + here.id);
		val shad = shadow()(0)(LEFT);
		at (GR.home) {
			for (j in y_min..y_max)
				for (k in z_min..z_max) {
					A(x_max, j, k) = shad(j, k);
					Console.OUT.println(A(x_max, j, k));
				}
		}
	}
}

//This method is called once per place per iteration
public static def calc(A1:Array[Double](3), A2:Array[Double](3), x_divs:Int, y_divs:Int, z_divs:Int)
{
/* PLEASE CHECK FENCE POSTS */
	val reg = A1.region;
	val x_min = reg.min(0) + 1;
	val x_max = reg.max(0) - 1;
	val y_min = reg.min(1) + 1;
	val y_max = reg.max(1) - 1;
	val z_min = reg.min(2) + 1;
	val z_max = reg.max(2) - 1;

	val x_size = x_max - x_min + 1;
	val y_size = y_max - y_min + 1;
	val z_size = z_max - z_min + 1;

	val xlen = x_size / x_divs;
	val ylen = y_size / y_divs;
	val zlen = z_size / z_divs;
	finish for (x in 0..(x_divs - 1)) async {
		for (y in 0..(y_divs - 1)) async {
			for (z in 0..(z_divs - 1)) async {
				val xstart = x * xlen + x_min;
				val xend = (x == (x_divs - 1))?x_max:xstart + xlen - 1;
				for (i in xstart..xend) {
					val ystart = y * ylen + y_min;
					val yend = (y == (y_divs - 1))?y_max:ystart + ylen - 1;
					for (j in ystart..yend) {
						val zstart = z * zlen + z_min;
						val zend = (z == (z_divs - 1))?z_max:zstart + zlen - 1;
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
