CCOMP=nvcc
OBJ=../Object/


EEXIST.out: main.o readTrainerDataFromFile.o getTrainerFile.o runTrainer.o applyTubes.o applyBias.o clearBuffer.o updateSystem.o applyBuffer.o breedBiases.o scoreSystem.o output.o
	$(CCOMP) -o ../EEXIST.out $(OBJ)main.o $(OBJ)readTrainerDataFromFile.o $(OBJ)getTrainerFile.o $(OBJ)runTrainer.o $(OBJ)applyTubes.o $(OBJ)applyBias.o $(OBJ)clearBuffer.o $(OBJ)updateSystem.o $(OBJ)applyBuffer.o $(OBJ)breedBiases.o $(OBJ)scoreSystem.o $(OBJ)output.o


main.o: main.cu main.cuh
	$(CCOMP) -c -o $(OBJ)main.o main.cu

getTrainerFile.o: getTrainerFile.cu main.cuh
	$(CCOMP) -c -o $(OBJ)getTrainerFile.o getTrainerFile.cu

readTrainerDataFromFile.o: readTrainerDataFromFile.cu main.cuh
	$(CCOMP) -c -o $(OBJ)readTrainerDataFromFile.o readTrainerDataFromFile.cu

runTrainer.o: runTrainer.cu main.cuh
	$(CCOMP) -c -o $(OBJ)runTrainer.o runTrainer.cu

applyTubes.o: applyTubes.cu main.cuh
	$(CCOMP) -c -o $(OBJ)applyTubes.o applyTubes.cu

applyBias.o: applyBias.cu main.cuh
	$(CCOMP) -c -o $(OBJ)applyBias.o applyBias.cu

clearBuffer.o: clearBuffer.cu main.cuh
	$(CCOMP) -c -o $(OBJ)clearBuffer.o clearBuffer.cu

updateSystem.o: updateSystem.cu main.cuh
	$(CCOMP) -c -o $(OBJ)updateSystem.o updateSystem.cu

applyBuffer.o: applyBuffer.cu main.cuh
	$(CCOMP) -c -o $(OBJ)applyBuffer.o applyBuffer.cu

breedBiases.o: breedBiases.cu main.cuh
	$(CCOMP) -c -o $(OBJ)breedBiases.o breedBiases.cu

scoreSystem.o: scoreSystem.cu main.cuh
	$(CCOMP) -c -o $(OBJ)scoreSystem.o scoreSystem.cu

output.o: output.cu main.cuh
	$(CCOMP) -c -o $(OBJ)output.o output.cu
