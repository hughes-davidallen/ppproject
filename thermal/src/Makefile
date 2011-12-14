HELPERS = InputParser.x10 OutputPrinter.x10

CPPFLAGS = -v -t -optimize -O -NO_CHECKS

all: thermal thermalPar

thermal: thermal.class

thermalPar: thermalPar.class

thermalPlaces2: thermalPlaces2.class

%.class: %.x10
	x10c $<

runSeq_large: thermal.exe
	salloc -n1 srun.x10sock ./$< input_large100.txt 100 false

runPar_large: thermalPar.exe
	salloc -n1 srun.x10sock ./$< input_large100.txt 100 false

runPlaces_large: thermalPlaces2.exe
	salloc -n8 srun.x10sock ./$< input_large100.txt 100

%.exe: %.x10
	x10c++ $(CPPFLAGS) $< -o $@

runSeq: thermal
	x10 $< input_large10.txt 1 false

runPar: thermalPar
	x10 $< input_large10.txt 1 false

runPlaces: thermalPlaces2
	x10 $< input_large10.txt 1

run: runSeq runPlaces

run_large: runSeq_large runPlaces_large

compare: run_large
	diff output.txt outputPlaces.txt

clean:
	rm -f *.class *.java *.cc *.h *.exe

.PHONY: thermal runSeq thermalPar runPar run run_large compare clean
