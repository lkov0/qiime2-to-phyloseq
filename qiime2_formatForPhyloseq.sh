# qiime2_formatForPhyloseq.sh
# script to take an input otu table, taxonomy table, and newick tree from qiime2 and format the OTU table for downstream processing in qiime2_formatForPhyloseq
# essentially, adds taxonomy metadata column to biom table, regardless of if original OTU table was filtered after generating taxonomy
# takes five positional arguments:
# 1. path to OTU table object in qza format
# 2. path to taxonomy table object in qza format
# 3. path to newick tree file in qza format
# 4. output file name (no path)
# 5. path to output directory

otuTable=$1
treeFile=$2
taxonomy=$3
output=$4
path=$5

qiime tools export --input-path $otuTable --output-path $path/exported
qiime tools export --input-path $taxonomy --output-path $path/exported
qiime tools export --input-path $treeFile --output-path $path/tree
biomTax=$path/biom-taxonomy.tsv
echo "#OTUID    taxonomy    confidence" > $biomTax
sed '1d' $path/exported/taxonomy.tsv >> $biomTax

biom convert -i $path/exported/feature-table.biom -o $path/exported/feature-table.tsv --to-tsv
sed "s/#//g" $path/exported/feature-table.tsv > $path/exported/feature-table.forR.tsv

Rscript addTaxonomyToOtuTable.R -i $path/exported/feature-table.forR.tsv -t $path/exported/taxonomy.tsv -o $path/exported/feature-table.withTax.tsv

biom convert -i $path/exported/feature-table.withTax.tsv -o $output --to-hdf5 --table-type="OTU table" --process-obs-metadata taxonomy

rm -rf $path/exported



