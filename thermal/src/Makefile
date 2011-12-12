HELPERS = InputParser.x10 OutputPrinter.x10

CPPFLAGS = -v -t -optimize -O -NO_CHECKS

all: thermal thermalPar

thermal: thermal.class

thermalPar: thermalPar.class

thermalPlaces: thermalPlaces.class

%.class: %.x10
	x10c $<

runSeq_large: thermal.exe
	salloc -n1 srun.x10sock ./$< input_large100.txt 100 false

runPar_large: thermalPar.exe
	salloc -n1 srun.x10sock ./$< input_large100.txt 100 false

runPlaces_large: thermalPlaces.exe
	salloc -n1 srun.x10sock ./$< input_large100.txt 100 false

%.exe: %.x10
	x10c++ $(CPPFLAGS) $< -o $@

run: thermal
	x10 $< input.txt 7 false

runPar: thermalPar
	x10 $< input.txt 7 false

runPlaces: thermalPlaces
	x10 $< input.txt 7 false

run: runSeq runPlaces

run_large: runSeq_large runPlaces_large

compare: run
	diff output.txt outputPlaces.txt

clean:
	rm -f *.class *.java *.cc *.h *.exe

.PHONY: thermal runSeq thermalPar runPar run run_large compare clean
