#!/bin/bash
#SBATCH -D /mnt/nfs/wenwu/Hadia/Research/SE285/runs/final/run01ps
#SBATCH --job-name=lmp_1ps
#SBATCH --partition=cpu
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=1
#SBATCH --time=12:00:00
#SBATCH --output=lammps_output_%j.log
#SBATCH --nodelist=cpu065
#SBATCH --mem=128GB

### Load modules
source /etc/profile.d/modules.sh
module purge
module load gcc/13.1.0
module load openmpi4/gcc/4.1.5
module load shared
module load slurm/slurm/23.02.8

### Activate environment (if needed for LAMMPS)
source /mnt/nfs/wenwu/Hadia/Software/anaconda3/bin/activate reaxff

### Optional: set path to your custom LAMMPS build
export PATH=/mnt/nfs/wenwu/Hadia/Software/lammps_ace/build_reax/:$PATH

# Point the dynamic loader to the REAX build first
export LD_LIBRARY_PATH=/mnt/nfs/wenwu/Hadia/Software/lammps_ace/build_reax:$LD_LIBRARY_PATH

### Run LAMMPS
LMP=/mnt/nfs/wenwu/Hadia/Software/lammps_ace/build_reax/lmp
echo "=== Starting Phase 1: Minimization ==="
mpirun -n $SLURM_NTASKS $LMP -in 01_minimize.in > log1.txt
echo "✅ Phase 1 complete"

echo "=== Starting Phase 2: Heating ==="
mpirun -n $SLURM_NTASKS $LMP -in 02_heat.in > log2.txt
echo "✅ Phase 2 complete"

echo "=== Starting Phase 3: Hold ==="
mpirun -n $SLURM_NTASKS $LMP -in 03_hold.in > log3.txt
echo "✅ Phase 3 complete"

echo "=== Starting Phase 4: Cooling ==="
mpirun -n $SLURM_NTASKS $LMP -in 04_cool.in > log4.txt
echo "✅ Phase 4 complete"
echo "✅ LAMMPS simulation finished."

