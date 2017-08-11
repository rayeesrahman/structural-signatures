
get_signifigant_folds = function(bg, act , numg , totgene )
{
	for (i in  1:dim(act)[1]) 
	{
		act.name = as.character(actcnt[i,]$V2 ); 
		act.cnt = as.numeric(actcnt[i,]$V1 ); 
		
		bg.name = as.character(bgcnt[match(as.character(actcnt[i,]$V2),bgcnt$V2),]$V2)
		bg.cnt = as.numeric(bgcnt[match(as.character(actcnt[i,]$V2),bgcnt$V2),]$V1)
		#print(bg.name,act.name,  sep =" ")
		##contingency table for fisher exact test 
		##				 human proteome | gene set 	
		##Genes w/  fold        #       |     #
		##Genes w/o fold   18810 - #    | #genes sampled - #
		bg.no.fold = totgene - bg.cnt 
		act.no.fold = numg - act.cnt  
		cont.table = cbind(c(bg.cnt, bg.no.fold), c(act.cnt, act.no.fold) )
		#print(paste(bg.cnt,act.cnt,sep=" "))
		#print(paste(bg.no.fold,act.no.fold,sep=" "))
		res = try(fisher.test(cont.table), silent = TRUE)
		if (class(res) == "try-error")
		{
			next 
		}
		else
		{
			test.fisher = fisher.test(cont.table)
			act.freq = act.cnt / numg 
			bg.freq = bg.cnt / totgene 
			expect.act.cnt = bg.freq * numg 
			logfc = log10( act.freq / bg.freq )
			cat(format(noquote(paste(bg.name, act.cnt, expect.act.cnt, test.fisher$p.value, logfc,  sep=","))),"\n")
		}
		#
		### logfc = log10(freq of fold in gene set / freq of fold in human proteome)
	
	}
}

args = commandArgs()
bg = args[6] #human_proteome_fold_counts.csv
atc = args[7] #actual counts
ng = as.numeric(args[8]) #number of genes  

bgcnt = read.table(bg , header = F , sep = ",") ##background counts 
actcnt = read.table(atc, header =F , sep = ",") ## actual counts
totalgenes = 18810

get_signifigant_folds(bgcnt, actcnt, ng , totalgenes )

# bscnt.s = subset(bscnt,(bscnt$V2 %in% bsfc$V1))
# actcnt.s = subset(actcnt,(actcnt$V2 %in% bsfc$V1))
# bg = rnorm(mean = 0, sd = sd(bsfc$V2) , n = 12168 )
# get_signifigant_folds(bscnt.s, actcnt.s , bsfc , bg)


#bg = rnorm(mean = 0, sd = sd(x$V2) , n = 12168000 )
#get_signifigant_folds(df, bg)
#print(as.data.frame(dfs$V1))
