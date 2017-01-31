# The location of the expat directory
CC=gcc  
LEX=lex  
LEXFLAGS=-lfl
CFLAGS=-C



OS_PLATFORM=linux
#should be the same as the EXECUTABLES_DIR in the template_config.txt file

NCBI_BLAST=ncbi-blast-2.6.0+-x64-linux.tar.gz
NCBI_BLAST_VER=ncbi-blast-2.6.0+
BINARY_FOLDER=executables/$(OS_PLATFORM)


BLASTP=$(BINARY_FOLDER)/blastp
RPKM=$(BINARY_FOLDER)/rpkm
BWA=$(BINARY_FOLDER)/bwa
TRNASCAN=$(BINARY_FOLDER)/trnascan-1.4
FAST=$(BINARY_FOLDER)/fastal
PRODIGAL=$(BINARY_FOLDER)/prodigal

MICROBE_CENSUS=microbe_census
METAPATHWAYS_DB=MetaPathways_DBs
METAPATHWAYS_DB_TAG=Metapathways_DBs_2016-04.tar.xz

GIT_SUBMODULE_UPDATE=gitupdate

all: $(GIT_SUBMODULE_UPDATE) $(BINARY_FOLDER) $(PRODIGAL)  $(FAST)  $(BWA) $(TRNASCAN)  $(RPKM) $(MICROBE_CENSUS) $(METAPATHWAYS_DB)


.PHONY: $(GIT_SUBMODULE_UPDATE)
$(GIT_SUBMODULE_UPDATE):
	@echo git submodule update  trnascan
	git submodule update  --init executables/source/trnascan 

$(TRNASCAN):  
	$(MAKE) $(CFLAGS) executables/source/trnascan 
	mv executables/source/trnascan/trnascan-1.4 $(BINARY_FOLDER)/

$(RPKM):  
	$(MAKE) $(CFLAGS) executables/source/rpkm 
	mv executables/source/rpkm/rpkm $(BINARY_FOLDER)/

$(BWA):  
	$(MAKE) $(CFLAGS) executables/source/bwa 
	mv executables/source/bwa/bwa $(BINARY_FOLDER)/

$(PRODIGAL):  
	$(MAKE) $(CFLAGS) executables/source/prodigal 
	mv executables/source/prodigal/prodigal $(BINARY_FOLDER)/

$(FAST):  
	$(MAKE) $(CFLAGS) executables/source/FAST
	mv executables/source/FAST/fastal $(BINARY_FOLDER)/
	mv executables/source/FAST/fastdb $(BINARY_FOLDER)/

$(BLASTP): $(NCBI_BLAST) 
	@echo -n "Extracting the binaries for BLAST...." 
	tar --extract --file=$(NCBI_BLAST)  $(NCBI_BLAST_VER)/bin
	mv $(NCBI_BLAST_VER)/bin/blastx  executables/$(OS_PLATFORM)/
	mv $(NCBI_BLAST_VER)/bin/blastp  executables/$(OS_PLATFORM)/
	mv $(NCBI_BLAST_VER)/bin/blastn  executables/$(OS_PLATFORM)/
	mv $(NCBI_BLAST_VER)/bin/makeblastdb  executables/$(OS_PLATFORM)/
	rm -rf  $(NCBI_BLAST_VER)
	rm -rf  $(NCBI_BLAST)
	@echo "done" 

$(NCBI_BLAST):
	@echo -n "Downloading BLAST from NCBI website...." 
	wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/$(NCBI_BLAST)
	@echo "done" 

.ONESHELL:
$(MICROBE_CENSUS):
	@echo  "Installing MicrobeCensus...." 
	cd executables/source/MicrobeCensus/
	sudo python setup.py install
	@echo "Testing installation, may take a few minutes...." 
	cd tests; python test_microbe_census.py

$(METAPATHWAYS_DB_TAR):
	@echo  "Fetching the databases...." 
	aws s3 cp s3://wbfogdog/a2ac7fc4db0bfae6c05ca12a5818792d/Metapathways_DBs_2016-04.tar.xz .

$(METAPATHWAYS_DB): $(METAPATHWAYS_DB_TAR)
	@echo  "Unzipping the database...." 
	tar -xvf Metapathways_DBs_2016-04.tar.xz 
  

$(BINARY_FOLDER): 
	@if [ ! -d $(BINARY_FOLDER) ]; then mkdir $(BINARY_FOLDER); fi


clean:
	$(MAKE) $(CFLAGS) executables/source/trnascan clean
	$(MAKE) $(CFLAGS) executables/source/rpkm clean
	$(MAKE) $(CFLAGS) executables/source/prodigal.v2_00 clean
	$(MAKE) $(CFLAGS) executables/source/FAST clean
	$(MAKE) $(CFLAGS) executables/source/bwa clean

remove:
	rm -rf  ../$(OS_PLATFORM)/trnascan-1.4 
	rm -rf ../$(OS_PLATFORM)/fastal  
	rm -rf ../$(OS_PLATFORM)/fastdb  
	rm -rf ../$(OS_PLATFORM)/bwa  
	rm -rf ../$(OS_PLATFORM)/prodigal
	rm -rf ../$(OS_PLATFORM)/rpkm 
