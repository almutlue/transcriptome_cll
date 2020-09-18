#! /bin/bash
#BSUB -J CLLalign
#BSUB -n 10
#BSUB -o /g/huber/users/luetge/jobs/output/adapter/celllines/STAR_on_ARGUMENT_1_CLL_23.08.17_out.txt
#BSUB -e /g/huber/users/luetge/jobs/output/adapter/celllines/STAR_on_ARGUMENT_1_CLL_23.08.17_error.txt

#Aim: Write a Script to map fastqc files using STAR

#Setting Variables
date=celllines           #25062017
pathRawdata=/g/huber/projects/nct/cll/RawData/RNASeq/CellLines/161214_ST-K00207_0049_BHG5N3BBXX
#Burkitt
pathStar=/g/software/bin/STAR
resPath=/g/huber/users/luetge/results/htseq
resultPath=${resPath}/${date}
pathBam=/scratch/aluetge/celllines/bamfiles


#mkdir $resultPath


#Start Mapping

echo --------Start mapping with STAR------------
echo

#Create a loop to read in fastqc files from a list and map them using STAR and create counttables using htseq

for sampleName in ARGUMENT_1
do


            fastqFile1=${pathRawdata}/${sampleName}/fastq/*_R1.fastq.gz
            fastqFile2=${pathRawdata}/${sampleName}/fastq/*_R2.fastq.gz
        
            echo There are two files for R1 and R2 
            echo
            
            
        
    #Start mapping with STAR

    echo ----Start Mapping with STAR on $sampleName------------
    echo
    
    /g/software/bin/STAR   --runThreadN 12   --genomeDir /g/huber/users/luetge/data/genome/star/   --readFilesIn $fastqFile1 $fastqFile2  --readFilesCommand zcat  --outFileNamePrefix ${pathBam}/${sampleName} --outSAMtype BAM SortedByCoordinate --clip3pAdapterSeq AGATCGGAAGAG
    
    echo ----finish mapping using STAR on $sampleName ----------------
    echo
    
      
   
    #create count tables from bam files of aligned samples using Htseq

    echo ------------ Creating counttable of $sampleName started ----------------
    echo

    sample=${pathBam}/${sampleName}Aligned.sortedByCoord.out.bam
    gtfFile=/g/huber/users/rabe/software/Homo_sapiens.GRCh37.75/Homo_sapiens.GRCh37.75.gtf

    python2.7-with-htseq -m HTSeq.scripts.count -f bam -s no -r pos $sample $gtfFile > ${resultPath}/${sampleName}counts.out

    #using default mode union. Change to intersection mode if neccessary
    

    echo ------------ Creating counttable of $sampleName finished ----------------
    echo


    
done