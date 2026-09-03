# run lefse
lefse_format_input.py OTU_GFP_9_allname2.tab OTU_GFP_9_allname.in -c 1 -s -1 -u 2 -o -1  --output_table OTU_GFP_9_lefse.tab
lefse_run.py OTU_GFP_9_allname.in OTU_GFP_9_allname.res
lefse_plot_res.py OTU_GFP_9_allname.res OTU_GFP_9_allname.pdf  --format pdf
lefse_plot_cladogram.py OTU_GFP_9_allname.res OTU_GFP_9_allname.cladogram.pdf  --format pdf
lefse_plot_cladogram.py OTU_GFP_9_allname.res2 OTU_GFP_9_allname.sig.cladogram.pdf  --format pdf  
