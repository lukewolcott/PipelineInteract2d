// Built starting from Javaplex tutorial javaplexDemo.pde

import edu.stanford.math.plex4.api.*;
import edu.stanford.math.plex4.examples.*;
import edu.stanford.math.plex4.streams.impl.VietorisRipsStream;
import edu.stanford.math.plex4.homology.chain_basis.Simplex;
import edu.stanford.math.plex4.homology.filtration.FiltrationConverter;
import edu.stanford.math.plex4.homology.interfaces.AbstractPersistenceAlgorithm;
import edu.stanford.math.plex4.homology.barcodes.*;
import java.util.Map.Entry;
import java.util.List;


double[][] pts;

float offsetX,offsetY,sizeX,sizeY;
int dragX,dragY,oldmouseX,oldmouseY;

double eps = 0.01;
double f = eps;
double maxeps = 0.3;
int x_size = 700;          
int y_size = 700;

State state = State.ADDPOINTS;

VietorisRipsStream<double[]> vrs;
FiltrationConverter fc;
AbstractPersistenceAlgorithm<Simplex> algo;
BarcodeCollection<Double> ints=null;

//*****************************************
// Compute a new VietorisRipsStream
//*****************************************

void setupVRS() {
  vrs = Plex4.createVietorisRipsStream(pts,2,maxeps,1000);
  fc = vrs.getConverter();
  ints=null;
}

//*****************************************
// Reset the points buffer
//*****************************************

void resetPoints() {
      pts=new double[0][2];
      dragX=0;
      dragY=0;
      offsetX=0;
      offsetY=0;
      sizeX=5;
      sizeY=5;
      f = 10;
      eps = 10;
      maxeps = 300;
}

//*****************************************
// Global setup function
//*****************************************

void setup() {
//  size(400,400,P2D);
  size(700,700,P2D);                  // changed initial size to 700x700
  surface.setResizable(true);
  background(255);
  
  resetPoints();
  setupVRS();
  println("Press:");
  println("1-4 for example point clouds.");
  println("L/R arrows to draw VR complex.");
  println("h to compute intervals.");
  println("s to save them to file.");
  println("c to clear points.");
  println("i for these instructions.");
  println("q to quit.");
}

//*****************************************
// On mousepress: 
// * if we can move the board, remember
//   position for mouse-down so we can 
//   use it in mouseDragged() below.
// * if we can add points, add a point.
//*****************************************

void mousePressed() {
  if(state == State.MOVEBOARD) {
      oldmouseX = mouseX;
      oldmouseY = mouseY;
  } else if(state == State.ADDPOINTS) {
      double[] pt = new double[2];

      translate(dragX,dragY);
      translate(offsetX,offsetY);

      pt[0] = mouseX;
      pt[1] = mouseY;
      
      println(pt[0]+","+pt[1]);
      pts = (double[][]) append(pts,pt);
      setupVRS();
  }
}

//*****************************************
// On mousedrag:
// Update translation to reflect the offset 
// dragged.
//*****************************************

void mouseDragged() {
  if(state == State.MOVEBOARD) {
    dragX=mouseX-oldmouseX;
    dragY=mouseY-oldmouseY;
  }
}



//*****************************************
// On keypress:
// Implement state changes and other 
// effects as needed.
// 
// Key mapping implemented is case 
// insensitive:
// M     -- start moving the board
// Q     -- quit
// P     -- start adding points
// A     -- animate the construction of a 
//          Vietoris-Rips complex
// C     -- clear the board from its points
// V     -- recompute a Vietoris-Rips complex
// H     -- run a homology computation
// +     -- increase step size by a factor of 10
// -     -- decrease step size by a factor of 10
// §     -- output number of points 
// LEFT  -- step Vietoris-Rips complex back
// RIGHT -- step Vietoris-Rips complex forward
//*****************************************

Table table;

void keyPressed() {
  switch(key) {
    case '1':                              
      table = loadTable("seed1_data.csv", "header");
      pts = new double[table.getRowCount()][2];
      for (TableRow row : table.rows()){
        pts[row.getInt("point_id")][0] = row.getDouble("X_value")*x_size*0.9+x_size*0.05;
        pts[row.getInt("point_id")][1] = row.getDouble("Y_value")*y_size*0.9+y_size*0.05;
      }
      setupVRS();
      break;
     
    case '2':                              
      table = loadTable("seed2_cross.csv", "header");
      pts = new double[table.getRowCount()][2];
      for (TableRow row : table.rows()){
        pts[row.getInt("point_id")][0] = row.getDouble("X_value")*x_size*0.9+x_size*0.05;
        pts[row.getInt("point_id")][1] = row.getDouble("Y_value")*y_size*0.9+y_size*0.05;
      }
      setupVRS();
      break;
     
    case '3':                              
      table = loadTable("seed3_cross_hole_005.csv", "header");
      pts = new double[table.getRowCount()][2];
      for (TableRow row : table.rows()){
        pts[row.getInt("point_id")][0] = row.getDouble("X_value")*x_size*0.9+x_size*0.05;
        pts[row.getInt("point_id")][1] = row.getDouble("Y_value")*y_size*0.9+y_size*0.05;
      }
      setupVRS();
      break;
     
    case '4':                             
      table = loadTable("seed4_circle.csv", "header");
      pts = new double[table.getRowCount()][2];
      for (TableRow row : table.rows()){
        pts[row.getInt("point_id")][0] = row.getDouble("X_value")*x_size*0.9+x_size*0.05;
        pts[row.getInt("point_id")][1] = row.getDouble("Y_value")*y_size*0.9+y_size*0.05;
      }
      setupVRS();
      break;
     
//    case 'm':                    // don't need
//    case 'M':
//      state=State.MOVEBOARD;
//      break;
    case 'q':
    case 'Q':
      exit();
      break;
    case 'a':
    case 'A':
      state=State.ANIMATE;
      f=eps;
      break;   
    case 'c':
    case 'C':
      state=State.ADDPOINTS;
      resetPoints();
      setupVRS();
      break;
    case 'v':
    case 'V':
      setupVRS();
      ints = null;
      break;
    case 'h':
    case 'H':
      algo = Plex4.getDefaultSimplicialAlgorithm(2);
      ints = algo.computeIntervals(vrs);
      println(ints);
      break;
    case 's':              // code for saving intervals to file
    case 'S':
      String s = ints.toString();
      String[] sss = splitTokens(s, " [,)");      
      saveStrings("intervals_p3.txt", sss);
      println("Intervals saved to intervals_p3.txt.");
      println("After running clean_intervals.R,");
      println("run PipelineInteract2dBarcode.pde to plot barcode.");
      break;     
    case 'i':
    case 'I':              // prints instructions
        println("Press:");
        println("1-4 for example point clouds.");
        println("L/R arrows to draw VR complex.");
        println("h to compute intervals.");
        println("s to save them to file.");
        println("c to clear points.");
        println("i for these instructions.");
        println("q to quit.");
        break;
    case '+':
      eps *= 10;
      println(f+": "+eps);
      break;
    case '-':
      eps /= 10;
      println(f+": "+eps);
      break;
    case '§':
      println(pts.length);
      break;
    case CODED:
      switch(keyCode) {
        case RIGHT:
          f += eps;
          println(f+": "+eps);
          break;
        case LEFT:
          f -= eps;
          println(f+": "+eps);
          if(f<0)
            f=0;
          break;
    }
  }
}

//*****************************************
// Main drawing loop. 
// Draws black circles for each point, 
// black lines for each edge, and 
// alpha-channel translucent triangles for
// each 2-simplex 
// This is also where the Vietoris-Rips 
// parameter is stepped up in the animation
// mode.
//*****************************************

void draw() {
  background(255);
  stroke(0);
  fill(0);

  if(state == State.ANIMATE && f < maxeps) {
    f += eps;
    println(f);
  }

  translate(dragX,dragY);
  translate(offsetX,offsetY);

  for(Simplex s : vrs) {
    double fv = fc.getFiltrationValue(vrs.getFiltrationIndex(s));
    if(fv > f)
      continue;

    int[] ix;
    ix = s.getVertices();

    switch(s.getDimension()) {
      case 0:
        fill(0);
        ellipse((float)pts[ix[0]][0],(float)pts[ix[0]][1],sizeX,sizeY);
        break;
      case 1:
        fill(0);
        line((float)pts[ix[0]][0],(float)pts[ix[0]][1],
            (float)pts[ix[1]][0],(float)pts[ix[1]][1]);
        break;
      case 2:
        fill(0,0,255,20);
        triangle((float)pts[ix[0]][0],(float)pts[ix[0]][1],
            (float)pts[ix[1]][0],(float)pts[ix[1]][1],
            (float)pts[ix[2]][0],(float)pts[ix[2]][1]);
        break;
      default:
        continue;
    }
  }
}