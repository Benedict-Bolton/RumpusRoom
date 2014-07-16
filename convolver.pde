float[][] EDGE_KERNEL = { {-1, -1, -1}, 
                          {-1,  8, -1},
                          {-1, -1, -1} };
                          
float[][] BLUR_KERNEL = { {1.0/9, 1.0/9, 1.0/9}, 
                          {1.0/9, 1.0/9, 1.0/9},
                          {1.0/9, 1.0/9, 1.0/9} };
  
float[][] H_SOBEL = { {-1, 0, 1}, 
                      {-2, 0, 2},
                      {-1, 0, 1} };

float[][] V_SOBEL = { { 1,  2,  1}, 
                      { 0,  0,  0},
                      {-1, -2, -1} };

float[][] GAUSSIAN_KERNEL = { {1,  4,  7,  4, 1},
                       {4, 16, 26, 16, 4},
                       {7, 26, 41, 26, 7},
                       {4, 16, 26, 16, 4},
                       {1,  4,  7,  4, 1}, };
  
float[][] sum_normalize(float[][] m) {
  float factor = 0;
  float[][] out = new float[m.length][m[0].length];
  
  for(int x = 0; x < m.length; x++)
    for(int y = 0; y < m[0].length; y++)
      factor += m[x][y];
  
  for(int x = 0; x < m.length; x++)
    for(int y = 0; y < m[0].length; y++)
      out[x][y] = m[x][y] / factor;
  return out;
}

void setup() {
  GAUSSIAN_KERNEL = sum_normalize(GAUSSIAN_KERNEL);
   //String url = "http://www.jeffgreenhouse.com/wp-content/uploads/media-pipes-544.jpg";
   String url = "http://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Valve_original_%281%29.PNG/300px-Valve_original_%281%29.PNG";
  // Load image from a web server
  PImage webImg = loadImage(url, "PNG");
  size(3*webImg.width,2*webImg.height);
  image(webImg, 0, 0);
  PImage blurred = conv(BLUR_KERNEL, webImg);
//  blurred = conv(BLUR_KERNEL, blurred);
//  blurred = conv(BLUR_KERNEL, blurred);
  PImage gauss_blurred = conv(GAUSSIAN_KERNEL, webImg);
  
  /*
  PImage edged = conv(EDGE_KERNEL, webImg);
  PImage blur_edged = conv(EDGE_KERNEL, blurred);
  PImage gauss_blur_edged = conv(EDGE_KERNEL, gauss_blurred);
  */
  
  PImage edged = conv(H_SOBEL, V_SOBEL, webImg);
  PImage blur_edged = conv(H_SOBEL, V_SOBEL, blurred);
  PImage gauss_blur_edged = conv(H_SOBEL, V_SOBEL, gauss_blurred);
  
  edged.filter(GRAY);
  //edged.filter(THRESHOLD, .3);
  blur_edged.filter(GRAY);
  //blur_edged.filter(THRESHOLD, .3);
  gauss_blur_edged.filter(GRAY);
  //gauss_blur_edged.filter(THRESHOLD, .3);
  
  image(blurred, webImg.width, 0);
  image(gauss_blurred, webImg.width*2, 0);
  image(edged, 0, webImg.height);
  image(blur_edged, webImg.width, webImg.height);
  image(gauss_blur_edged, webImg.width*2, webImg.height);
  
}

int value(color c) {
  return (int) ((red(c)+blue(c)+green(c)) / 3);
}

//Convolves two matrices on the same img and combines results.
PImage conv(float[][] h_matrix, float[][] v_matrix, PImage img) {
  color[][] in = PImageToMatrix(img);
  color[][] h_out = conv(h_matrix, in);
  color[][] out = conv(v_matrix, in);
  for(int x = 0; x < in.length; x++)
    for(int y = 0; y < in[0].length; y++) {
      color hc = h_out[x][y];  color vc = out[x][y];
       out[x][y] = color(sqrt(sq(red(hc)) + sq(red(vc))),
                         sqrt(sq(green(hc)) + sq(green(vc))),
                         sqrt(sq(blue(hc)) + sq(blue(vc))) );
    }
  return matrixToPImage(out); 
}

PImage matrixToPImage(color[][] matrix) {
  int w = matrix.length; int h = matrix[0].length; 
  PImage out = new PImage(w, h);
  out.loadPixels();
  for(int x = 0; x < w; x++)
    for(int y = 0; y < h; y++) {
     out.pixels[x + y*w] = matrix[x][y];     
    }
  out.updatePixels();
  return out;
}

color[][] PImageToMatrix(PImage img) {
  color[][] out = new color[img.width][img.height];
  img.loadPixels();
  for(int x = 0; x < img.width; x++)
    for(int y = 0; y < img.height; y++) {
      out[x][y] = img.pixels[x + y*img.width];     
    }
  return out;
}

PImage conv(float[][] matrix, PImage img) {
  return matrixToPImage( conv(matrix, PImageToMatrix(img)) );
} 

color[][] conv(float[][] matrix, color[][] img) {
  color[][] out = new color[img.length][img[0].length];
  int xoff = matrix.length/2; int yoff = matrix[0].length/2;
  for(int x = xoff; x < img.length - xoff; x++)
    for(int y = yoff; y < img[0].length - yoff; y++) {
      out[x][y] = pointconv(x, y, matrix, img);
    }
  //border
  for(int y = 0; y < img[0].length; y++) {
    for(int x = 0; x < xoff; x++)
      out[x][y] = img[x][y];
    for(int x = img.length - xoff; x < img.length; x++)
      out[x][y] = img[x][y];
  }
  for(int x = 0; x < img.length; x++) {
    for(int y = 0; y < yoff; y++)
      out[x][y] = img[x][y];
    for(int y = img[0].length - yoff; y < img[0].length; y++)
      out[x][y] = img[x][y];
  }
  //border
  return out;
}

//Applies 'matrix' to the designated part of the color[][] array.
color pointconv(int x, int y, float[][] matrix, color[][] img) {
  int xoff = matrix.length/2; int yoff = matrix[0].length/2;
  float r = 0.0; float g = 0.0; float b = 0.0;
  for(int i = 0; i < matrix.length; i++)
    for(int j = 0; j < matrix[0].length; j++) {
        color c = img[x+i-xoff][y+j-yoff];
        //bitshifting is faster than red/green/blue
    /*  r+= matrix[i][j] * red(c);
        g+= matrix[i][j] * green(c);
        b+= matrix[i][j] * blue(c);  */
        r+= matrix[i][j] * ((c >> 16) & 0xFF);
        g+= matrix[i][j] * ((c >> 8) & 0xFF);
        b+= matrix[i][j] * (c & 0xFF);
    }
  return color(r,g,b);
}

color[][] colorMatPlus(color[][] A, color[][] B) {
  if (A.length != B.length || A[0].length != B[0].length)
    return null;
  color[][] C = new color[A.length][A[0].length];
  for(int x = 0; x < C.length; x++)
    for(int y = 0; y < C[0].length; y++) {
      color cA = A[x][y]; color cB = B[x][y];
      int rA = (cA >> 16) & 0xFF; int rB = (cB >> 16) & 0xFF;
      int gA = (cA >> 8) & 0xFF;  int gB = (cB >> 8) & 0xFF;   
      int bA = cA & 0xFF;         int bB = cB & 0xFF;
      C[x][y] = color(rA+rB, gA+gB, bA+bB);
    }
  return C;
  
}
