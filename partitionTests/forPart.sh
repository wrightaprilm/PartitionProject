SCHEME=${1?Error: Partitioning scheme not provided}
for file in *.final;
do 
	cp $file file;
	R CMD BATCH dynamicPartitions.R pwd $file $SCHEME
	~/software/rb-mpi Mk_parted_Final.Rev ; 
	cp output/simple.log output/$file.log; 
	cp output/simple.trees output/$file.trees; 
	cp output/simple.majrule.tre output/$file.majrule.tre;  
done	
