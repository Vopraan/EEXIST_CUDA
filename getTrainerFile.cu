#include "main.cuh"

FILE* getTrainerFile()
{
	char Input[512] = "Train.tr";

	FILE* TrainFile = fopen(Input, "r");

	if (TrainFile != NULL)
	{
		return TrainFile;
	}
	else
	{
        printf("Please Place Trainer File In Current Directory.\n");
        
		return NULL;
	}
}