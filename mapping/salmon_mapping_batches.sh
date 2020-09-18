#! /bin/bash
#BSUB -J CLLalign
#BSUB -n 10
#BSUB -o /g/huber/users/luetge/jobs/output/20062017/Salmon_on_ARGUMENT_1_CLL_05.04.17_out.txt
#BSUB -e /g/huber/users/luetge/jobs/output/20062017/Salmon_on_ARGUMENT_1_CLL_05.04.17_error.txt

#Aim: Write a Script to map fastqc files using STAR

#Setting Variables
date=20062017
pathRawdata=/scratch/aluetge/rawdata
#/g/huber/projects/nct/cll/RawData/RNASeq
pathSalmon=/g/huber/users/luetge/software/Salmon-0.8.2_linux_x86_64/bin/salmon
workDir=/g/huber/users/luetge/results/salmon                                                           
workingDir=${workDir}/${date}/
refTranscript=/g/huber/users/luetge/data/transcriptome/gencode.v19.pc_transcripts.fa
pathIndex=/g/huber/users/luetge/results/salmon/02062017



mkdir $workingDir

echo WorkingDir:$workingDir
echo

#Start Mapping

echo --------Start mapping with Salmon------------
echo

#Create a loop to read in fastqc files from a list and map them using STAR

for sampleName in ARGUMENT_1                                                                                                                                  
do

#download sample file
#/g/huber/users/luetge/software/sshpass-1.06/sshpass -v -p 'N-T!cI4P6*7U9j5Y' /g/huber/users/dietrich/aspera/connect/bin/ascp  -Q -k1 -P 33001 -l300M emblwhub@dkfzaspera.dkfz-#heidelberg.de:hipo_005/sequencing/rna_sequencing/view-by-pid/${sampleName} /scratch/aluetge/rawdata


    cd $workingDir
    
    
    #Get the fastqc files
    numFastqFile=$(ls -1 ${pathRawdata}/${sampleName}/tumor/paired/*/sequence/ | wc -l)
    numRuns=$(ls -1 ${pathRawdata}/${sampleName}/tumor/paired/ | wc -l)
    
        if [ $numRuns -eq 1 ]
        then
            
            if [ $numFastqFile -eq 2 ]
            then
            fastqFile1=${pathRawdata}/${sampleName}/tumor/paired/*/sequence/*_R1*.fastq.gz
            fastqFile2=${pathRawdata}/${sampleName}/tumor/paired/*/sequence/*_R2*.fastq.gz
        
            echo There are two files for R1 and R2 
            echo
            
            elif [ $numFastqFile -eq 8 ]
            then
            fastqFile1=$(printf '%s %s %s %s' ${pathRawdata}/${sampleName}/tumor/paired/*/sequence/*_R1*fastq.gz)
            fastqFile2=$(printf '%s %s %s %s' ${pathRawdata}/${sampleName}/tumor/paired/*/sequence/*_R2*fastq.gz)
            
            
            else
            fastqFile1=$(printf '%s %s' ${pathRawdata}/${sampleName}/tumor/paired/*/sequence/*_R1*fastq.gz)
            fastqFile2=$(printf '%s %s' ${pathRawdata}/${sampleName}/tumor/paired/*/sequence/*_R2*fastq.gz)

            numFast1=$(ls -1 ${pathRawdata}/${sampleName}/tumor/paired/*/sequence/*_R1*.fastq.gz | wc -l)
            numFast2=$(ls -1 ${pathRawdata}/${sampleName}/tumor/paired/*/sequence/*_R2*.fastq.gz | wc -l)
    
            echo There are $numFast1 files for R1 and $numFast2 files for R2 
            echo
            
            fi
            
        elif [ $numRuns -eq 2 ]
        then
        
        run1=$(ls ${pathRawdata}/${sampleName}/tumor/paired/ | head -1)
        run2=$(ls ${pathRawdata}/${sampleName}/tumor/paired/ | tail -1)
        numFastqFile1=$(ls -1 ${pathRawdata}/${sampleName}/tumor/paired/${run1}/sequence/ | wc -l)
        
            if [ $numFastqFile1 -eq 6 ]
            then
            fastqFile1_1=${pathRawdata}/${sampleName}/tumor/paired/${run1}/sequence/*L006_R1*fastq.gz
            fastqFile1_2=${pathRawdata}/${sampleName}/tumor/paired/${run1}/sequence/*L006_R2*fastq.gz
        
            fastqFile2_1=${pathRawdata}/${sampleName}/tumor/paired/${run1}/sequence/*L007_R1*fastq.gz
            fastqFile2_2=${pathRawdata}/${sampleName}/tumor/paired/${run1}/sequence/*L007_R2*fastq.gz
        
            fastqFile3_1=${pathRawdata}/${sampleName}/tumor/paired/${run1}/sequence/*L008_R1*fastq.gz
            fastqFile3_2=${pathRawdata}/${sampleName}/tumor/paired/${run1}/sequence/*L008_R2*fastq.gz
        
            fastqFile4_1=${pathRawdata}/${sampleName}/tumor/paired/${run2}/sequence/*L001_R1*fastq.gz
            fastqFile4_2=${pathRawdata}/${sampleName}/tumor/paired/${run2}/sequence/*L001_R2*fastq.gz
        
            fastqFile1=$(printf '%s %s %s %s' ${fastqFile1_1} ${fastqFile2_1} ${fastqFile3_1} ${fastqFile4_1})
            fastqFile2=$(printf '%s %s %s %s' ${fastqFile1_2} ${fastqFile2_2} ${fastqFile3_2} ${fastqFile4_2})
       
            elif [ $numFastqFile1 -eq 4 ]
            then
            fastqFile1=$(printf '%s %s %s %s' ${pathRawdata}/${sampleName}/tumor/paired/*/sequence/*_R1*fastq.gz)
            fastqFile2=$(printf '%s %s %s %s' ${pathRawdata}/${sampleName}/tumor/paired/*/sequence/*_R2*fastq.gz)
       
       
            else
            fastqFile1_1=${pathRawdata}/${sampleName}/tumor/paired/${run1}/sequence/*_R1*fastq.gz
            fastqFile1_2=${pathRawdata}/${sampleName}/tumor/paired/${run1}/sequence/*R2*fastq.gz
        
            fastqFile2_1=${pathRawdata}/${sampleName}/tumor/paired/${run2}/sequence/*_R1*fastq.gz
            fastqFile2_2=${pathRawdata}/${sampleName}/tumor/paired/${run2}/sequence/*R2*fastq.gz
            
        
            fastqFile1=$(printf '%s %s' ${fastqFile1_1} ${fastqFile2_1})
            fastqFile2=$(printf '%s %s' ${fastqFile1_2} ${fastqFile2_2})
            
            fi
            
        else
        
        fastqFile1=${pathRawdata}/${sampleName}/tumor/paired/*/sequence/*_R1*fastq.gz
        fastqFile2=${pathRawdata}/${sampleName}/tumor/paired/*/sequence/*_R2*fastq.gz
        
        echo There are two files for R1 and R2 
        echo
        
        fi
        
        
    #Start mapping with Salmon

    echo ----Start Mapping with Salmon on $sampleName------------
    echo
    
    #Build an salmon index for quasi-mapping based mode 
    #/g/huber/users/luetge/software/Salmon-0.8.2_linux_x86_64/bin/salmon index -t $refTranscript -i transcripts_index --type quasi -k 31
    
    
   /g/huber/users/luetge/software/Salmon-0.8.2_linux_x86_64/bin/salmon quant -i ${pathIndex}/transcripts_index -l A -1 $fastqFile1 -2 $fastqFile2 -p 10 -o ${workingDir}/${sampleName}   
   
   
   #remove downloaded file
   #cd $pathRawdata
   #rm $sampleName
    
done