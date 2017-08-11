get_signifigant_folds = function(x,y,z)
{
	x.s = split(x, f = x$V2) 
	y.s = split(y, f = y$V2)
	z.s = split(z, f = z$V1)
	for ( i in 1:length(x.s)) 
	{	 
	  	x.o = x.s[[i]]$V1 #bootstraps
		y.o = y.s[[i]]$V1 #actual counts
		z.o = z.s[[i]]$V2 #fold change
		z.mean	= mean(z.o) #mean fc 
		x.sd = sd(x.o) #sd of bootstraps
		x.mean = mean(x.o) #mean of bootstraps 
		z.sc = (y.o - x.mean ) / x.sd 
		pvalue = pnorm(-abs(z.sc))
		#cat(y.o , "," , z.sc , "," , z.mean , "\n") 
		v.n = as.character(unique(x.s[[i]]$V2)) 
	  	cat(v.n, "," , y.o , "," , z.sc , ",", z.mean , ",", pvalue, "\n") 
	}
}


args = commandArgs()
bootcounts = args[6]
actualcounts = args[7]
foldchange = args[8]

btcnt = read.table(bootcounts , header = F , sep = ",") ##bootstrap counts 
actcnt = read.table(actualcounts, header =F, sep = ",") ## actual counts
foldc = read.table(foldchange, header =F , sep  = "\t") ## fold change 


get_signifigant_folds(btcnt, actcnt, foldc )
