#! /bin/bash
#BSUB -J Counttable
#BSUB -o /g/huber/users/luetge/jobs/output/adapter/celllines/Summarized_counttable_20.06.17_out.txt
#BSUB -e /g/huber/users/luetge/jobs/output/adapter/celllines/Summarized_counttable_20.06.17_error.txt

#Aim: Summarize gene counts of different Samples in one Counttable with Samplename in the header and GeneIDs as rownames

#Setting variables
date=celllines                        #Change!
workDir=/g/huber/users/luetge/results/htseq
workingDir=${workDir}/${date}

cd $workingDir

echo WorkingDir:$workingDir
echo

echo -------------Creating Summary table started---------------------
echo

#Append results of HTSeq count to a txt file for all samples
#make a list of all samplenames except the first

first=$(ls | grep -m 1 counts.out)                                            
header=$(echo $first)
sampleNames=$(ls | grep counts.out | grep -v $first)

#create a txt-file from the first sample
cat $first | sed s'/\s/,/g' > seqCounts.txt

for countfile in $sampleNames
do
    sed s'/[A-Z]*[0-9]*\s/,/g' <$countfile >counts.txt
    paste -d '' seqCounts.txt counts.txt >tmp.txt       #somehow nesseccary to use a tmp file
    cat tmp.txt > seqCounts.txt
    rm counts.txt
    rm tmp.txt
    countname=$(echo $countfile)
    header=$header,$countname
    
    
done

#Add header as first line to seqCounts.txt and remove mapping quality data in the last 5 lines

head=$(echo $header | sed 's/counts.out//g')
sed -i "1s/^/$head\n/" seqCounts.txt
head -n -5 seqCounts.txt >>seqCounts.txt    

echo --------------Creating Summary table finished-------------------
echo
