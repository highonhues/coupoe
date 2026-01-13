# COUP-TFII OE/KO scRNA-seq (WIP)

Actively building this out. This is mainly to track the analysis flow, what’s implemented. Will be adding documentation to follow like a code based tutorial if you want to recreate workflow steps for your own analysis. If you are from the Dinh Lab or from the Lee Lab and have any questions with your analysis, please don't hesitate to reach out! I am happy to help.

## Project Summary
TLDR of the research question: How does perturbing COUP-TFII affect venular identity across endothelial cells? Is there evidence that ETS-associated TF contribute to this regulation?

Built off of the hypothesis that COUP-TFII and ETS contribute to PCV identity through binding of cis-regulatory elements in non-coding regions of PCV genes/addressins.
COUP-TFII OE/KO effects in PP + MLN endothelial compartments (10x multi: RNA + HTO). Goal is to isolate BEC subsets (HEC, PCV, CRP, arterial, capillary, TrEC), run  DGE, and quantify shifts in ETS/NKX/COUP-driven endothelial programs.

## My Contributions (Technical Notes)
- Wrote full preprocessing to integration to annotation workflow (R/Seurat).
- Built pseudobulk engine with random-chunking for OE replicates.
- Automated fgsea (C2 + C3) with motif filters + pathway-level exports.
- Built consistent directory structure + helper IO functions.
- All scripts SLURM-ready (HPC + local compatible). The nextflow pipeline will be cloud compatible! On the HPC since we can't use docker we use using conda environments in our Nextflow pipeline. Dinh Lab students can check per tool performance on their Seqera Cloud account. I will help setup your Tower Agent once you have access to the HPC.
- Custom plotting wrappers (Cairo outputs, patchwork-safe) for high quality journal plot requirements.

## Pipelines (High-Level Notes)
### 1. Cell Ranger / Preprocessing
- `cellranger multi` with hashing demux into WT / OE / KO. I designed a pipeline step in case you prefer to use `cellranger count` and `CITE-seq` on the v3 chemistry with custom params. The output results are comparable to HTO demux and MULTIseqDemux. You can use the comparitive analysis script on your own data.
- Initial QC: nFeature/nCount/Ribo/MT filtering (tissue-specific thresholds).
- Seurat object construction for multi assay (RNA + HTO assays). Seurat v5 object stores samples in layers.

### 2. Integration / Clustering
- Cellranger outputs are made into single seurat objects for integration usng automated script that reads from an excel file. Excel MUST have absolute paths. (Windows paths are converted to the correct format so don't worry about that!!)
- Highly-variable feature selection (VST) top 3000.
- PCA -> MNN graph construction -> UMAP.
- FastMNN / IntegrateLayers depending on tissue batch. Cell cycle effects removal: workflows exist for both pre and post integration + visualizations for you to verify results.
- Broad cluster IDs: BEC / LEC / FRC / Lymphocytes. Contaminants removed with subset on cluster identity and module scores.

### 3. Endothelial Subsetting
- Subset BEC cluster(s). NOTE: You must reintegrate post clustering!
- Re-run PCA/UMAP on BEC-only.
- Marker-based annotation for HEC/PCV/artery/capillary/CRP/TrEC.
- Remove lymphoid/FRC contamination based on non-BEC signatures.

### 4. Pseudobulk DGE(edgeR-limma)
- Custom pseudoreplication for OE imbalance (n_pseudo = 3 replicate chunks).
- Convert Seurat -> SCE -> pseudobulk count matrix per (sample × replicate).
- DGE for pairwise comparison. ORA based on GO performed per cell type but I don't find it very informative.
- Export topTables, ranked logFC vectors for GSEA.

### 5. FGSEA (C2 + C3)
- C3 TFT gene sets (`msigdbr(collection="C3")`).
- C2 KEGG gene sets using KEGGREST. (Batch download is prohibited and 350 API calls are VERY slow. So once you have the data frm the DB, save it as an rds object). It will also be in the Dinh lab drive.
- Run fgsea on ranked logFC.
- Filter C3 for ETS/ERG/ELF/ETV motifs.
- KEGG subset: pathways with ≥1 ETS gene + FDR < 0.25.
- Pathview rendering per comparison to show upregulation/downregulation.

### 6. Outputs to Save
- UMAPs (all + per cell type).
- QC plots (violin, feature scatter, HTO mixing).
- Volcano plots (pseudobulk).
- KEGG PDFs/PNGs.
- Tables: DGE, fgsea, ETS-filtered KEGG.
- If a data is generated at any step, it is saved in its associated directory automatically :) 

## WIP Results Notes
- C3 TFT results not informative for OE/KO shifts.
- KEGG shows consistent regulation in ETS-linked vascular pathways.
- HEC markers match expected directionality for KO (Madcam1↓, St6gal1↓).
- Some PP vs MLN differences. Will not include MLN data in thesis.

## Directory Structure (Draft)
- Will merge the local with main and remove the former for complete structure. The exploratory and comparitive analysis scripts will be stored differently than the final workflow.
