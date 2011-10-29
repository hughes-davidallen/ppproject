.PHONY: thermal
thermal: thermal.class

thermal.class: thermal.x10 InputParser.x10 OutputPrinter.x10
	x10c thermal.x10

run: thermal
	x10 thermal input.txt

.PHONY: clean
clean:
	rm -f *.class *.java
