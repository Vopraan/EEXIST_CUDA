
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <curand.h>
#include <curand_kernel.h>
#include <unistd.h>

#include <stdio.h>
#include <stdlib.h>

#define SIZE 512

//REigon Types For Tubes
enum EReigonType
{
	Input,
	Compute,
	Output0,
	Output1,
	Output2,
	Output3
};

//Tube Structure Holds 4 Diffrent Chemical VAlues Representing a Tube In A System
struct FTube
{
	double SrcX = 0.0f;
	double SrcY = 0.0f;

	double DesX = 0.0f;
	double DesY = 0.0f;
};

//Holds a Bias Value For One Tube Of A System
struct FBias
{
	int SrcX = 0.0f;
    int SrcY = 0.0f;
    
    int DesX = 0.0f;
	int DesY = 0.0f;
};

//Stores All Data For A System (Tubes And Bias)
struct FSystem
{
	//Chem Values At Each Point
	FTube Tubes[SIZE][SIZE];

	//Bias Offsets For Diffrent Chems
	FBias Bias[SIZE][SIZE];

	int CorrectGuesses = 0;
};

//Store An Image And The Correct Answer To An Image
struct FImage
{
	int x = 0;
	int y = 0;

	FTube Pixels[SIZE][SIZE];

	int CorrectIdentification = 0;
};

//General Functions Declarayions
FILE* getTrainerFile();
void readTrainerDataFromFile(FILE* File, int* Generations, int* SystemsToRun, int* GuessesPerGen, int* UpdatesBeforeGuess, double* Karma, double* Mutation, int* Breeders, int* NumOfImages, FImage** Images, EReigonType*** Reigons);
void runTrainer(int* Generations, int* SystemsToRun, int* GuessesPerGen, int* UpdatesBeforeGuess, double* Karma, double* Mutation, int* Breeders, int* NumOfImages, FImage* Images, EReigonType** Reigons);
void scoreSystem(FSystem* System, EReigonType** Reigons, FImage* ImageUsed);
void output(FILE* file, FSystem* Systems, int* SystemsToRun, int Gen, int NumOfGuesses);


//Cuda Function Declarations
__global__
void applyTubes(FSystem* System, int Index, EReigonType** Reigons, FImage* Images, int* NumOfImages, int* ImageUsed);
__global__
void applyBias(FSystem* System, FBias** LatestBias, double* Mutation, int gen);
__global__
void clearBuffer(FTube** Buffer);
__global__ 
void updateSystem(FSystem* System, double* Karma, FTube** Buffer, double delta);
__device__ 
void GetChemToTake(double Karma, double KarmaDistance, double CurrentChemLevel, double TargetChemLevel, double* TargetAmountToTake);
__global__ 
void applyBuffer(FSystem* System, FTube** Buffer);
__global__
void breedBiases(FSystem* Systems, int* NumOfSystems, FBias** OutBias, int* Breeders, int* TopPerformers);