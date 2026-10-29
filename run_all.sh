#!/usr/bin/env bash
# Reproduce every figure and supplementary table (run from the repository root).
set -euo pipefail
cd "$(dirname "$0")"
S=scripts
# Figure 12a/12b: O-glycosylation of F  (main = simplified, supplementary = all Ser/Thr)
for SUB in A B; do
  python3 $S/01_O-glyc_F_figure12ab.py $SUB main
  python3 $S/01_O-glyc_F_figure12ab.py $SUB
done
python3 $S/02_O-glyc_F_tables.py
# Figure 13a/13b: O-glycosylation of G
python3 $S/03_O-glyc_G_RSVA_figure13a.py
python3 $S/04_O-glyc_G_RSVB_figure13b.py
# Figure 10a/10b: N-glycosylation of F
python3 $S/05a_N-glyc_F_RSVA_parse.py;  python3 $S/05b_N-glyc_F_RSVA_figure10a.py
python3 $S/06a_N-glyc_F_RSVB_parse_table.py;  python3 $S/06b_N-glyc_F_RSVB_figure10b.py
# Figure 11a/11b: N-glycosylation of G
python3 $S/07a_N-glyc_G_RSVA_parse.py;  python3 $S/07b_N-glyc_G_RSVA_table.py;  python3 $S/07c_N-glyc_G_RSVA_figure11a.py
python3 $S/08a_N-glyc_G_RSVB_parse_table.py;  python3 $S/08b_N-glyc_G_RSVB_figure11b.py
# Main-draft (simplified) Figures 13a/13b and supplementary full versions
python3 $S/09_G_O-glyc_main_figures13ab.py
# Figures 8/9: substitution maps from the MIRA protein FASTA files, plus the key-position n/N table
python3 $S/10_substitutions.py
python3 $S/11_fig8_9_substitution_maps.py
python3 $S/12_key_positions_n_over_N.py
python3 scripts/13_reference_comparison.py
python3 scripts/14_sample_ids.py
python3 scripts/15_nextclade_table_sample_ids.py
python3 scripts/18_rsvb_other_genes_vs_OP975389.py
python3 scripts/16_all_gene_mutation_tables.py
python3 scripts/17_figures6_7_gene_burden.py
python3 tests/independent_recount.py
python3 tests/check_against_MIRA_report.py
python3 tests/check_outputs.py
echo "Done. Results are in output/"
