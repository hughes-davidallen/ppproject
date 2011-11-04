.PHONY: thermal
thermal: thermal.class

thermal.class: thermal.x10 InputParser.x10 OutputPrinter.x10
	x10c thermal.x10

run: thermal
	x10 thermal input.txt 7 true

run_large: thermal.exe
	./thermal.exe input_large100.txt 100 false

thermal.exe: thermal.x10
	x10c++ thermal.x10 -o thermal.exe

.PHONY: clean
clean:
	rm -f *.class *.java *.cc *.h *.exe
