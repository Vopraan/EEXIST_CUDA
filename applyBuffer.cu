#include "main.cuh"

__global__ 
void applyBuffer(FSystem* System, FTube** Buffer)
{
	int x = blockIdx.x;
	int y = threadIdx.x;

	//Update Chemicals
	if(System->Tubes[x][y].SrcX + Buffer[x][y].SrcX <= (SIZE - 1) && System->Tubes[x][y].SrcX + Buffer[x][y].SrcX >= 0.0f)
	{
		System->Tubes[x][y].SrcX = System->Tubes[x][y].SrcX + Buffer[x][y].SrcX;
	}
	else
	{
		//printf("x: %d Y: %d %lf\n", x, y, System->Tubes[x][y].SrcX + Buffer[x][y].SrcX);
	}
	if(System->Tubes[x][y].SrcY + Buffer[x][y].SrcY <= (SIZE - 1) && System->Tubes[x][y].SrcY + Buffer[x][y].SrcY >= 0.0f)
	{
		System->Tubes[x][y].SrcY = System->Tubes[x][y].SrcY + Buffer[x][y].SrcY;
	}
	else
	{
		//printf("x: %d Y: %d %lf\n", x, y, System->Tubes[x][y].SrcY + Buffer[x][y].SrcY);
	}
	if(System->Tubes[x][y].DesX + Buffer[x][y].DesX <= (SIZE - 1) && System->Tubes[x][y].DesX + Buffer[x][y].DesX >= 0.0f)
	{
		System->Tubes[x][y].DesX = System->Tubes[x][y].DesX + Buffer[x][y].DesX;
	}
	else
	{
		//printf("x: %d Y: %d %lf\n", x, y, System->Tubes[x][y].DesX + Buffer[x][y].DesX);
	}
	if(System->Tubes[x][y].DesY + Buffer[x][y].DesY <= (SIZE - 1) && System->Tubes[x][y].DesY + Buffer[x][y].DesY >= 0.0f)
	{
		System->Tubes[x][y].DesY = System->Tubes[x][y].DesY + Buffer[x][y].DesY;
	}
	else
	{
		//printf("x: %d Y: %d %lf\n", x, y, System->Tubes[x][y].DesY + Buffer[x][y].DesY);
	}
}