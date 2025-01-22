#!/usr/bin/env nextflow

params.fastq_L1 = "${projectDir}/fastq/file1.fastq.gz"
params.fastq_L2 = "${projectDir}/fastq/file2.fastq.gz"
params.outdir = "${projectDir}/results"

/*
 * Define the `MERGE_FASTQ` process to merge the two FASTQ files
 */
process MERGE_FASTQ {

    tag "Merging ${input_fastq_1.baseName} and ${input_fastq_2.baseName}"

    publishDir params.outdir, mode: 'copy'

    input:
        path input_fastq_1
        path input_fastq_2

    output:
        path "merged_${input_fastq_1}"

    script:
    """
    # Merge the two fastq files and then gzip the result
    zcat ${input_fastq_1} ${input_fastq_2} | gzip -1 > merged_${input_fastq_1}
    """
}

/*
 * Workflow
 */
workflow {

    // Create input channels for both fastq files
    reads_ch_1 = Channel.fromPath(params.fastq_L1)
    reads_ch_2 = Channel.fromPath(params.fastq_L2)

    // Merge the fastq files and compress the result
    MERGE_FASTQ(reads_ch_1, reads_ch_2)
}
