public class thermal {
	static val n = 3;
	static val epsilon = 1.0e-5;

	static val BigD = new Array[Region(1){self.rect}][0..n+1, 0..n+1] as Region(2);
	static val D = new Array[Region(1){self.rect}][1..n, 1..n] as Region(2);
	static val LastRow = new Array[Region(1){self.rect}][0..0, 1..n] as Region(2);
	static val A = new Array[Double](BigD,(p:Point)=>{ LastRow.contains(p) ? 1.0 : 0.0 });
	static val Temp = new Array[Double](BigD,(p:Point(BigD.rank))=>{ A(p) });

	def stencil_1([x,y]:Point(2)): Double {
		return (A(x-1,y) + A(x+1,y) + A(x,y-1) + A(x,y+1)) / 4;
	}

	def run() {
		var delta:Double = 1.0;
		do {
			for (p in D) Temp(p) = stencil_1(p);

			delta = A.map[Double,Double](Temp, (x:Double,y:Double)=>Math.abs(x-y)).reduce(Math.max.(Double,Double), 0.0);

			for (p in D) A(p) = Temp(p);
		} while (delta > epsilon);
	}
	
	def prettyPrintResult() {
		for ([i] in A.region.projection(0)) {
			for ([j] in A.region.projection(1)) {
				val pt = Point.make(i,j);
				val tmp = A(pt);
				Console.OUT.printf("%1.4f ",tmp);
			}
			Console.OUT.println();
		}
	}

	public static def main(Array[String]) {
		Console.OUT.println("HeatTransfer Tutorial example with n="+n+" and epsilon="+epsilon);
		Console.OUT.println("Initializing data structures");
		val s = new HeatTransfer_v0();
		Console.OUT.print("Beginning computation...");
		val start = System.nanoTime();
		s.run();
		val stop = System.nanoTime();
		Console.OUT.printf("...completed in %1.3f seconds.\n", ((stop-start) as double)/1e9);
		s.prettyPrintResult();
	}
}