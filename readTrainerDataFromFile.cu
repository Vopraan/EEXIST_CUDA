#include "main.cuh"

void readTrainerDataFromFile(FILE* File, int* Generations, int* SystemsToRun, int* GuessesPerGen, int* UpdatesBeforeGuess, double* Karma, double* Mutation, int* Breeders, int* NumOfImages, FImage** Images, EReigonType*** Reigons)
{
    //Get Number Of Generations
	char NumOfGenerations[10];
	fgets(NumOfGenerations, 10, File);
	sscanf(NumOfGenerations, "%d", Generations);

	//Get Systems To Run
	char Systems[10];
	fgets(Systems, 10, File);
    sscanf(Systems, "%d", SystemsToRun);
    
	//Get Amount Of Times To Trial Each Bias Each Genrations
	char NumOfTrials[10];
	fgets(NumOfTrials, 10, File);
	sscanf(NumOfTrials, "%d", GuessesPerGen);

	//Get Runs Before ASking For Guess
	char RunsBeforeAsking[10];
	fgets(RunsBeforeAsking, 10, File);
    sscanf(RunsBeforeAsking, "%d", UpdatesBeforeGuess);
    
    //Get Karma
	char KarmaGet[32];
	fgets(KarmaGet, 32, File);
    sscanf(KarmaGet, "%lf", Karma);
    
    //Get Mutation Rate
	char MutationRate[32];
	fgets(MutationRate, 32, File);
    sscanf(MutationRate, "%lf", Mutation);
    
    //Get Number Of Biases To Select For Breeding
	char NumOfBreeders[10];
	fgets(NumOfBreeders, 10, File);
	sscanf(NumOfBreeders, "%d", Breeders);

	//Get Number Of Images In File
	char NumOfImagesInFile[10];
	fgets(NumOfImagesInFile, 10, File);
	sscanf(NumOfImagesInFile, "%d", NumOfImages);
    
	//Reserve Space For Images
	cudaMallocManaged(Images, sizeof(FImage) * (*NumOfImages));

    //Reserve Space For Tube Reigons
	cudaMallocManaged(Reigons, sizeof(EReigonType*) * SIZE);
    for(int i = 0; i < SIZE; i++)
    {
        cudaMallocManaged(&Reigons[0][i], sizeof(EReigonType) * SIZE);
	}

	//Get Base Tube Chem Levels (Iterate Through X Rows)
	for (int y = 0; y < SIZE; y++)
	{
		char TubeTypeRow[1302];

		fgets(TubeTypeRow, 1302, File);

        //Iterate Through Y Rows
		for (int x = 0; x < SIZE; x++)
		{
            //Get Tube Type In Form Of String For This XY
			char point[2];
			point[0] = TubeTypeRow[2 * x];
			point[1] = '\0';

            //Scan String For Integer
			int ReigonType = 0;
			sscanf(point, "%d", &ReigonType);

            //Store Tube Type
			Reigons[0][x][y] = (EReigonType)ReigonType;
		}
	}

    //Iterate Through Number Of Known Images
	for (int i = 0; i < *NumOfImages; i++)
	{
		//There Is Empty Space Here In File So We Need To REad To Next Line
		char Empty[10];
		fgets(Empty, 10, File);

		//Get Image Size
		char ImageSize[20];
		fgets(ImageSize, 20, File);
		sscanf(ImageSize, "%d %d", &Images[0][i].x, &Images[0][i].y);

		//Get Image Correct Answer
		char ImageAnswer[5];
		fgets(ImageAnswer, 20, File);
		sscanf(ImageAnswer, "%d", &Images[0][i].CorrectIdentification);

		//Iterate Through Y Lines Of Image
		for (int y = 0; y < Images[0][i].y; y++)
		{
			//Get All Pixel RGB Values From Horizontal Row
			char* RGBLine = (char*)malloc(37 * Images[0][i].x + 2);
			fgets(RGBLine, 37 * Images[0][i].x + 2, File);

			//Itearte Through All Picles In That Row
			for (int x = 0; x < Images[0][i].x; x++)
			{
				char PixelChar[37];

				//Get Pixel Data And Put It Into Its Own String
				for (int j = 0; j < 37; j++)
				{
					PixelChar[j] = RGBLine[((x) * 37) + j];
				}

				//Scan Pixerl For RGB Information
				sscanf(PixelChar, "%lf %lf %lf %lf", &Images[0][i].Pixels[x][y].SrcX, &Images[0][i].Pixels[x][y].SrcY, &Images[0][i].Pixels[x][y].DesX, &Images[0][i].Pixels[x][y].DesY);
			}
		}
	}
}