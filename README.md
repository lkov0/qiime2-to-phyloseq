# qiime2-to-phyloseq
Just two tiny scripts that work together to convert .qza files to phyloseq importable biom files. Also outputs tree file in phyloseq ready format.  

Works by executing qiime2_formatForPhyloseq.sh, which is a script that takes an input otu table, taxonomy table, and newick tree from qiime2 and formats the OTU table for downstream processing in phyloseq.
essentially, adds taxonomy metadata column to biom table, regardless of if original OTU table was filtered after generating taxonomy.
takes five positional arguments:
1. path to OTU table object in qza format
2. path to taxonomy table object in qza format
3. path to newick tree file in qza format
4. output file name (no path)
5. path to output directory
6. path to qiime2-to-phyloseq repo
