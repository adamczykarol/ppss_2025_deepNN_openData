#!/bin/bash
#SBATCH --account {Allocation from hpc-grants} # grant-cpu
#SBATCH --partition plgrid
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 32
#SBATCH --time 3:00:00
#SBATCH --job-name jupyter-lab-tunnel
#SBATCH --output jupter-log-%J.txt

## get tunneling info
XDG_RUNTIME_DIR=""
ipnport=$(shuf -i8000-9999 -n1)
ipnip=$(hostname -i)
user=$USER 

## print tunneling instruction to jupyter-log-{jobid}.txt
echo -e "
	Copy/Paste this in your local terminal to ssh tunnel with remote
	-----------------------------------------------------------------
	ssh -o ServerAliveInterval=300 -N -L $ipnport:$ipnip:$ipnport ${user}@ares.cyfronet.pl
	--------------------------------------------------------------------------------------

	Then open a browser on your local machine to the following address
	-------------------------------------------------------------------
	localhost:$ipnport (prefix /w https:// if using password)
	-------------------------------------------------------------------
	"

#module load root/6.32.02-foss-2023a jupyterlab/4.2.0-gcccore-13.2.0 tensorflow/2.7.1-foss-2021b-cuda-11.4.1
module load  tensorflow/2.7.1-foss-2021b-cuda-11.4.1 jupyterlab/3.1.6-gcccore-11.2.0 


## start an ipcluster instance and launch jupyter server
jupyter-lab --no-browser --port=$ipnport --ip=$ipnip
