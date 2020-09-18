#! /bin/bash
#BSUB -J CLLalign
#BSUB -n 10
#BSUB -o /g/huber/users/luetge/jobs/output/mappingParam/adapter/STAR_on_ARGUMENT_1_CLL_26.06.17_out.txt
#BSUB -e /g/huber/users/luetge/jobs/output/mappingParam/adapter/STAR_on_ARGUMENT_1_CLL_26.06.17_error.txt

#Aim: Write a Script to map fastqc files using STAR

#Setting Variables
date=mappingParam           #25062017
pathRawdata=/scratch/aluetge/rawdata
#/g/huber/projects/nct/cll/RawData/RNASeq
pathStar=/g/software/bin/STAR
workDir=/g/huber/users/luetge/results/star                                                            
workingDir=${workDir}/${date}/adapter
resPath=/g/huber/users/luetge/results/htseq
resultPath=${resPath}/${date}/adapter
pathBam=/scratch/aluetge/adapter/bamfiles


mkdir $resultPath
mkdir $workingDir

echo WorkingDir:$workingDir
echo

#Start Mapping

echo --------Start mapping with STAR------------
echo

#Create a loop to read in fastqc files from a list and map them using STAR and create counttables using htseq

for sampleName in ARGUMENT_1
do


#download sample file
#/g/huber/users/luetge/software/sshpass-1.06/sshpass -v -p 'N-T!cI4P6*7U9j5Y' /g/huber/users/dietrich/aspera/connect/bin/ascp  -Q -k1 -P 33001 -l300M emblwhub@dkfzaspera.dkfz-heidelberg.de:hipo_005/sequencing/rna_sequencing/view-by-pid/${sampleName} /scratch/aluetge/rawdata
  
    
    #not neccessary while outputfiles are stored at scratch, but change if enough space is on the huber drive
    cd $pathBam
    
    #mkdir $sampleName
    #cd $sampleName
    
    #Get the fastqc files (different formats and numbers of runs and lanes --> nested loops to consider all automatically (probably needs to be adjusted for single cases)
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
            fastqFile1=$(printf '%s,%s,%s,%s' ${pathRawdata}/${sampleName}/tumor/paired/*/sequence/*_R1*fastq.gz)
            fastqFile2=$(printf '%s,%s,%s,%s' ${pathRawdata}/${sampleName}/tumor/paired/*/sequence/*_R2*fastq.gz)
            
            else
            fastqFile1=$(printf '%s,%s' ${pathRawdata}/${sampleName}/tumor/paired/*/sequence/*_R1*.fastq.gz)
            fastqFile2=$(printf '%s,%s' ${pathRawdata}/${sampleName}/tumor/paired/*/sequence/*_R2*.fastq.gz)

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
        
            fastqFile1=$(printf '%s,%s,%s,%s' ${fastqFile1_1} ${fastqFile2_1} ${fastqFile3_1} ${fastqFile4_1})
            fastqFile2=$(printf '%s,%s,%s,%s' ${fastqFile1_2} ${fastqFile2_2} ${fastqFile3_2} ${fastqFile4_2})
       
            elif [ $numFastqFile1 -eq 4 ]
            then
            fastqFile1=$(printf '%s,%s,%s,%s' ${pathRawdata}/${sampleName}/tumor/paired/*/sequence/*_R1*fastq.gz)
            fastqFile2=$(printf '%s,%s,%s,%s' ${pathRawdata}/${sampleName}/tumor/paired/*/sequence/*_R2*fastq.gz)
       
       
            else
            fastqFile1_1=${pathRawdata}/${sampleName}/tumor/paired/${run1}/sequence/*_R1*fastq.gz
            fastqFile1_2=${pathRawdata}/${sampleName}/tumor/paired/${run1}/sequence/*R2*fastq.gz
        
            fastqFile2_1=${pathRawdata}/${sampleName}/tumor/paired/${run2}/sequence/*_R1*fastq.gz
            fastqFile2_2=${pathRawdata}/${sampleName}/tumor/paired/${run2}/sequence/*R2*fastq.gz
            
        
            fastqFile1=$(printf '%s,%s' ${fastqFile1_1} ${fastqFile2_1})
            fastqFile2=$(printf '%s,%s' ${fastqFile1_2} ${fastqFile2_2})
            
            fi
       
        else
        
        fastqFile1=${pathRawdata}/${sampleName}/tumor/paired/*/sequence/*_R1*fastq.gz
        fastqFile2=${pathRawdata}/${sampleName}/tumor/paired/*/sequence/*_R2*fastq.gz
        
        echo There are two files for R1 and R2 
        echo
        
        fi
        
        
    #Start mapping with STAR

    echo ----Start Mapping with STAR on $sampleName------------
    echo
    
    /g/software/bin/STAR   --runThreadN 12   --genomeDir /g/huber/users/luetge/data/genome/star/   --readFilesIn $fastqFile1 $fastqFile2  --readFilesCommand zcat  --outFileNamePrefix ${pathBam}/${sampleName} --outSAMtype BAM SortedByCoordinate --clip3pAdapterSeq AGATCGGAAGAG 
    
    echo ----finish mapping using STAR on $sampleName ----------------
    echo
    
    #delete rawdata files
    #rm -rf ${pathRawdata}/${sampleName}
   
   
    #create count tables from bam files of aligned samples using Htseq

    echo ------------ Creating counttable of $sampleName started ----------------
    echo

    sample=${pathBam}/${sampleName}Aligned.sortedByCoord.out.bam
    gtfFile=/g/huber/users/rabe/software/Homo_sapiens.GRCh37.75/Homo_sapiens.GRCh37.75.gtf

    python2.7-with-htseq -m HTSeq.scripts.count -m intersection-nonempty -f bam -s no -r pos $sample $gtfFile > ${resultPath}/${sampleName}counts.out

    #using default mode union. Change to intersection mode if neccessary
    

    echo ------------ Creating counttable of $sampleName finished ----------------
    echo


    
done