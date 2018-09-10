#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>

#define ton 0.
#define toff 2000
#define tonpulse 1000
#define toffpulse 1002
#define pulse 1000
#define dt .01
#define tend 2000.
#define repnum 1

#define numcells 500

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
#define alpha 3.7037
#define beta 0.3333

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

double ds1dt (double s1)
{
    double ds1dt;
    ds1dt=-s1*beta;
    return ds1dt;
}







int main (int argc, char *argv[])
{
    //INPUT PARAMETERS
    
    double gsynmin;
    double gsynmax;
    double gsynstep;
    double Iappmin;
    double Iappmax;
    double Iappstep;
    double probii;
    double sdev;
    int number;
    int state;
    
    gsynmin=atof(argv[1]);
    gsynmax=atof(argv[2]);
    gsynstep=atof(argv[3]);
    Iappmin=atof(argv[4]);
    Iappmax=atof(argv[5]);
    Iappstep=atof(argv[6]);
    probii=atof(argv[7]);
    sdev=atof(argv[8]);
    number=atoi(argv[9]);
    state=atoi(argv[10]);
    
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
    sprintf(f4, "InhibitoryNetwork_%d_ConnectivityMatricies.csv", number);
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
    
    double gsyn;
    double Iappavg;
    
    
    
    
    
    // FIND ME
    double sinf;
    double taus;
    sinf=alpha/(alpha+beta);
    taus=1/(alpha+beta);
    double temptime1;
    int temptime2;
    for (gsyn=gsynmin; gsyn<=gsynmax; gsyn=gsyn+gsynstep)
    {
        for (Iappavg=Iappmin; Iappavg<=Iappmax; Iappavg=Iappavg+Iappstep)
        {
            for (a=0; a<numcells; a++)
            {
                for (b=0; b<numcells; b++)
                {
                    connectivity[a][b]=0;
                }
            }
            
            for (a=0; a<numcells; a++)
            {
//                int c;
//                b=0;
//                while (b<60)
//                {
//                    c=rand() % numcells;
//                    if (connectivity[a][c]==0)
//                    {
//                        if (a!=c)
//                        {
//                            connectivity[a][c]=1;
//                            b=b+1;
//                        }
//                    }
//                }
                for (b=0; b<numcells; b++)
                {
                    if (a!=b)
                    {
                        if (((double) rand()/ RAND_MAX)<probii)
                        {
                            connectivity[a][b]=1;
                        }
                    }
                }
            }
            
            ScalarMultMatrix(connectivity, (int)numcells, (int)numcells, (double)gsyn, connectivity);
            
//            for (a=0; a<numcells; a++)
//            {
//                for (b=0; b<numcells; b++)
//                {
//                    fprintf(Output4, "%3f,", connectivity[a][b]);
//                }
//                fprintf(Output4, "\n");
//            }
            
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
                now[0][j]=-35.0+(-35+70.*((double) rand() / RAND_MAX));
                now[1][j]=0;
                now[2][j]=0;
            }

            // HETEROGENEITY
            for(j=0; j<numcells; j++)
            {
                I[j]=randn(Iappavg, sdev);
            }
            
            for(j=0;j<numcells;j++)
            {
                Ssyn[j][0]=0;
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
                
                TotalAverageVoltage=0;
                for (j=0;j<numcells;j++)
                {
                    TotalAverageVoltage=TotalAverageVoltage+answer[i][0][j];
                }
                TotalAverageVoltage=(TotalAverageVoltage/numcells);
                
                //        printf("Set Inow\n");
                s=0;
                for(s=0;s<numcells;s++)
                {
                    Inow[s]=0;
                }
                
                if(i>=(ton/dt) && i<=(toff/dt))
                {
                    s=0;
                    for(s=0;s<numcells;s++)
                    {
                        Inow[s]=I[s];
                    }
                }
                
                // PULSE
                if(i>=(tonpulse/dt) && i<=(toffpulse/dt))
                {
                    for(s=0;s<numcells;s++)
                    {
                        Inow[s]=I[s]+pulse;
                    }
                }
                
                //        printf("Calculate Isyn\n");
                for (j=0; j<numcells; j++)
                {
                    Isyn[j][0]=0;
                }
                
//                for (j=0; j<numcells; j++)
//                {
//                    if(spikecount[j]>0)
//                    {
//                        if (spiketimes[spikecount[j]-1][j]>100)
//                        {
//                            if((times[i]-spiketimes[spikecount[j]-1][j])<1)
//                            {
//                                temptime1=spiketimes[spikecount[j]-1][j]/dt;
//                                Ssyn[j][0]=sinf+(answer[temptime1][2][j]-sinf)*exp(-(times[i]-spiketimes[spikecount[j]-1][j])/taus);
//                            }
//                            if((times[i]-spiketimes[spikecount[j]-1][j])>=1)
//                            {
//                                temptime2=spiketimes[spikecount[j]-1][j]/dt+(1/dt);
//                                Ssyn[j][0]=answer[temptime2][2][j]*exp(-beta*(times[i]-(spiketimes[spikecount[j]-1][j]+1)));
//                            }
//                        }
//                    }
//                }
                
                for (j=0; j<numcells; j++)
                {
                    Ssyn[j][0]=now[2][j];
                }
                
                //        printf("Calculate appcurr\n");
                matrixmult(connectivity, (int)numcells, (int)numcells, Ssyn, (int)numcells, 1, appcurr);
                
                for (j=0;j<numcells;j++)
                {
                    Itotal[j]=Inow[j]-(appcurr[j][0])*(now[0][j]-Esyn);
                    //            Itotal[j]=Inow[j]+appcurr[j][0];
                }
                
                TotalAverageCurrent=0;
                for (j=0;j<numcells;j++)
                {
                    TotalAverageCurrent=TotalAverageCurrent+Itotal[j];
                }
                TotalAverageCurrent=(TotalAverageCurrent/numcells);
                
//                //        printf("Calculate RK terms\n");
//                for (j=0;j<numcells;j++)
//                {
//                    if (now[0][j]<vpeak)
//                    {
//                        {
//                            k1[0][j]=dvdt(now[0][j], now[1][j], Itotal[j]);
//                            k1[1][j]=dudt(now[0][j], now[1][j], Itotal[j]);
//                        }
//
//                        {
//                            k2[0][j]=dvdt(now[0][j]+(dt/2)*k1[0][j], now[1][j]+(dt/2)*k1[1][j], Itotal[j]);
//                            k2[1][j]=dudt(now[0][j]+(dt/2)*k1[0][j], now[1][j]+(dt/2)*k1[1][j], Itotal[j]);
//                        }
//
//                        {
//                            k3[0][j]=dvdt(now[0][j]+(dt/2)*k2[0][j], now[1][j]+(dt/2)*k2[1][j], Itotal[j]);
//                            k3[1][j]=dudt(now[0][j]+(dt/2)*k2[0][j], now[1][j]+(dt/2)*k2[1][j], Itotal[j]);
//                        }
//
//                        {
//                            k4[0][j]=dvdt(now[0][j]+(dt)*k3[0][j], now[1][j]+(dt)*k3[1][j], Itotal[j]);
//                            k4[1][j]=dudt(now[0][j]+(dt)*k3[0][j], now[1][j]+(dt)*k3[1][j], Itotal[j]);
//                        }
//
//                        {
//                            now[0][j]=now[0][j]+(dt/6)*(k1[0][j]+2*k2[0][j]+2*k3[0][j]+k4[0][j]);
//                            now[1][j]=now[1][j]+(dt/6)*(k1[1][j]+2*k2[1][j]+2*k3[1][j]+k4[1][j]);
//                        }
//                    }
//                    else if (now[0][j]>=vpeak)
//                    {
//                        now[0][j]=cizh;
//                        now[1][j]=now[1][j]+dizh;
//                        spiketimes[spikecount[j]][j]=(i)*dt;
//                        spikecount[j]=spikecount[j]+1;
//                    }
//                }
                
                // FORWARD EULER
                for (j=0; j<numcells; j++)
                {
                    now[0][j]=now[0][j]+dvdt(now[0][j],now[1][j],Itotal[j], vt, klow, khigh, vr, cm)*dt;
                    now[1][j]=now[1][j]+dudt(now[0][j],now[1][j],Itotal[j], aizh, bizh, vr)*dt;
                    if (now[0][j]>=vpeak)
                    {
                        now[0][j]=cizh;
                        now[1][j]=now[1][j]+dizh;
                        spiketimes[spikecount[j]][j]=(i)*dt;
                        spikecount[j]=spikecount[j]+1;
                    }
                    
                    if (spikecount[j]>0)
                    {
                        // SYNAPSE TURN ON TIME
                        //  if (spiketimes[spikecount[j]-1][j]>0)
                        if (spiketimes[spikecount[j]-1][j]>100)
                        {
                            temptime1=times[i]-spiketimes[spikecount[j]-1][j];
                            if (temptime1<1)
                            {
                                now[2][j]=now[2][j]+ds0dt(now[2][j],sinf,taus)*dt;
                            }
                            else
                            {
                                now[2][j]=now[2][j]+ds1dt(now[2][j])*dt;
                            }
                        }
                    }
                }

                
                if ((i % 10000) == 0)
                {
                    printf("%3f\n", i*dt);
                }
                
//                fprintf(Output, "%3f,", times[i]);
////                fprintf(Output, "%3f,", TotalAverageCurrent);
////                fprintf(Output, "%3f,", TotalAverageVoltage);
//                for (j=0; j<10; j++)
//                {
//                    fprintf(Output, "%3f, %3f, %3f,", now[0][j], now[2][j], Itotal[j]);
//                }
//                fprintf(Output, "\n");
                
                if (i==steps)
                {
                    fprintf(Output5, "%3f, %3f, %3f, %3f, %3d", probii, gsyn, Iappavg, sdev, state);
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
                    
                    printf("Run DONE\n");
                }
            }
        }
    }
    printf("Everything DONE\n");

    //    printf("Closing output file\n");
    fclose(Output);
    fclose(Output2);
    fclose(Output3);
    fclose(Output4);
    fclose(Output5);
    
    return 0;
}
