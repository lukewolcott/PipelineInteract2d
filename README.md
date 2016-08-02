## PipelineInteract2d

an interactive Processing sketch to manipulate and visualize barcodes, using Javaplex.  Builds on the Javaplex tutorial.

### NOTE: 

This code requires moving between Processing and R.  An improved version of this program is in the InteractiveJPDwB repo.  Go there.

### Setup

In Processing sketch folder PipelineInteract2d, put "PipelineInteract2d.pde" and "data" folder.  In Processing sketch folder PipelineInteract2dBarcode put "PipelineInteract2dBarcode.pde".

### Workflow

Run PipelineInteract2d.pde.  Instructions will appear.  Intervals print to "intervals_p3.txt".  

Run clean_intervals.R script.  Cleaned intervals print to "intervals_R.csv".

Run PipelineInteract2dBarcode.pde.  Plots barcode and saves to "barcodes/barcode.png" in PipelineInteract2d sketch folder.

