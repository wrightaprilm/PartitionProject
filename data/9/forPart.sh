SCHEME=${1?Error: Partitioning scheme not provided}
for file in *.final;
do
	echo $file
	cp $file matrix;
	RScript ../../Scripts/dynamicPartitions.R out $file AIC
	~/software/rb-mpi ../../Scripts/mcmc_partitioned.Rev ;
	rm parts.tsv
	cp output/parted.log output/$file.log;
	cp output/parted.trees output/$file.trees;
	cp output/parted.majrule.tre output/$file.majrule.tre;
done
