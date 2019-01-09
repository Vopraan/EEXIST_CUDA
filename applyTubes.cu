#include "main.cuh"

__global__
void applyTubes(FSystem* System, int Index, EReigonType** Reigons, FImage* Images, int* NumOfImages, int* ImageUsed)
{
	int x = blockIdx.x;
    int y = threadIdx.x;

    EReigonType TubeType = Reigons[x][y];

    //Check If Tube Is Image REigon
    if(TubeType == EReigonType::Input)
    {
        //Load In Image Data
        System[Index].Tubes[x][y].SrcX = Images[*ImageUsed].Pixels[x][y].SrcX * (SIZE - 1);
        System[Index].Tubes[x][y].SrcY = Images[*ImageUsed].Pixels[x][y].SrcY * (SIZE - 1);
        System[Index].Tubes[x][y].DesX = Images[*ImageUsed].Pixels[x][y].DesX * (SIZE - 1);
        System[Index].Tubes[x][y].DesY = Images[*ImageUsed].Pixels[x][y].DesY * (SIZE - 1);
    }
    else
    {
        //Load In Standard Chem Level
        System[Index].Tubes[x][y].SrcX = SIZE / 2;
        System[Index].Tubes[x][y].SrcY = SIZE / 2;
        System[Index].Tubes[x][y].DesX = SIZE / 2;
        System[Index].Tubes[x][y].DesY = SIZE / 2;
    }
}