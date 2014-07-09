//Edge Detection

PImage img;
PImage edges;

float[][] cols = new float[9][3]; 



void setup() {
  
  img = loadImage("appple.jpg");
  edges = loadImage("appple.jpg");
  size(img.width,img.height);
  
  int ind = 0;
  
  //image(img,0,0);
  
  loadPixels();
  for(int x = 0; x < img.width; x++) {
    for (int y =0; y< img.height; y++) {
      int loc = x + y*img.width;
      if( x==0 || y== 0 || x >= img.width-1 || y >= img.height-1) {
        edges.pixels[loc] = color(0);
        continue;
      }
      ind = 0;
      for (int jum = x-1; jum <= x + 1; jum++) {
        for(int ble = y-1; ble <= y + 1; ble++) {
          cols[ind][0] = red(img.get(jum,ble));
          cols[ind][1] = green(img.get(jum,ble));
          cols[ind][2] = blue(img.get(jum,ble));
          ind++;
        }
      }
      float redDifU = UDSum(0);
      //println(redDifU);
      float greenDifU = UDSum(1);
      
      float blueDifU = UDSum(2);
      float redDifL = LRSum(0);
      float greenDifL = LRSum(1);
      float blueDifL = LRSum(2);
      //println(blueDifL);
      float supAns = sqrSum(redDifU, greenDifU, blueDifU, redDifL, greenDifL, blueDifL);
      supAns = supAns/(8*sqrt(6));
      edges.pixels[loc] = color(supAns);
      //print(cols[0][0]);
      //7print(cols[0][1]);
      //print(cols[0][2]);
    }
  }
  updatePixels();
  
}


float sqrSum (float rUp, float gUp, float bUp, float rLR, float gLR,float bLR) {
  return sqrt(rUp*rUp+gUp*gUp+bUp*bUp+rLR*rLR+gLR*gLR+bLR*bLR);
}
   
   
   


//0 = red, 1=green, 2=blue
float UDSum(int c){
  //float k;
  float tl = 1.0;
  float t = 2.0;
  float tr =1.0;
  float bl = -1.0;
  float b = -2.0;
  float br = -1.0;
  if(c==0){
    tl *= (cols[0][0]);
    t *= cols[1][0];
    tr *= cols[2][0];
    bl *= cols[6][0];
    b *= cols[7][0];
    br *= cols[8][0];
  }
  if(c==1){
    //k = green(get(x,y));
    
    tl *= cols[0][1];
    t *= cols[1][1];
    tr *= cols[2][1];
    bl *= cols[6][1];
    b *= cols[7][1];
    br *= cols[8][1];
  }
  if(c==2){
    //k = blue(get(x,y,));
    
    tl *= cols[0][2];
    t *= cols[1][2];
    tr *= cols[2][2];
    bl *= cols[6][2];
    b *= cols[7][2];
    br *= cols[8][2];
  }
 // println(tl+t+tr+bl+b+br);
  return tl+t+tr+bl+b+br; }

//0 = 0red, 1=green, 2=blue
float LRSum(int c){
  //float k;
  float tl = 1;
  float l = 2;
  float bl =1;
  float tr = -1;
  float r = -2;
  float br = -1;
  if(c==0){
    tl *= cols[0][0];
    l *= cols[3][0];
    bl *= cols[6][0];
    tr *= cols[2][0];
    r *= cols[5][0];
    br *= cols[8][0];
  }
  if(c==1){
    //k = green(get(x,y));
    
    tl *= cols[0][1];
    l *= cols[3][1];
    bl *= cols[6][1];
    tr *= cols[2][1];
    r *= cols[5][1];
    br *= cols[8][1];
  }
  if(c==2){
    //k = blue(get(x,y,));
    
    tl *= cols[0][2];
    l *= cols[3][2];
    bl *= cols[6][2];
    tr *= cols[2][2];
    r *= cols[5][2];
    br *= cols[8][2];
  }
  return tl+l+bl+tr+r+br; 
}

void draw(){
  background(150);
  image(edges,0,0);
}
      
        
        
