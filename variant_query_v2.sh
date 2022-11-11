
#!/bin/bash

#create a new working directory
mkdir variants_of_interest
cd variants_of_interest 

#loops through input genes and queries ClinVar for defined variant properties. 
for gene in "$@" 
do 
    esearch -db clinvar -query "Breast Cancer AND $gene [GENE] AND (clinsig pathogenic [PROP] OR clinsig drug response [PROP] OR clinsig other [PROP] OR radiation)" | efetch -format docsum | xtract -pattern DocumentSummary -sep "," -element Id accession title > "$gene"_total.txt
    esearch -db clinvar -query "Breast Cancer AND $gene [GENE] AND (clinsig pathogenic [PROP] OR clinsig drug response [PROP] OR clinsig other [PROP] OR radiation) AND intron variant [MCNS]" | efetch -format docsum | xtract -pattern DocumentSummary -sep "," -element Id accession title > "$gene"_intronic.txt
    esearch -db clinvar -query "Breast Cancer AND $gene [GENE] AND clinsig pathogenic [PROP]" | efetch -format docsum | xtract -pattern DocumentSummary -sep "," -element Id accession title > "$gene"_pathogenic.txt
    esearch -db clinvar -query "Breast Cancer AND $gene [GENE] AND clinsig drug response [PROP]" | efetch -format docsum | xtract -pattern DocumentSummary -sep "," -element Id accession title > "$gene"_drug_response.txt
    esearch -db clinvar -query "Breast Cancer AND $gene [GENE] AND clinsig other [PROP]" | efetch -format docsum | xtract -pattern DocumentSummary -sep "," -element Id accession title > "$gene"_other.txt
    esearch -db clinvar -query "Breast Cancer AND $gene [GENE] AND radiation" | efetch -format docsum | xtract -pattern DocumentSummary -sep "," -element Id accession title > "$gene"_radiation.txt
done 

#loops through files created above and counts the variants (lines) per file
ls | grep '.txt' | while read -r line ; 
do 
    wc -l $line
done > totals_per_variant_type.txt

#accumulates files into digestable file structure
mkdir totals
mkdir intronic
mkdir pathogenic
mkdir drug_response
mkdir other 
mkdir radiation 
mv *_total.txt totals
mv *_intronic.txt intronic
mv *_pathogenic.txt pathogenic
mv *_drug_response.txt drug_response
mv *_other.txt other
mv *_radiation.txt radiation
cd .. 
