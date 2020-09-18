#! /bin/bash
#BSUB -J Mappingsummary
#BSUB -o /g/huber/users/luetge/jobs/output/adapter/summarySTAR_on_ARGUMENT_1_CLL_05.04.17_out.txt
#BSUB -e /g/huber/users/luetge/jobs/output/adapter/summarySTAR_on_ARGUMENT_1_CLL_05.04.17_error.txt

#Aim: Summarize mapping output to compare different batches using the output of the logfiles



#Setting variables
date=adapter                         #Change!
workDir=/g/huber/users/luetge/results/star                                                           ###CHANGE BACK TO /g/huber/users/luetge/results/star
workingDir=${workDir}/${date}

cd $workingDir

echo WorkingDir:${workingDir}
echo

echo -------------Creating Summary table started---------------------
echo

#Append results of Star log.final.out files to a txt file for all samples
#make a list of all samplenames first

summarytable=/g/huber/users/luetge/results/star/adapter/summaryMappingTrimmed.txt
sampleNames=$(ls | grep H005 | sed 's/Log.final.out//g')

for sample in $sampleNames
do
    cd $workingDir
    logfile=${sample}Log.final.out
    inputreads=$(cat $logfile | grep "Number of input reads" | grep -o [0-9]*)
    readlength=$(cat $logfile | grep "Average input read length" | grep -o [0-9]*)
    mappedlength=$(cat $logfile | grep "Average mapped length" | grep -o [0-9]*[0-9].[0-9][0-9])
    uniqreads=$(cat $logfile | grep "Uniquely mapped reads number" | grep -o [0-9]*)
    unipercent=$(cat $logfile | grep "Uniquely mapped reads %" | grep -o [0-9]*.[0-9]*% | sed s'/%//g' | sed '/^\s*$/d')
    multiloci=$(cat $logfile | grep "Number of reads mapped to multiple loci" | grep -o [0-9]*)
    multipercent=$(cat $logfile | grep "% of reads mapped to multiple loc" | grep -o [0-9]*.[0-9]*% | sed s'/%//g' | sed '/^\s*$/d')
    toomany=$(cat $logfile | grep "% of reads mapped to too many loci" | grep -o [0-9]*.[0-9]*% | sed s'/%//g' | sed '/^\s*$/d')
    unmappedMismapped=$(cat $logfile | grep "% of reads unmapped: too many mismatches" | grep -o [0-9]*.[0-9]*% | sed s'/%//g' | sed '/^\s*$/d')
    unmappedshort=$(cat $logfile | grep "% of reads unmapped: too short" | grep -o [0-9]*.[0-9]*% | sed s'/%//g' | sed '/^\s*$/d')
    unmappedother=$(cat $logfile | grep "% of reads unmapped: other" | grep -o [0-9]*.[0-9]*% | sed s'/%//g' | sed '/^\s*$/d')
    
    echo "$sample" "$inputreads" "$readlength" "$mappedlength" "$uniqreads" "$unipercent" "$multiloci" "$multipercent" "$toomany" "$unmappedMismapped" "$unmappedshort" "$unmappedother" >> "$summarytable"
    

done

header=$(echo "sample" "inputreads" "readlength" "mappedlength" "uniqreads" "unipercent" "multiloci" "multipercent" "toomany" "unmappedMismapped" "unmappedshort" "unmappedother") 
sed -i "1s/^/$header\n/" $summarytable
