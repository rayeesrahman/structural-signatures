

get_signifigant_folds = function(x, y , z ,a)
{
	
	v.n = as.character(unique(z$V1))
	for (i in v.n)
	{
		x.s = subset(x,(x$V2 %in% i))
		x.mean = mean(x.s$V1) 
		x.sd = sd(x.s$V1) 
		z.s = subset(z,(z$V1 %in% i))
		z.mean = mean(z.s$V2)
		y.s = subset(y,(y$V2 %in% i))
		z.score = (y.s$V1 - x.mean ) / x.sd

		possibleError <- tryCatch(
      			      	 t.test(z.s$V2, a),
      				 error=function(e) e,
				 silent = T
				 )				 		   
		if(inherits(possibleError, "error")) next
		t.te = t.test(z.s$V2, a)
		cat(i, ",", y.s$V1, ",",  z.score  , "," , z.mean , ",", t.te$p.value , "\n") 
	}
}

args = commandArgs()
btc = args[6] #bootstrap counts
atc = args[7] ## actual counts
fca = args[8] ## fold change 

bscnt = read.table(btc , header = F , sep = ",") ##bootstrap counts 
actcnt = read.table(atc, header =F , sep = ",") ## actual counts
bsfc = read.table(fca, header =F , sep ="\t" ) ## fold change 

bscnt.s = subset(bscnt,(bscnt$V2 %in% bsfc$V1))
actcnt.s = subset(actcnt,(actcnt$V2 %in% bsfc$V1))
bg = rnorm(mean = 0, sd = sd(bsfc$V2) , n = 12168 )
get_signifigant_folds(bscnt.s, actcnt.s , bsfc , bg)


#bg = rnorm(mean = 0, sd = sd(x$V2) , n = 12168000 )
#get_signifigant_folds(df, bg)
#print(as.data.frame(dfs$V1))
