SCHEME=${1?Error: Partitioning scheme not provided}
for file in Raw_Datasets/*.final;
do
	echo $file
	cp $file matrix;
	RScript dynamicPartitions.R out $file AIC
	~/software/rb-mpi Scripts/mcmc_partitioned.Rev ;
	rm parts.tsv
	cp output/parted.log output/$file.log;
	cp output/parted.trees output/$file.trees;
	cp output/parted.majrule.tre output/$file.majrule.tre;
done
