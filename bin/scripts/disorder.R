#require("ggplot2")

args = commandArgs()
f = args[6]
a = args[7]
b = args[8]

x = read.table(f , header = F , sep = ",") ##bootstrap counts 
y = read.table(a, header =F) ## actual counts
z = read.table(b, header =F) ## fold change 

x.sd = sd(x$V1)
x.mean = mean(x$V1)
z.mean = mean(z$V1)

z.sc = (y$V1 - x.mean ) / x.sd 
cat (y$V1, ",", z.sc, ",", z.mean , "\n")