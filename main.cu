#include "main.cuh"

int main()
{
	printf("This Program Runs EEXIST and trains a bias on a trainer data set provided.\n\n\n");

	//Training Variables
	int* Generations;			//How Many Gnenerations To Do Do
	int* SystemsToRun;			//How Many Systems To Train
	int* GuessesPerGen;			//How Many Times To Let Exist TRy To Guess Image EAch Generation
	int* UpdatesBeforeGuess;	//How Many Times To Update Each System Before Getting Answer From EEXIST
	double* Karma;				//How Many Times To Let Exist TRy To Guess Image EAch Generation
	double* Mutation;			//What Percentage Of Tubes To Make RAndom Vlaue For When Breeding Biases
	int* Breeders;				//How Many
	int* NumOfImages;			//How Mnay Images We Are TRaining Off of
	FImage* Images;				//Image Data
	EReigonType** Reigons;		//Reigon Data (Where To Place Images And Where To Read Output From)

	//Reserve Space On GPU For Training Data (Single VArs Only) (Arrays Will Be Reserved In Future Functions)
	cudaMallocManaged(&Generations, sizeof(int*));
	cudaMallocManaged(&SystemsToRun, sizeof(int*));
	cudaMallocManaged(&GuessesPerGen, sizeof(int*));
	cudaMallocManaged(&UpdatesBeforeGuess, sizeof(int*));
	cudaMallocManaged(&Karma, sizeof(double*));
	cudaMallocManaged(&Mutation, sizeof(double*));
	cudaMallocManaged(&Breeders, sizeof(int*));
	cudaMallocManaged(&NumOfImages, sizeof(int*));

	//Get The TRainer File That Has Data On How To Train
	FILE* Trainer = getTrainerFile();

	//Read InData From That File And Put It Into Our Varaibles
	readTrainerDataFromFile(Trainer, Generations, SystemsToRun, GuessesPerGen, UpdatesBeforeGuess, Karma, Mutation, Breeders, NumOfImages, &Images, &Reigons);

	//Train The AI
	runTrainer(Generations, SystemsToRun, GuessesPerGen, UpdatesBeforeGuess, Karma, Mutation, Breeders, NumOfImages, Images, Reigons);
}