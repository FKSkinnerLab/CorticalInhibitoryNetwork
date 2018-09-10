#!/bin/bash
#SBATCH --time=20:00:00
#SBATCH --output=InhibitoryNetwork_count.out
#SBATCH --nodes=1

srun ./InhibitoryNetwork_cortex_0712.o gsynmin gsynmax gsynstep Iappmin Iappmax Iappstep probii sdev count state

