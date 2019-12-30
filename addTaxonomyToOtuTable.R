#addTaxonomyToOtuTable.R
# takes input otu table as TSV file generated with biom convert (with no comments)
# appends taxonomy and OTU table header so output can be readily converted to biom using the biom convert command

library(argparse)
parser=ArgumentParser()
parser$add_argument("-i", "--otuTable", help="input tsv formatted OTU table (from biom convert command)")
parser$add_argument("-t", "--taxonomy", help="taxonomy tsv file from qiime export command")
parser$add_argument("-o", "--output", help="output tsv formatted OTU table name")
args=parser$parse_args()

otus <- read.table(args$otuTable, header=T, sep="\t", row.names=1, skip=1)
taxonomy <- read.table(args$taxonomy, header=T, sep="\t", comment.char="")

otus.merged <- merge(otus, taxonomy[,c(1,2)], by.x="row.names", by.y="Feature.ID")
names(otus.merged)[ncol(otus.merged)] <- "taxonomy"
rownames(otus.merged) <- otus.merged$Row.names
otus.merged$Row.names <- NULL

cat("# Constructed from biom file\n", sep="", file=args$output)
cat("#OTU ID\t", sep="", file=args$output, append=T)
write.table(otus.merged, file=args$output, row.names=T, col.names=T, sep="\t", quote=F, append=T)
