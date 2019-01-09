#include "main.cuh"

__global__ 
void updateSystem(FSystem* System, double* Karma, FTube** Buffer, double delta)
{
	int KarmIn = *Karma;

	int x = blockIdx.x;
	int y = threadIdx.x;

	//Where To Take Cehms From SRC
	int SrcX = (int)System->Tubes[x][y].SrcX;
    int SrcY = (int)System->Tubes[x][y].SrcY;

	//Where To Take Chems From Des
	int DesX = (int)System->Tubes[x][y].DesX;
	int DesY = (int)System->Tubes[x][y].DesY;

	//Add Offset For Src (Bias)
	SrcX = SrcX + System->Bias[x][y].SrcX;
	SrcY = SrcY + System->Bias[x][y].SrcY;

	//Add Offset For Des (Bias)
	DesX = DesX + System->Bias[x][y].DesX;
	DesY = DesY + System->Bias[x][y].DesY;

	//Iterate Through Potential Karma Tubes in X
	for (int Kx = -KarmIn; Kx <= KarmIn; Kx++)
	{
		//Iterate Through Potential Karma Tubes in Y
		for (int Ky = -KarmIn; Ky <= KarmIn; Ky++)
		{
			//Calcaulte Distance From ORgin Tube
			double KarmaDistance = sqrtf(powf(Kx, 2) + powf(Ky, 2));
			if (KarmaDistance <= *Karma)
			{
				//Figure Out What Tubes Take And Put Into
				int KSrcX = (SrcX + Kx + SIZE) % SIZE;
				int KSrcY = (SrcY + Ky + SIZE) % SIZE;
				int KDesX = (DesX + Kx + SIZE) % SIZE;
				int KDesY = (DesY + Ky + SIZE) % SIZE;

				//Caclaute Multiplier offset of Chemcail TRanfer (Based On How Far FRom Center KARMA Tube You are)
				double KarmaMultiplier = KarmaDistance / *Karma;

				//Perform SrcX Transfer
				if(System->Tubes[KSrcX][KSrcY].SrcX > (delta * KarmaMultiplier) && System->Tubes[KDesX][KDesY].SrcX < ((SIZE - 1) - (delta * KarmaMultiplier)))
				{
					System->Tubes[KSrcX][KSrcY].SrcX = System->Tubes[KSrcX][KSrcY].SrcX - (delta * KarmaMultiplier);
					System->Tubes[KDesX][KDesY].SrcX = System->Tubes[KDesX][KDesY].SrcX + (delta * KarmaMultiplier);
				}

				//Perform SrcY Transfer
				if(System->Tubes[KSrcX][KSrcY].SrcY > (delta * KarmaMultiplier) && System->Tubes[KDesX][KDesY].SrcY < ((SIZE - 1) - (delta * KarmaMultiplier)))
				{
					System->Tubes[KSrcX][KSrcY].SrcY = System->Tubes[KSrcX][KSrcY].SrcY - (delta * KarmaMultiplier);
					System->Tubes[KDesX][KDesY].SrcY = System->Tubes[KDesX][KDesY].SrcY + (delta * KarmaMultiplier);
				}

				//Perform DesX Transfer
				if(System->Tubes[KSrcX][KSrcY].DesX > (delta * KarmaMultiplier) && System->Tubes[KDesX][KDesY].DesX < ((SIZE - 1) - (delta * KarmaMultiplier)))
				{
					System->Tubes[KSrcX][KSrcY].DesX = System->Tubes[KSrcX][KSrcY].DesX - (delta * KarmaMultiplier);
					System->Tubes[KDesX][KDesY].DesX = System->Tubes[KDesX][KDesY].DesX + (delta * KarmaMultiplier);
				}

				//Perform DesY Transfer
				if(System->Tubes[KSrcX][KSrcY].DesY > (delta * KarmaMultiplier) && System->Tubes[KDesX][KDesY].DesY < ((SIZE - 1) - (delta * KarmaMultiplier)))
				{
					System->Tubes[KSrcX][KSrcY].DesY = System->Tubes[KSrcX][KSrcY].DesY - (delta * KarmaMultiplier);
					System->Tubes[KDesX][KDesY].DesY = System->Tubes[KDesX][KDesY].DesY + (delta * KarmaMultiplier);
				}
			}
		}
	}
}
/*

//Calcaultes The Ammount Of Cehm That Should Be TAken From Tube Based On APreameters Provided.
__device__ 
void GetChemToTake(double Karma, double KarmaDistance, double CurrentChemLevel, double TargetChemLevel, double* TargetAmountToTake)
{
	double Targ = *TargetAmountToTake;

	//Basically a precentage based on how far away this point is from Center
	double KarmaMultiplier = KarmaDistance / Karma;

	//Scale The Amount Of Chem Reuqesting By The Karma Diustance.
	*TargetAmountToTake = *TargetAmountToTake * KarmaMultiplier;

	//Make Sure There Is Some Chemical To Take
	if (CurrentChemLevel < Targ)
	{
		*TargetAmountToTake = CurrentChemLevel;

		if(TargetChemLevel + *TargetAmountToTake > (SIZE - 1))
		{
			*TargetAmountToTake = (TargetChemLevel + *TargetAmountToTake) - (SIZE - 1);
		}

		return;
	}

	if(TargetChemLevel + *TargetAmountToTake > (SIZE - 1))
	{
		*TargetAmountToTake = (TargetChemLevel + *TargetAmountToTake) - (SIZE - 1);
	}

	return;
}


				//Calcaute How May Chemicals To Take From SOurce And Be TRansfered To Des
				GetChemToTake(*Karma, KarmaDistance, System->Tubes[KSrcX][KSrcY].SrcX + Buffer[KSrcX][KSrcY].SrcX, System->Tubes[KDesX][KDesY].SrcX + Buffer[KDesX][KDesY].SrcX, &Take);
				double KSrcXTake = Take;
                Take = delta;
                
				GetChemToTake(*Karma, KarmaDistance, System->Tubes[KSrcX][KSrcY].SrcY + Buffer[KSrcX][KSrcY].SrcY, System->Tubes[KDesX][KDesY].SrcY + Buffer[KDesX][KDesY].SrcY, &Take);
				double KSrcYTake = Take;
				Take = delta;

				GetChemToTake(*Karma, KarmaDistance, System->Tubes[KSrcX][KSrcY].DesX + Buffer[KSrcX][KSrcY].DesX, System->Tubes[KDesX][KDesY].DesX + Buffer[KDesX][KDesY].DesX, &Take);
				double KDesXTake = Take;
                Take = delta;
                
				GetChemToTake(*Karma, KarmaDistance, System->Tubes[KSrcX][KSrcY].DesY + Buffer[KSrcX][KSrcY].DesY, System->Tubes[KDesX][KDesY].DesY + Buffer[KDesX][KDesY].DesY, &Take);
				double KDesYTake = Take;
				Take = delta;
*/