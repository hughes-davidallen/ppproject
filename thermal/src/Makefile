HELPERS = InputParser.x10 OutputPrinter.x10

CPPFLAGS = -v -t -optimize -O -NO_CHECKS

all: thermal thermalPar

thermal: thermal.class

runPar: thermalPar
	x10 thermalPar input.txt 7 false

%.class: %.x10
	x10c $<

runSeq: thermal
	x10 thermal input.txt 7 false

runSeq_large: thermal.exe
	salloc -n1 srun.x10sock ./thermal.exe input_large100.txt 100 false

%.exe: %.x10
	x10c++ $(CPPFLAGS) $< -o $@

thermalPar: thermalPar.class

runPar_large: thermalPar.exe
	salloc -n1 srun.x10sock ./thermalPar.exe input_large100.txt 100 false

run: runSeq runPar

run_large: runSeq_large runPar_large

compare: run
	diff output.txt outputPar.txt

clean:
	rm -f *.class *.java *.cc *.h *.exe

.PHONY: thermal runSeq thermalPar runPar run run_large compare clean
