for file in *.final;
do 
	cp $file file; 
	~/software/rb-mpi mcmc_unpartitioned.Rev ; 
	cp output/simple.log output/$file.log; 
	cp output/simple.trees output/$file.trees; 
	cp output/simple.majrule.tre output/$file.majrule.tre;  
done	
