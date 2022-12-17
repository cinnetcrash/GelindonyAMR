

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

rule flye:
    input:
        viral_reads="trimmed/{sample}_viral_reads.fastq",
    output:
        "assembly/{sample}.fasta"
    params:
        output_dir="assembly/flye/"
    conda: srcdir("envs/conda-flye.yaml")
    shell:
        "flye --nano-corr {input.viral_reads} --out-dir {params.output_dir} --genome-size 0.2m --meta -t 8"


rule busco:
    input:
        baam="data/genome/{sample}.bam"
    output:
        "busco_{sample}"
    params:
        exit="busco_output/"
    conda:
        "envs/conda-porechop.yaml"
    shell:
        "busco -i {input.baam} -o {params.exit} --auto-lineage-prok -m genome"