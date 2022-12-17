

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

rule spades_assembly:
    input:
        "data/sample_{sample}.fastq"
    output:
        "assembly/sample_{sample}/contigs.fasta"
    shell:
        "spades.py --pe1-1 {input[0]} --pe1-2 {input[1]} -o {output[0]}"

# AMR Deteksiyon veritabanları indirme ve analizleri


# Elde edilen verilerin görselleştirilmesi için kullanılacak scriptler.

# Histogram

# Pavian

rule AMR_detection:
	



