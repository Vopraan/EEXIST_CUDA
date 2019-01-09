#include "main.cuh"

__global__
void breedBiases(FSystem* Systems, int* NumOfSystems, FBias** OutBias, int* Breeders, int* TopPerformers)
{
	int x = blockIdx.x;
    int y = threadIdx.x;

    for(int i = 0; i < *NumOfSystems; i++)
    {
        for(int j = 0; j < *NumOfSystems; j++)
        {
            if(Systems[j].CorrectGuesses > Systems[i].CorrectGuesses)
            {
                TopPerformers[i] = j;
            }
        }
    }

    double SrcX = 0;
    double SrcY = 0;
    double DesX = 0;
    double DesY = 0;

    int count = 0;
    for(int i = 0; i < *Breeders; i++)
    {
        if(TopPerformers[i] >= 0)
        {
            SrcX = SrcX + Systems[TopPerformers[i]].Bias[x][y].SrcX;
            SrcY = SrcY + Systems[TopPerformers[i]].Bias[x][y].SrcY;
            DesX = DesX + Systems[TopPerformers[i]].Bias[x][y].DesX;
            DesY = DesY + Systems[TopPerformers[i]].Bias[x][y].DesY;

            count++;
        }
    }

    SrcX = SrcX / count;
    SrcY = SrcX / count;
    DesX = DesX / count;
    DesY = DesY / count;

    OutBias[x][y].SrcX = SrcX;
    OutBias[x][y].SrcX = SrcY;
    OutBias[x][y].SrcX = DesX;
    OutBias[x][y].SrcX = DesY;

}