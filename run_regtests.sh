# The location of the expat directory


#this tests the read counts and the biome format
source MetaPathwaysrc
python /home/sgeadmin/MetaPathways_Python_Koonkie.3.0/libs/python_scripts/MetaPathways_rpkm.py -c /home/sgeadmin/MetaPathways_Python_Koonkie.3.0/regtests/output/B1/preprocessed//B1.fasta  --rpkmExec /home/sgeadmin/MetaPathways_Python_Koonkie.3.0//executables/redhat/rpkm --rpkmdir regtests/input/reads -O /home/sgeadmin/MetaPathways_Python_Koonkie.3.0/regtests/output/B1/orf_prediction//B1.unannot.gff -o /home/sgeadmin/MetaPathways_Python_Koonkie.3.0/regtests/output/B1/results//rpkm/B1.orf_read_counts.txt -b /home/sgeadmin/MetaPathways_Python_Koonkie.3.0/regtests/output/B1/results//rpkm/B1.orf_read_counts.biom --sample_name  B1 --stats /home/sgeadmin/MetaPathways_Python_Koonkie.3.0/regtests/output/B1/results//rpkm/B1.orf_read_counts_stats.txt --bwaFolder /home/sgeadmin/MetaPathways_Python_Koonkie.3.0/regtests/output/B1/bwa/ --bwaExec /home/sgeadmin/MetaPathways_Python_Koonkie.3.0//executables/redhat/bwa


FILE=regtests/output/B1/results/rpkm/B1.orf_read_counts.txt
if [ -f ${FILE} ]; then
   echo 1. PASSED:  Read counts file \"${FILE}\" created correctly.
else
   echo 1. FAILED:  Read counts file \"${FILE}\" NOT created correctly
fi
echo 


FILE=regtests/output/B1/results/rpkm/B1.orf_read_counts.biom
if [ -f ${FILE} ]; then
   echo 2. PASSED:  Biom file \"${FILE}\" created correctly.
else
   echo 2. FAILED:  Biom file \"${FILE}\" NOT created correctly
fi


