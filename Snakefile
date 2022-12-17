

configfile: "config.yaml"

rule all:
    "busco_{sample}/"

rule porechop_trim:
    input:
        fss="data/samples/{sample}.fastq.gz"
    output:
        "trimmed/{sample}.trimmed.fastq"
    conda: 
        "envs/conda-porechop.yaml"
    shell: 
        "porechop -i {input.fss} -o {output} -t 4 --barcode_threshold 60 --barcode_diff 1"

rule kraken2_viral:
    input:
        trimmed_reads="trimmed/{sample}.trimmed.fastq",
        database="/../../media/cinnet/PortableSSD1/kraken2_db/human_genome/"
    output:
        report_kraken2="kraken2_reports/{sample}_viral.txt",
        classified_out="trimmed/{sample}_viral_reads.fastq"
    conda:
        "envs/conda-kraken2.yaml"
    shell:
        "kraken2 --db {input.database} {input.trimmed_reads} --report {output.report_kraken2} --classified-out {output.classified_out}"

rule spades_assembly:
    input:
        "data/sample_{sample}.fastq"
    output:
        "assembly/sample_{sample}/contigs.fasta"
    shell:
        "spades.py --pe1-1 {input[0]} --pe1-2 {input[1]} -o {output[0]}"

rule AMR_detection:
	



