#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>

#define ton 0.
#define toff 5000
#define dt .01
#define tend 5000.
#define repnum 1

#define numcells 1

//#define cm 90.0
//#define vr -60.6
//#define vt -43.1
//#define vpeak 2.5
//#define aizh 0.1
//#define bizh -0.1
//#define cizh -67.0
//#define dizh 0.1
//#define klow 1.7
//#define khigh 14.0

#define Esyn -75.0
#define alphainv 0.27
#define betainv 3.0

void matrixmult(double** A, int rowsA, int colsA, double** B, int rowsB, int colsB, double** answer)
{
    int i, j, k;
    for (i=0; i<rowsA; i++)
    {
        for (j=0; j<colsB; j++)
        {
            answer[i][j] = 0;
            for (k=0; k<colsA; k++)
            {
                answer[i][j]=answer[i][j]+(A[i][k])*(B[k][j]);
            }
        }
    }
}


void ScalarMultMatrix(double** A, int rowsA, int colsA, double scalar, double** answer)
{
    int i, j;
    for (i=0; i<rowsA; i++)
    {
        for (j=0; j<colsA; j++)
        {
            answer[i][j]=A[i][j]*scalar;
        }
    }
}


double** MatrixAdd(double** A, int rowsA, int colsA, double** B, int rowsB, int colsB)
{
    double** answer;
    {
        answer=(double**) malloc(rowsA*sizeof(double*));
        int a;
        for (a=0;a<rowsA; a++)
        {
            answer[a]=(double*) malloc(colsB*sizeof(double));
        }
        
        int i, j;
        for (i=0; i<rowsA; i++)
        {
            for (j=0; j<colsB; j++)
            {
                answer[i][j]=A[i][j]+B[i][j];
            }
        }
    }
    return answer;
}

double dvdt (double V, double u, double Iapp, double vt, double klow, double khigh, double vr, double cm)
{
    double dvdt;
    double k;
    if (V<=vt)
    {
        k=klow;
    }
    else if (V>vt)
    {
        k=khigh;
    }
    dvdt=(k*(V-vr)*(V-vt)-u+Iapp)/cm;
    return dvdt;
}

double dudt (double V, double u, double Iapp, double aizh, double bizh, double vr)
{
    double dudt;
    dudt=aizh*(bizh*(V-vr)-u);
    return dudt;
}

double randn (double mu, double sigma)
{
    double U1, U2, W, mult;
    static double X1, X2;
    static int call = 0;
    
    if (call == 1)
    {
        call = !call;
        return (mu + sigma * (double) X2);
    }
    
    do
    {
        U1 = -1 + ((double) rand () / RAND_MAX) * 2;
        U2 = -1 + ((double) rand () / RAND_MAX) * 2;
        W = pow (U1, 2) + pow (U2, 2);
    }
    while (W >= 1 || W == 0);
    
    mult = sqrt ((-2 * log (W)) / W);
    X1 = U1 * mult;
    X2 = U2 * mult;
    
    call = !call;
    
    return (mu + sigma * (double) X1);
}

double ds0dt (double s0, double sinf, double taus)
{
    double ds0dt;
    ds0dt=-(s0-sinf)/taus;
    return ds0dt;
}

double ds1dt (double s1, double beta)
{
    double ds1dt;
    ds1dt=-s1*beta;
    return ds1dt;
}







int main (int argc, char *argv[])
{
    //INPUT PARAMETERS
    
    double gsyn;
    double Iappmin;
    double Iappmax;
    double Iappstep;
    int number;
    int state;
    
    gsyn=atof(argv[1]);
    Iappmin=atof(argv[2]);
    Iappmax=atof(argv[3]);
    Iappstep=atof(argv[4]);
    number=atof(argv[5]);
    state=atoi(argv[6]);
    
    double cm;
    double vr;
    double vt;
    double vpeak;
    double aizh;
    double bizh;
    double cizh;
    double dizh;
    double klow;
    double khigh;
    
    if (state==0)
    {
        cm=73;
        vr=-60.6;
        vt=-43.1;
        vpeak=2.5;
        aizh=0.01;
        bizh=-0.2;
        cizh=-67;
//        dizh=1.75;
        dizh=0.75;
        klow=0.6;
//        khigh=1.25;
        khigh=2;
    }
    else if (state==1)
    {
        cm=49;
        vr=-60.6;
        vt=-43.1;
        vpeak=2.5;
        aizh=0.01;
        bizh=-0.4;
        cizh=-67;
//        dizh=2.25;
        dizh=1.25;
        klow=0.4;
//        khigh=0.4;
        khigh=2;
    }
    else if (state==2)
    {
        cm=90.0;
        vr=-60.6;
        vt=-43.1;
        vpeak=2.5;
        aizh=0.1;
        bizh=-0.1;
        cizh=-67;
        dizh=0.1;
        klow=1.7;
        khigh=14.0;
    }
    
    //    printf("%f, %f, %f, %d\n", p, gsyn, probii, number);
    int steps;
    steps=tend/dt;
    
    double** now;
    now=(double**) malloc((3)*sizeof(double*));
    int a;
    for (a=0; a<3; a++)
    {
        now[a]=(double*) malloc(numcells*sizeof(double));
    }
    
    double*** answer;
    answer=(double***) malloc((steps+1)*sizeof(double**));
    for (a=0; a<steps+1; a++)
    {
        answer[a]=(double**) malloc((3)*sizeof(double*));
        int b;
        for (b=0; b<3; b++)
        {
            answer[a][b]=(double*) malloc(numcells*sizeof(double));
        }
    }
    
    double** k1;
    k1=(double**) malloc((2)*sizeof(double*));
    for (a=0; a<2; a++)
    {
        k1[a]=(double*) malloc(numcells*sizeof(double));
    }
    
    double** k2;
    k2=(double**) malloc((2)*sizeof(double*));
    for (a=0; a<2; a++)
    {
        k2[a]=(double*) malloc(numcells*sizeof(double));
    }
    
    double** k3;
    k3=(double**) malloc((2)*sizeof(double*));
    for (a=0; a<2; a++)
    {
        k3[a]=(double*) malloc(numcells*sizeof(double));
    }
    
    double** k4;
    k4=(double**) malloc((2)*sizeof(double*));
    for (a=0; a<2; a++)
    {
        k4[a]=(double*) malloc(numcells*sizeof(double));
    }
    
    double* times;
    times=(double*) malloc((steps+1)*sizeof(double));
    
    double** Isyn;
    Isyn=(double**) malloc((numcells)*sizeof(double*));
    for (a=0; a<numcells; a++)
    {
        Isyn[a]=(double*) malloc(1*sizeof(double));
    }
    
    double** Ssyn;
    Ssyn=(double**) malloc((numcells)*sizeof(double*));
    for (a=0; a<numcells; a++)
    {
        Ssyn[a]=(double*) malloc(1*sizeof(double));
    }
    
    
    double** appcurr;
    appcurr=(double**) malloc((numcells)*sizeof(double*));
    for (a=0; a<numcells; a++)
    {
        appcurr[a]=(double*) malloc(1*sizeof(double));
    }
    
    double** spiketimes;
    spiketimes=(double**) malloc((steps+1)*sizeof(double*));
    int s;
    for (s=0;s<(steps+1); s++)
    {
        spiketimes[s]=(double*) malloc(numcells*sizeof(double));
    }
    
    int j;
    int* spikecount;
    spikecount=(int*) malloc(numcells*sizeof(int));
    
    double* Inow;
    Inow=(double*) malloc(numcells*sizeof(double));
    
    double* Itotal;
    Itotal=(double*) malloc(numcells*sizeof(double));
    
    double* I;
    I=(double*) malloc(numcells*sizeof(double));
    
    int rep;
    
    struct timeval time;
    gettimeofday(&time,NULL);
    
    // microsecond has 1 000 000
    // Assuming you did not need quite that accuracy
    // Also do not assume the system clock has that accuracy.
    srand((time.tv_sec * 1000) + (time.tv_usec / 1000)+ number);
    
    // The trouble here is that the seed will repeat every
    // 24 days or so.
    
    // If you use 100 (rather than 1000) the seed repeats every 248 days.
    
    // Do not make the MISTAKE of using just the tv_usec
    // This will mean your seed repeats every second.
    
    //    printf("Opening output file\n");
    
    char f1[50], f2[50], f3[50], f4[50], f5[50];
    
    sprintf(f1, "InhibitoryNetwork_%d_TrackVariables.csv", number);
    sprintf(f2, "InhibitoryNetwork_%d_SpikeTimes.csv", number);
    sprintf(f3, "InhibitoryNetwork_%d_InputCurrents.csv", number);
    sprintf(f4, "InhibitoryNetwork_%d_IF.csv", number);
    sprintf(f5, "InhibitoryNetwork_%d_Parameters.csv", number);
    
    FILE *Output;
    Output = fopen(f1, "wt");
    
    FILE *Output2;
    Output2 = fopen(f2, "wt");
    
    FILE *Output3;
    Output3 = fopen(f3, "wt");
    
    FILE *Output4;
    Output4 = fopen(f4, "wt");
    
    FILE *Output5;
    Output5 = fopen(f5, "wt");
    
    printf("%s\n", f1);
    printf("%s\n", f2);
    printf("%s\n", f3);
    printf("%s\n", f4);
    printf("%s\n", f5);
    
    double** connectivity;
    connectivity=(double**) malloc((numcells)*sizeof(double*));
    int w;
    for (w=0;w<numcells; w++)
    {
        connectivity[w]=(double*) malloc(numcells*sizeof(double));
    }
    
    int b;
    int i;
    int k;
    
    double TotalAverageCurrent;
    double TotalAverageVoltage;
    
    double Iapp;
    
    
    
    
    
    // FIND ME
    double alpha;
    double beta;
    alpha=1/alphainv;
    beta=1/betainv;
    double sinf;
    double taus;
    sinf=alpha/(alpha+beta);
    taus=1/(alpha+beta);
    double temptime1;
    int temptime2;
    
    // INITIAL CONDITIONS
    for(j=0;j<numcells;j++)
    {
        now[0][j]=-60.0;
        now[1][j]=0;
        now[2][j]=0;
    }
    
    // HETEROGENEITY
    for(j=0; j<numcells; j++)
    {
        I[j]=randn(Iapp, 0);
    }
    
    for(j=0;j<numcells;j++)
    {
        Ssyn[j][0]=0;
    }
    
    double period;
    double period2;
    double freq;
    double freq2;
//    int perturbtime;
//    int perturbtimeend;
//    int p;
//    double phaseshift;
    
    
    for (Iapp=Iappmin; Iapp<=Iappmax; Iapp=Iapp+Iappstep)
    {
        period=0;
        period2=0;
        
        for (j=0; j<numcells; j++)
        {
            spikecount[j]=0;
        }
        
        for (s=0;s<(steps+1); s++)
        {
            for (j=0;j<numcells;j++)
            {
                spiketimes[s][j]=0;
            }
        }
        
        // INITIAL CONDITIONS
        for(j=0;j<numcells;j++)
        {
            now[0][j]=-60.0;
            now[1][j]=0;
            now[2][j]=0;
        }
        
        //    printf("Entering time loop\n");
        for(i=0; i<=steps; i++)
        {
            //        printf("Move now into answer\n");
            for(j=0; j<numcells; j++)
            {
                answer[i][0][j]=now[0][j];
                //        printf("a\n");
                answer[i][1][j]=now[1][j];
                //        printf("b\n");
                answer[i][2][j]=now[2][j];
            }
            times[i]=i*dt;
            
            //        printf("Set Inow\n");
            Inow[0]=Iapp;
            
            // FORWARD EULER
            for (j=0; j<numcells; j++)
            {
                now[0][j]=now[0][j]+dvdt(now[0][j],now[1][j],Inow[j], vt, klow, khigh, vr, cm)*dt;
                now[1][j]=now[1][j]+dudt(now[0][j],now[1][j],Inow[j], aizh, bizh, vr)*dt;
                if (now[0][j]>=vpeak)
                {
                    now[0][j]=cizh;
                    now[1][j]=now[1][j]+dizh;
                    spiketimes[spikecount[j]][j]=(i)*dt;
                    spikecount[j]=spikecount[j]+1;
                    if (spikecount[0]==2)
                    {
                        period=spiketimes[1][0]-spiketimes[0][0];
                        printf("early period=%3f\n", period);
                    }
                    if (spikecount[0]==21)
                    {
                        period2=spiketimes[20][0]-spiketimes[19][0];
                        printf("late period=%3f\n", period2);
                    }
                }
                
                //            if (spikecount[j]>0)
                //            {
                //                // SYNAPSE TURN ON TIME
                //                //                        if (spiketimes[spikecount[j]-1][j]>100)
                //                if (spiketimes[spikecount[j]-1][j]>0)
                //                {
                //                    temptime1=times[i]-spiketimes[spikecount[j]-1][j];
                //                    if (temptime1<1)
                //                    {
                //                        now[2][j]=now[2][j]+ds0dt(now[2][j],sinf,taus)*dt;
                //                    }
                //                    else
                //                    {
                //                        now[2][j]=now[2][j]+ds1dt(now[2][j], beta)*dt;
                //                    }
                //                }
                //            }
            }
            
            
//            if ((i % 2000) == 0)
//            {
//                printf("%3f\n", i*dt);
//            }
            
            //        fprintf(Output, "%3f,", times[i]);
            //        //                fprintf(Output, "%3f,", TotalAverageCurrent);
            //        //                fprintf(Output, "%3f,", TotalAverageVoltage);
            //        for (j=0; j<10; j++)
            //        {
            //            fprintf(Output, "%3f, %3f, %3f,", now[0][j], appcurr[j][0], Itotal[j]);
            //        }
            //        fprintf(Output, "\n");
            
            if (i==steps)
            {
                if (spikecount[0]==0)
                {
                    fprintf(Output4, "%3f, %3f, %3f\n", Iapp, 0.0, 0.0);
                }
                
                if (spikecount[0]>0 && spikecount[0]<21)
                {
                    freq=1000/period;
                    fprintf(Output4, "%3f, %3f, %3f\n", Iapp, freq, 0.0);
                }
                
                if (spikecount[0]>=21)
                {
                    freq=1000/period;
                    freq2=1000/period2;
                    fprintf(Output4, "%3f, %3f, %3f\n", Iapp, freq, freq2);
                }

                
                fprintf(Output5, "%3f, %3f, %3f, %3f, %3d", gsyn, Iappmin, Iappmax, Iappstep, state);
                fprintf(Output5, "\n");
                
                for(j=0; j<numcells; j++)
                {
                    fprintf(Output3, "%3f\n", I[j]);
                }
                
                //    printf("Print spiketimes data \n");
                for(j=0; j<numcells; j++)
                {
                    if (spikecount[j]>0)
                    {
                        int k;
                        for (k=0; k<spikecount[j]; k++)
                        {
                            fprintf(Output2, "%3f,", spiketimes[k][j]);
                        }
                    }
                    if (spikecount[j]==0)
                    {
                        fprintf(Output2, "%3f,", 0.0);
                        //            fprintf(Output2, "\n");
                    }
                    fprintf(Output2, "\n");
                }
                fprintf(Output2, "\n");
                //    printf("End printing spiketimes data\n");
                
                printf("DONE %f\n", Iapp);
            }
        }
    }
    
    
    
    //    printf("Closing output file\n");
    fclose(Output);
    fclose(Output2);
    fclose(Output3);
    fclose(Output4);
    fclose(Output5);
    
    return 0;
}
