HELPERS = InputParser.x10 OutputPrinter.x10

CPPFLAGS = -v -t -optimize -O -NO_CHECKS

all: thermal thermalPar

.PHONY: thermal
thermal: thermal.class

thermal.class: thermal.x10 $(HELPERS)
	x10c thermal.x10

.PHONY: runSeq
runSeq: thermal
	x10 thermal input.txt 7 false

runSeq_large: thermal.exe
	./thermal.exe input_large100.txt 100 false

thermal.exe: thermal.x10 $(HELPERS)
	x10c++ thermal.x10 -o thermal.exe

.PHONY: thermalPar
thermalPar: thermalPar.class

thermalPar.class: thermalPar.x10 $(HELPERS)
	x10c thermalPar.x10

.PHONY: runPar
runPar: thermalPar
	x10 thermalPar input.txt 7 false

runPar_large: thermalPar.exe
	./thermalPar.exe input_large100.txt 100 false

thermalPar.exe: thermalPar.x10 $(HELPERS)
	x10c++ thermalPar.x10 $(CPPFLAGS) -o thermalPar.exe

.PHONY: run
run: runSeq runPar

.PHONY: run_large
run_large: runSeq_large runPar_large

.PHONY: compare
compare: run_large
	diff output.txt outputPar.txt

.PHONY: clean
clean:
	rm -f *.class *.java *.cc *.h *.exe
