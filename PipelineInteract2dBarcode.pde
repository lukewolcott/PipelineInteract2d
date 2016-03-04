// Reads in intervals_R.csv from the PipelineInteract2d sketch folder,
// then plots barcodes and saves to /barcodes/barcode.png

Table table;

void setup(){
  String parentFolder = sketchFile("").getParent();
  String intervals_filename = "intervals_R.csv";
  String input_path = parentFolder + "/PipelineInteract2d/" + intervals_filename;
  table = loadTable(input_path, "header");
  
// Read in table and convert it to a float[][]
  int nrow = table.getRowCount();
  int ncol = table.getColumnCount();
  float[][] pts;  
  pts = new float[nrow][ncol];
  for (int r = 0; r < nrow; r = r + 1) {
    for (int c = 0; c < ncol; c = c + 1){
      pts[r][c] = table.getFloat(r,c);
    }
  }
  println(nrow + " intervals total.");

// Look through table and figure out where the dimension changes.  
  int[] spots = {0};
  for (int i=1; i<nrow; i = i + 1){
    if (pts[i][0] > pts[i-1][0] ){
      spots = (int[]) append(spots,i);
    }
  }
    
// Figure out what those dimensions actually are.  
  int[] dims = {int(pts[0][0])};
  for (int i=1; i<spots.length; i=i+1){
    dims = (int[]) append(dims, int(pts[spots[i]][0]));
  }
  spots = (int[]) append(spots,nrow);


// Set up box.
  size(600, 600);
  background(255);
  stroke(0,0,204);
  strokeWeight(1.5);
  rect(50,50,500,500);  
  stroke(0);
  strokeWeight(1);

// Figure out horizontal scale.
  float max = 0;
  float real_max;
  for (int i=0; i<nrow; i=i+1){
    if (pts[i][2] > max){
      max = pts[i][2];
    }
  }
  real_max = max;
  println("Max value is " + max + ".");
  println("Infinite lines go all the way to end.");
  max = max*(1.1);        // Rescale so max isn't cut off.
  
// Convert infinity to max length.
  for (int i=0; i<nrow; i=i+1){
    if(Float.isNaN(pts[i][2])){
      pts[i][2] = max;
    }
  }
  
  

// Start drawing lines.
  float spaces = nrow - dims.length + 2 + 2 +4*(dims.length-1);
  float incr = 500/spaces;
  float y=50;
  


textSize(10);
fill(0);
for (int j=0; j<dims.length; j=j+1){
  y = y + 2*incr;
  text("dim " + dims[j], 10, y);
  for (int k=spots[j]; k<spots[j+1]; k=k+1){    
    float start = pts[k][1];
    float finish = pts[k][2];
    line(50 + 500*(start/max), y, 50 + 500*(finish/max), y);
    y = y + incr;
    }
  if (j < (dims.length-1)){
    y = y + 1*incr;
    stroke(0,0,204);
    strokeWeight(1.5);
    line(50, y, 550, y);        // Draws a full line to separate dimensions
    stroke(0);
    strokeWeight(1);
  }
  }
text(int(max), 540, 565);  

String barcode_filename = "barcode.png";
String path = parentFolder + "/PipelineInteract2d/barcodes/" + barcode_filename;
//println(path);
println("Barcode saved to " + barcode_filename + ".");    
    
// Saves image to file.
 saveFrame(path);   
}     