# RSV glycosylation analysis – Bangladeshi RSV-A / RSV-B (2024–2025)

Code to reproduce the N- and O-glycosylation figures (Figures 8–13) and the residue-level supplementary tables (Supplementary Tables S2–S28, Supplementary Figures 9–14) of the manuscript *Genomic Surveillance of Respiratory Syncytial Virus among Patients with Acute Respiratory Illness in Bangladesh*.

Only the most relevant positions are labelled in the main figures; every position is given in the supplementary tables.

## Methods in brief
* **N-glycosylation:** NetNGlyc 1.0 on translated **protein** sequences; sequons N-X-S/T (X ≠ P); site called when potential ≥ 0.5.
* **O-glycosylation:** NetOGlyc 4.0 on translated **protein** sequences; a Ser/Thr is called when the score > 0.5.
* **References:** RSV-A **KY654518.1** (ON1, 321-aa G, 574-aa F) and RSV-B **OP975389.1** (574-aa F, 310-aa G). 43 RSV-A and 6 RSV-B Bangladeshi isolates. These were chosen as the closest of the candidate references to our isolates (Supplementary Table S31, `scripts/13_reference_comparison.py`). KY654518.1 is also the reference MIRA used to assemble the RSV-A genomes; for RSV-B MIRA used KF640637.1 and Nextclade uses OP975389.1. KF640637.1, PP109421.1 (Nextclade RSV-A) and NC_001803.1 (A2) are kept only for comparison (`data/refs/`, `data/alt_reference_sets/`).
* **Numbering:** KY654518.1 is an ON1 genome, so the isolate G proteins have the same length and the same numbering as the reference; no mapping or offset is needed. Substitutions are called from a global alignment (Biopython `PairwiseAligner`, BLOSUM62, gap open −6, extend −0.5). A stop-loss (RSV-B G *311Q) is counted as one event.
* **Check against MIRA:** `tests/check_against_MIRA_report.py` compares our F and G calls with the MIRA variant report (`data/MIRA_variant_report_Data_1.xlsx`, needs `openpyxl`) for all 49 isolates (98 comparisons, 0 differences).
* **Antigenic sites (F):** Ø 61–69 and 196–212, V 160–180, II 254–277, I 382–396, IV 422–438.
* **G regions:** TM 38–66, MLR-I 67–163, CCD 164–181, CX3C 182–186, HBD 187–198, MLR-II 199–end.

> **Important:** NetOGlyc/NetNGlyc must be run on *protein* (amino-acid) FASTA files. Runs on nucleotide sequences or mistranslated sequences give invalid results (positions beyond the protein length, thousands of false sites).

## Repository layout
```
data/                 input files (MIRA protein FASTA with references, NetOGlyc outputs, NetNGlyc PDF reports, MIRA variant report, reference proteins in refs/, alternative reference sets in alt_reference_sets/)
scripts/              analysis + plotting scripts (numbered in running order)
run_all.sh            runs everything
output/               regenerated figures/tables (created by run_all.sh)
manuscript_figures/   the exact figures used in the manuscript (PNG + PDF)
manuscript_tables/    the exact tables used in the supplement (CSV)
```

## Requirements
Python ≥ 3.9 and `pip install -r requirements.txt` (pandas, numpy, matplotlib, adjustText, biopython, openpyxl). The NetNGlyc reports are PDFs read with **pdftotext** (poppler-utils: `sudo apt install poppler-utils`, `brew install poppler`).

## Run
```bash
pip install -r requirements.txt
./run_all.sh
```

## Figure -> script -> supplementary table
| Figure | Script(s) | Output table | Supplementary table | Input in `data/` |
|---|---|---|---|---|
| 8 F substitutions | `10_substitutions.py`, `11_fig8_9_substitution_maps.py` | `output/tables/calls_F_*.csv`, `summary_F_*.csv` | S2, S13 | `F_RSV[AB]_MIRA_proteins_with_ref.fasta` |
| 9 G substitutions | same | `calls_G_*.csv`, `summary_G_*.csv` | S3, S14 | `G_RSV[AB]_MIRA_proteins_with_ref.fasta` |
| 8-13 key positions (n/N) | `12_key_positions_n_over_N.py` | `Key_positions_n_over_N_Figures8-13.csv` | (not in the supplement; same counts are in S2, S3, S13, S14, S23–S27) | all of the above |
| 10a/10b N-glyc F | `05a/05b`, `06a/06b` | Fig10a/10b CSV | S23 | `NetNGlyc_F_RSV[AB].pdf` |
| 11a/11b N-glyc G | `07a-c`, `08a/08b` | Fig11a/11b CSV | S24 | `NetNGlyc_G_RSV[AB].pdf` |
| 12a/12b O-glyc F | `01_...py A\|B [main]`, `02_...py` | Fig12a/12b CSV | S25 | `NetOGlyc_F_RSV[AB].tvs.txt` |
| 13a O-glyc G RSV-A | `03_...py`, `09_...py` | Fig13a CSV | S26 | `NetOGlyc_G_RSVA.txt` |
| 13b O-glyc G RSV-B | `04_...py`, `09_...py` | Fig13b CSV | S27 | `NetOGlyc_G_RSVB.txt` |
| Sample IDs behind every count | `14_sample_ids.py` | `SampleIDs_*.csv` | S23–S27 (Sample IDs column) | calls, NetNGlyc/NetOGlyc outputs, protein FASTAs |
| Amino acid changes per gene, Sample IDs | `15_nextclade_table_sample_ids.py`, `16_all_gene_mutation_tables.py` | `Mutations_by_gene_S2_S20.csv` | S2–S20 | F/G calls (`output/tables/calls_*`), MIRA report (RSV-A other genes), Nextclade table `Nextclade_tables_S2-S20_mutations.csv` (RSV-B other genes) |
| 6, 7 changes per gene and isolate | `17_figures6_7_gene_burden.py` | `Gene_burden_per_isolate_A/B.csv` | S2–S20 | `Mutations_by_gene_S2_S20.csv` |
| Reference choice | `13_reference_comparison.py` | `Reference_comparison_protein_level.csv` | S28 | `data/refs/`, MIRA FASTAs |

Main figures are the simplified versions; the complete versions are Supplementary Figures 9-14. Figures 8 and 9 are written to `output/figures/`.

Substitution calls: each isolate is globally aligned to its reference (KY654518.1 or OP975389.1). `tests/independent_recount.py` recounts every position column by column as a cross-check.

Known discrepancy: three RSV-B changes listed in the Nextclade-based supplement tables (F L173S, F R209Q, G E290K) are not reproduced from the protein FASTA; this is annotated in the supplement and has not been resolved.

`01_…` with the extra argument `main` draws the simplified main-text version (stems with score ≥ 0.20, changed and labelled sites); without it, the complete version for the supplement.

`run_all.sh` ends with `tests/check_outputs.py`, which compares every regenerated table with `manuscript_tables/`.

## Notes
* The values in the tables are fully reproducible. Label *positions* in some figures are placed by `adjustText` and can shift slightly between runs; `manuscript_figures/` holds the exact versions used in the paper.
* Isolate names in the input files are those of the study laboratory; remove or replace them if you do not want them public.
* NetNGlyc and NetOGlyc are DTU Health Tech web servers (Gupta & Brunak, Pac Symp Biocomput 2002; Steentoft et al., EMBO J 2013). Their raw outputs are included in `data/` so that the analysis can be repeated without re-running the servers.

## Citation
If you use this code, please cite the manuscript (add the reference/DOI once available).


## RSV-B genes other than F and G (script 18)
`scripts/18_rsvb_other_genes_vs_OP975389.py` rebuilds each RSV-B isolate protein from the KF640637.1 protein plus the substitutions in the MIRA variant report (MIRA used KF640637 for RSV-B) and compares it with the OP975389.1 GenBank proteins (`data/refs/OP975389.1.gb`, `data/refs/KF640637.gb`). Positions follow OP975389.1; M uses the canonical start (METYVNK...), because the OP975389.1 record annotates a 22-aa N-terminal extension. Residues called X, "." or "~" are not counted (listed in `output/tables/RSVB_other_genes_ambiguous_positions.csv`). The result reproduces 21 of the 25 Nextclade RSV-B changes in these genes exactly; the other four (L S2095R, M2-1 R151Q, NS2 D6N, NS2 D53N) are not supported by the MIRA protein calls.
