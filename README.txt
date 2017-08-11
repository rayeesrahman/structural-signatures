Working Directory: /mnt/c/Users/rayees/Desktop/dev-structural-signatures/structural-signatures 
Usage:
	 -d Dataset 
		*required* 
	 -n Name (prefix) for output files  
		*required* 
	 -b number of Bootstraps 
		<default 0> 
	 -g number of differencially expressed Genes sorted by p-value 
		<default all differencitally expressed genes>
	 -p number of Parallel bootstraps to run
		<default 1>
	 -l switch if gene List is being used instead of DToXs data
		*required if a gene list is being used*
	 -t Type of genes in DToXs data <OVER> <UNDER> <BOTH>
		*Required if input is DToXs*
	 -h print Help

Help:
	-d: data can be either DToXs data (expected default) or gene list
	    	*if data is a gene list then -l must be called*
	-n: name (prefix) for all output files
	-b: number of total bootstraps, the default value is 0 meaning no bootstraps will run
		*0 bootstraps implies no statistics for 2D structural features*
		*at least 30 bootstraps are required for meaningful statistics*
	-p: number of bootstraps to run in parallel
		default is 1
		for example if -b is 100 and -p is 10 then 10 bootstraps will be run in parallel til a total of 100 bootstraps are run
		if -b is 0 (default) then -p does nothing
	-l: switch to tell script that a gene list is being used instead of a DToXs data
		A gene list is a text file that has each gene on a newline
			**UNIPROT identifiers only!**
		DToXs data is the default data for this script
	-t) type of genes to extract from DToXs data:
		<OVER>expressed genes
		<UNDER>expressed genes
		<BOTH>
		Please input either OVER, UNDER or BOTH, case sensitive, to -t
	-T) scop minimum threshold default 80 *OPTIONAL PARAMETER*
	-r) minumum disordered Region length default 30 *OPTIONAL PARAMETER*
	-h) prints this helpful page! ;)

An example run of this pipeline using DToXs data looks like this:

	./complete_sec_stuct_pipeline.sh -d Human.A-Hour.48-Plate.4-Calc-CTRL.AXI.tsv -n A,AXI -b 100 -p 10 -t OVER -g 100

This translates to:
	From the Human.A-Hour.48-Plate.4-Calc-CTRL.AXI.tsv file (-d Human.A-Hour.48-Plate.4-Calc-CTRL.AXI.tsv )
	all output should have the prefix: A,AXI (-n A,AXI)
	bootstrap the data 100 times (-b 100)
	10 boostraps at a time (-p 10 )
	only look at overexpressed signifigant genes (-t OVER)
	and only obtain the top 100 overrepresented genes sorted by p-value ( -g 100 )

An example run of this pipeline using a Gene List data looks like this:

	./complete_sec_stuct_pipeline.sh -d DEGs.list -l -n DEGs -b 100 -p 10

This translates to:
	From the DEGs.list  file (-d DEGs.list)
	which is a list of genes (-l)
	all output should have the prefix: DEGs (-n DEGs)
	bootstrap the data 100 times (-b 100)
	10 boostraps at a time (-p 10 )

Notice that we call the -l option for the gene list example and not for the DToXs example.
Also notice that we call the -t & -g options for the DToXs example and not for the gene list example.
	The -g option can be left blank to obtain all of the signifigantly expressed genes in the DToXs dataset.

