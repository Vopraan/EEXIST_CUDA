#include "main.cuh"

void output(FILE* file, FSystem* Systems, int* SystemsToRun, int Gen, int NumOfGuesses)
{
    printf("OUTPUT");
    fprintf(file, "Gen: %d\n    ", Gen);

    for(int i = 0; i < *SystemsToRun; i++)
    {
        fprintf(file, "Sys(%d) : %d/%d\n    ", i, Systems[i].CorrectGuesses, NumOfGuesses);
    }

    fprintf(file, "\n\n");
}