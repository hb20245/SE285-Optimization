#!/bin/bash
#SBATCH -D /mnt/nfs/wenwu/Hadia/Research/camacho/CHO_test/stable_ref_CHO_tests/nve_drift/runs/run7
#SBATCH --job-name=lammps_CHO1
#SBATCH --partition=cpu
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --time=02:00:00
#SBATCH --output=lammps_output_%j.log
#SBATCH --error=lammps_error_%j.log
#SBATCH --nodelist=cpu064
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
mpirun -n $SLURM_NTASKS $LMP -in in.run

echo "✅ LAMMPS simulation finished."

