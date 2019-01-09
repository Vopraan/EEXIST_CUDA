#include "main.cuh"

void scoreSystem(FSystem* System, EReigonType** Reigons, FImage* Image)
{
	double Out0Val = 0;
	int Out0Tubes = 0;

	double Out1Val = 0;
	int Out1Tubes = 0;

	double Out2Val = 0;
	int Out2Tubes = 0;

	double Out3Val = 0;
	int Out3Tubes = 0;

	int SystemAnswer = 0;

	for(int y = 0; y < SIZE; y++)
	{
		for(int x = 0; x < SIZE; x++)
		{
			switch(Reigons[x][y]) 
			{
				case 2  :
				Out0Tubes++;
				Out0Val = Out0Val + System->Tubes[x][y].SrcX + System->Tubes[x][y].SrcY + System->Tubes[x][y].DesX + System->Tubes[x][y].DesY;
				   break;
				 
				case 3  :
				Out1Tubes++;
				Out1Val = Out1Val + System->Tubes[x][y].SrcX + System->Tubes[x][y].SrcY + System->Tubes[x][y].DesX + System->Tubes[x][y].DesY;
				   break;

				case 4  :
				Out2Tubes++;
				Out2Val = Out2Val + System->Tubes[x][y].SrcX + System->Tubes[x][y].SrcY + System->Tubes[x][y].DesX + System->Tubes[x][y].DesY;
				   break;

				case 5  :
				Out3Tubes++;
				Out3Val = Out3Val + System->Tubes[x][y].SrcX + System->Tubes[x][y].SrcY + System->Tubes[x][y].DesX + System->Tubes[x][y].DesY;
				   break;

				default :
				break;
			}
		}
	}

	if(((Out0Val / 4) / Out0Tubes) > (SIZE / 2))
	{
		SystemAnswer = SystemAnswer + 1;
	}
	if(((Out1Val / 4) / Out1Tubes) > (SIZE / 2))
	{
		SystemAnswer = SystemAnswer + 10;
	}
	if(((Out2Val / 4) / Out2Tubes) > (SIZE / 2))
	{
		SystemAnswer = SystemAnswer + 100;
	}
	if(((Out3Val / 4) / Out3Tubes) > (SIZE / 2))
	{
		SystemAnswer = SystemAnswer + 1000;
	}

	if(SystemAnswer == Image->CorrectIdentification)
	{
		System->CorrectGuesses++;
	}
}