#include "main.cuh"

__global__
void applyBias(FSystem* System, FBias** LatestBias, double* Mutation, int gen)
{
	int x = blockIdx.x;
	int y = threadIdx.x; 

	int RandomNum = fabsf((clock64() + 1) * (x + 23) * (y + 56) % 100000);

	if(RandomNum < *Mutation * 100000 || gen == 1)
	{
		//Create 4 Dffrent Random Values
		int RandomBias1 = fabsf((clock64() * (x + 1) * (y + 1)) % SIZE);
		int RandomBias2 = fabsf((clock64() * (x + 1 + clock64()) * (y + 1)) % SIZE);
		int RandomBias3 = fabsf((clock64() * (x + 3 * x) * (y + 1) * clock64()) % SIZE);
		int RandomBias4 = fabsf((clock64() * (x + y) * (y + -x + clock64() * clock64())) % SIZE);

		//Copy Bias Perfectly No Mutation
		System->Bias[x][y].SrcX = RandomBias1 - x;
		System->Bias[x][y].SrcY = RandomBias2 - y;
		System->Bias[x][y].DesX = RandomBias3 - x;
		System->Bias[x][y].DesY = RandomBias4 - y;
	}
	else
	{
		//Copy Bias Perfectly No Mutation
		System->Bias[x][y].SrcX = LatestBias[x][y].SrcX;
		System->Bias[x][y].SrcY = LatestBias[x][y].SrcY;
		System->Bias[x][y].DesX = LatestBias[x][y].DesX;
		System->Bias[x][y].DesY = LatestBias[x][y].DesY;
	}
}