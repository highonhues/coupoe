#!/usr/bin/env nextflow

process PATH_COLLECTOR{
    
    conda 'conda install conda-forge::python=3.12.7'
    
    input:
    path samplesheet

    output:
    tuple val(meta),path(reads)

    script:
    """
    #!/usr/bin/env python3
    import pandas as pd
    import os
    df = pd.read_csv("${samplesheet}")
    g = df.groupby(["condition","sample"])[["fastq_1","fastq_2"]].agg(list)
    g["reads"] = g["fastq_1"] + g["fastq_2"]
    g = g.reset_index()

    nf_tuples = g.apply(
        lambda row: ({"id": row["sample"], "condition": row["condition"]}, row["reads"]),
        axis=1
    ).tolist()

    os.makedirs("collected", exist_ok=True)

    for meta, reads in nf_tuples:
        local_reads = []
        for f in reads:
            fname = os.path.basename(f)
            link = os.path.join("collected", fname)
            if not os.path.exists(link):
                os.symlink(f, link)
            local_reads.append(link)

        print(f"{meta}\t{' '.join(local_reads)}")
    



    """

}