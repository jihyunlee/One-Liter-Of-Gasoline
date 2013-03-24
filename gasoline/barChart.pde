
int sortBy = 1;
PImage imgContinents;
String[] prices = {
  "[Euro]", "€ 1.50", "€ 1.00", "€ 0.50"
};
String[] continents = {
  "Africa", "Americas", "Asia", "Australia", "Europe"
};
color[] col = {
  #d95f02, // Africa
  #66a61e, // Americas
  #e6ab02, // Asia
  #c04080, //7d5dc6, //7570b3, // Australia
  #0073cf  // Europe
};
int gray1 = 48;
int gray2 = 100;
int gray3 = 156;
int gray4 = 200;
int gray5 = 230;

int left = 160;
int right = 1280-60;
int top = 190; //200; // continent
int bottom = top+400;
int gap = 53;

int Y_AXIS = 1;
int X_AXIS = 2;

void drawBarChart() {
  background(255);

  fill(gray1);
  textAlign(LEFT, CENTER);
  textSize(38);
  text("One liter of gasoline", 45, 50);
  textSize(16);
  fill(gray3);
  noStroke();
  text("Data from the Guardian datablog: Cost of living survey 2012", 55, 90);

  if (sortBy == 1) {
    image(imgContinents, right-299, 50, 299, 200);
    strokeWeight(1);
    stroke(gray4);
    noFill();
    rect(right-299-20, 50-10, 299+20, 220);
  }

  int priceY = top;  
  strokeWeight(1);
  stroke(gray5);
  fill(gray2);
  textSize(16);
  textAlign(RIGHT, CENTER);
  for (int i=0; i<prices.length; i++,priceY+=100) {
    text(prices[i], left-35, priceY);
    if (i!=0) line(left-25, priceY, right, priceY);
  }

  int x = left;  
  int y = priceY+10;  

  for (City c:cityList) {   
    pushMatrix();
    translate(x+10, y); // Translate to the center
    rotate(-PI/4.0);   // Rotate by theta
    fill(gray2);
    textAlign(RIGHT) ;
    text(c.name, 10, 18);
    popMatrix();

    noStroke();
    float barHeight = Float.valueOf(c.oil).floatValue() * 100 * 2;
    if (sortBy == 1) {
      fill(getContinentColor(c.continent));
      rect(x, priceY-barHeight, 27, barHeight);
    }
    else {
      float g = map(barHeight, 300, 0, 50, 228);
      color b1 = color(255,g,103);
      color b2 = color(255,228,103);
      setGradient(x, (int)(priceY-barHeight), (float)27, barHeight, b1, b2, Y_AXIS);
    }

    if (selectedCity == cityList.indexOf(c)) {
      fill(gray2);
      textAlign(CENTER);
      text("€ " + c.oil, x-15, priceY-barHeight-25, 60, 20);
    }

    x+=gap;
  }  

  strokeWeight(2);
  stroke(gray1);
  line(left-25, priceY, right, priceY);
  line(left-25, top, left-25, priceY);

  fill(gray3);
  String keyDescription ="'a': sort by city alphabetically  'c': sort by continentals  'p': sort by price  '1': bubble chart  '2': fuel Gauge";  
  textAlign(LEFT, TOP);
  textSize(12);
  text(keyDescription, 45, height-25);
}

color getContinentColor(String continent) {
  if (sortBy != 1) {
    return color(255);
  }

  if (continent.equals(continents[0])) return col[0];
  else if (continent.equals(continents[1])) return col[1];
  else if (continent.equals(continents[2])) return col[2];
  else if (continent.equals(continents[3])) return col[3];
  else if (continent.equals(continents[4])) return col[4];
  
  return color(255);
}

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  // calculate differences between color components 

  float deltaR = red(c2)-red(c1);
  float deltaG = green(c2)-green(c1);
  float deltaB = blue(c2)-blue(c1);

  // choose axis
  if (axis == Y_AXIS) {
    /*nested for loops set pixels in a basic table structure */

    for (int i=x; i<=(x+w); i++) { // column      
      for (int j = y; j<=(y+h); j++) { // row
        color c = color(  (red(c1)+(j-y)*(deltaR/h)), 
        (green(c1)+(j-y)*(deltaG/h)), 
        (blue(c1)+(j-y)*(deltaB/h)) );
        set(i, j, c);
      }
    }
  }  
  else if (axis == X_AXIS) {
    for (int i=y; i<=(y+h); i++) { // column
      for (int j = x; j<=(x+w); j++) { // row
        color c = color(  (red(c1)+(j-x)*(deltaR/w)), 
        (green(c1)+(j-x)*(deltaG/w)), 
        (blue(c1)+(j-x)*(deltaB/w)) );
        set(j, i, c);
      }
    }
  }
}

