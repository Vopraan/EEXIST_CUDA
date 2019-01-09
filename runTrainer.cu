#include "main.cuh"

void runTrainer(int* Generations, int* SystemsToRun, int* GuessesPerGen, int* UpdatesBeforeGuess, double* Karma, double* Mutation, int* Breeders, int* NumOfImages, FImage* Images, EReigonType** Reigons)
{
	//Reserve Sapce For Systems
	FSystem* Systems;
	cudaMallocManaged(&Systems, sizeof(FSystem) * (*SystemsToRun));

	//Reserve Sapce For Bias
	FBias** Bias;
	cudaMallocManaged(&Bias, sizeof(FBias*) * SIZE);
	for(int i = 0; i < SIZE; i++)
	{
		cudaMallocManaged(&Bias[i], sizeof(FBias) * SIZE);
	}

	//Reserve Sapce For Buffer
	FTube** Buffer;
	cudaMallocManaged(&Buffer, sizeof(FTube*) * SIZE);
	for(int i = 0; i < SIZE; i++)
	{
		cudaMallocManaged(&Buffer[i], sizeof(FTube) * SIZE);
	}

	int* ImageUsed;
	cudaMallocManaged(&ImageUsed, sizeof(int));

	int* TopPerformers;
	cudaMallocManaged(&TopPerformers, *SystemsToRun * sizeof(int));


	//Iterate Through Gens
	for (int Gen = 1; Gen <= *Generations; Gen++)
	{
		printf("Gen: %d\n\n", Gen);

		for(int SysIndex = 0; SysIndex < *SystemsToRun; SysIndex++)
		{
			printf("SYS: %d\n", SysIndex);

			int test = rand() % 512;

			//Apply Bias
			applyBias <<< SIZE, SIZE >>> (&Systems[SysIndex], Bias, Mutation, Gen);
			cudaDeviceSynchronize();

			for(int Tests = 0; Tests < *GuessesPerGen; Tests++)
			{
				*ImageUsed = 0;

				applyTubes <<< SIZE, SIZE >>> (Systems, SysIndex, Reigons, Images, NumOfImages, ImageUsed);
				cudaDeviceSynchronize();

				//Iterate Though work updates
				for (int Update = 1; Update <= *UpdatesBeforeGuess; Update++)
				{
					//Clear Buffer
					clearBuffer <<< SIZE, SIZE >>> (Buffer);
					cudaDeviceSynchronize();

					//Update System 
					updateSystem <<< SIZE, SIZE >>> (&Systems[SysIndex], Karma, Buffer, 10);
					cudaDeviceSynchronize();

					
				}
			}

			//Score This Systems Bias
			scoreSystem(&Systems[SysIndex], Reigons, &Images[*ImageUsed]);
		}

		//Take Top Bias And Breed Them To Produce One New Bias Without Mutation
		breedBiases <<< SIZE, SIZE >>> (Systems, SystemsToRun, Bias, Breeders, TopPerformers);
		cudaDeviceSynchronize();

		if((Gen - 1) % 10 == 0)
		{
			//char end[100];
			//sprintf(end, "%d", Gen);

			//char out[100] = "output";

			//strcat(out, end);
			//FILE* file = fopen(out, "w");
			//if(file != NULL)
			//{
				//output(file, Systems, SystemsToRun, Gen, *GuessesPerGen);
			//}
			//fclose(file);
		}
	}
}

/*
					for(int y = 0; y < 10; y++)
					{
						for(int x = 0; x < 10; x++)
						{
							printf("%3.0lf %3.0lf %3.0lf %3.0lf  ", Systems[SysIndex].Tubes[x][y].SrcX, Systems[SysIndex].Tubes[x][y].SrcY, Systems[SysIndex].Tubes[x][y].DesX, Systems[SysIndex].Tubes[x][y].DesY);
			
						}
						printf("\n");
					}
					printf("\n");

#include "main.cuh"

void runTrainer(int* Generations, int* SystemsToRun, int* GuessesPerGen, int* UpdatesBeforeGuess, double* Karma, double* Mutation, int* Breeders, int* NumOfImages, FImage* Images, EReigonType** Reigons)
{
	//Reserve Sapce For Systems
	FSystem* Systems;
	cudaMallocManaged(&Systems, sizeof(FSystem) * (*SystemsToRun));

	//Reserve Sapce For Bias
	FBias** Bias;
	cudaMallocManaged(&Bias, sizeof(FBias*) * SIZE);
	for(int i = 0; i < SIZE; i++)
	{
		cudaMallocManaged(&Bias[i], sizeof(FBias) * SIZE);
	}

	//Reserve Sapce For Buffer
	FTube** Buffer;
	cudaMallocManaged(&Buffer, sizeof(FTube*) * SIZE);
	for(int i = 0; i < SIZE; i++)
	{
		cudaMallocManaged(&Buffer[i], sizeof(FTube) * SIZE);
	}

	int* ImageUsed;
	cudaMallocManaged(&ImageUsed, sizeof(int));
	int* TopPerformers;
	cudaMallocManaged(&TopPerformers, *SystemsToRun * sizeof(int));

	//Iterate Through Gens
	for (int Gen = 1; Gen <= *Generations; Gen++)
	{
		// Error code to check return values for CUDA calls
		cudaError_t err = cudaSuccess;

		printf("Gen: %d\n\n", Gen);

		//Iterate Through Systems Testing
		for (int System = 0; System < *SystemsToRun; System++)
		{
			printf("    System: %d\n", System);

			Systems[System].CorrectGuesses = 0;

			//Apply Bias
			//applyBias <<< SIZE, SIZE >>> (&Systems[System], Bias, Mutation, Gen);
			//cudaDeviceSynchronize();
			err = cudaGetLastError();

			if (err != cudaSuccess)
			{
				fprintf(stderr, "Failed to launch Apply Bias kernel (error code %s)!\n", cudaGetErrorString(err));
				//exit(EXIT_FAILURE);
			}

			//Iterate Through Number Of Times To Test Bias
			for (int Tests = 1; Tests <= *GuessesPerGen; Tests++)
			{
				//Apply Tubes With RAndomly Selected Image
				applyTubes <<< SIZE, SIZE >>> (Systems, System, Reigons, Images, NumOfImages, ImageUsed);
				cudaDeviceSynchronize();
				err = cudaGetLastError();

				*ImageUsed = rand() % *NumOfImages;

				if (err != cudaSuccess)
				{
					fprintf(stderr, "Failed to launch Apply Tubes kernel (error code %s)!\n", cudaGetErrorString(err));
					//exit(EXIT_FAILURE);
				}

				//Iterate Though work updates
				for (int Update = 1; Update <= *UpdatesBeforeGuess; Update++)
				{
					//Clear Buffer
					clearBuffer <<< SIZE, SIZE >>> (Buffer);
					cudaDeviceSynchronize();
					err = cudaGetLastError();

					if (err != cudaSuccess)
					{
						fprintf(stderr, "Failed to launch Clear kernel (error code %s)!\n", cudaGetErrorString(err));
						//exit(EXIT_FAILURE);
					}

					printf("Bias\n");
					for(int y = 0; y < 10; y++)
					{
						for(int x = 0; x < 10; x++)
						{
							printf("%3d %3d %3d %3d  ", Bias[x][y].SrcX, Bias[x][y].SrcY, Bias[x][y].DesX, Bias[x][y].DesY);
						}
						printf("\n");
					}

					printf("Tubes\n   ");
					for(int y = 0; y < 10; y++)
					{
						for(int x = 0; x < 10; x++)
						{
							printf("%3.0lf %3.0lf %3.0lf %3.0lf  ", Systems[System].Tubes[x][y].SrcX, Systems[System].Tubes[x][y].SrcY, Systems[System].Tubes[x][y].DesX, Systems[System].Tubes[x][y].DesY);
						}
						printf("\n   ");
					}

					printf("Buffer\n      ");
					for(int y = 0; y < 10; y++)
					{
						for(int x = 0; x < 10; x++)
						{
							printf("%3.0lf %3.0lf %3.0lf %3.0lf  ", Buffer[x][y].SrcX, Buffer[x][y].SrcY, Buffer[x][y].DesX, Buffer[x][y].DesY);
						}
						printf("\n      ");
					}
				
					//Update System 
					updateSystem <<< SIZE, SIZE >>> (&Systems[System], Karma, Buffer, 10);
					cudaDeviceSynchronize();
					err = cudaGetLastError();

					if (err != cudaSuccess)
					{
						fprintf(stderr, "Failed to launch Update kernel (error code %s)!\n", cudaGetErrorString(err));
						//exit(EXIT_FAILURE);
					}
				
					//Apply Buffer
					applyBuffer <<< SIZE, SIZE >>> (&Systems[System], Buffer);
					cudaDeviceSynchronize();
					err = cudaGetLastError();

					if (err != cudaSuccess)
					{
						fprintf(stderr, "Failed to launch Apply kernel (error code %s)!\n", cudaGetErrorString(err));
						//exit(EXIT_FAILURE);
					}
				}

				//Score This Systems Bias
				scoreSystem(&Systems[System], Reigons, &Images[*ImageUsed]);
			}
		}

		//Take Top Bias And Breed Them To Produce One New Bias Without Mutation
		//breedBiases <<< SIZE, SIZE >>> (Systems, SystemsToRun, Bias, Breeders, TopPerformers);
		//cudaDeviceSynchronize();


	}
}
*/