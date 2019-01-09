#include "main.cuh"

__global__
void clearBuffer(FTube** Buffer)
{
	int x = blockIdx.x;
    int y = threadIdx.x;

    Buffer[x][y].SrcX = 0;
    Buffer[x][y].SrcY = 0;
    Buffer[x][y].DesX = 0;
    Buffer[x][y].DesY = 0;
}