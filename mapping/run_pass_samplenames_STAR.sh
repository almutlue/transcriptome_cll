#! /bin/bash
#BSUB -J Parallelalignment
#BSUB -o /g/huber/users/luetge/jobs/output/mappingParam/adapter/Run_pass_sample_names_to_STARalignment_25.06.17_out.txt
#BSUB -e /g/huber/users/luetge/jobs/output/mappingParam/adapter/Run_pass_sample_names_to_STARalignment_25.06.17_error.txt

#Aim: To pass sample names to STAR alignment script for parallel alignment


for sample_name in $(cat /g/huber/users/luetge/jobs/vars/star_mappingParam.txt)  ##!!!!!!!-------------CHANGE     
do 
	
	echo bsub sample $sample_name started
	echo
	
	##--------replace string "ARGUMENT_1" in this $bash_file
	bash_file=/g/huber/users/luetge/jobs/scripts/star_mappingParam_sjdb.sh                             ##mapping.sh
	
	sed "s/ARGUMENT_1/${sample_name}/g" < $bash_file | bsub -M 35000 -R "rusage[mem=35000]" -R  "span[hosts=1]"
	
	echo bsub sample $sample_name finished
	echo
done


