
// 1: bubble chart
// 2: fuel chart
// 3: bar chart

// if you are seeing bar chart, you can sort
// 'a': by city alphabetically
// 'c': by continents
// 'p': by price


int BUBBLE_CHART = 1;
int FUEL_GAUGE = 2;
int BAR_CHART = 3;


int screenMode = BUBBLE_CHART;
ArrayList<City> cityList = new ArrayList();
boolean bSelect;
int selectedCity;

PFont font;

void setup() {
  
  size(1280,720);
  smooth(); 
 
  loadCSV("costOfLiving.csv");
  createBubbles();
  
  Collections.sort(cityList, new ContinentalComparator());
  initialize();
  
  loadResources();
  
  font = createFont("LucidaGrande",21);
  
  textFont(font);
  textSize(16);
}

void draw() {
  if(screenMode == BUBBLE_CHART)     drawBubbleChart();
  else if(screenMode == FUEL_GAUGE)  drawFuelGauge();
  else if(screenMode == BAR_CHART)   drawBarChart();
}

void loadCSV(String path) {

  String[] rows=loadStrings(path);  
//  println("# of data: " + rows.length);
  
  for(String r : rows) {
    // skip empty rows
    if (r.length()>0) {
      String[] col = split(r,",");
      
      City c = new City();
      c.name = col[0];
      c.continent = col[1];
      c.pos = new PVector(Integer.valueOf(col[2]).intValue(),Integer.valueOf(col[3]).intValue());
      c.oil = col[4];
      c.gauge = calculateGauge(Float.valueOf(c.oil).floatValue());
      cityList.add(c);      
//      println(c.name + " | " + c.continent + " (" + c.pos.x + "," + c.pos.y + ") " + c.oil + " " + c.gauge);       
    }
  }  
}

ArrayList<Bubble> bubbles = new ArrayList();

class Bubble {
 
  PVector pos;
  PVector destPos;
  
  float r;
  
  float damping = 0.001;
  float spring = 0.99;//0.05;
  boolean isHovered = false;
  
  City c;

  Bubble(PVector pos_, City c_) {
    pos = pos_;
    destPos = new PVector(width/2+50,height/2+50);
    c = c_;
    r = map(sqrt(c.getOil()), 0, sqrt(1.5), 0, 80);   
  }
  
  void display() {
    
    // increment end coordinates toward centerpoint
    destPos.x = destPos.x + (width/2 - destPos.x) * damping;
    destPos.y = destPos.y + (height/2 - destPos.y) * damping;
   
    // increment x and y coordinates
    pos.x = pos.x + (destPos.x - pos.x) * damping;
    pos.y = pos.y + (destPos.y - pos.y) * damping;
    
    if (!isHovered) fill(255, 190);
    else            fill(getContinentColor(c.continent));

    noStroke();
    ellipse(pos.x, pos.y, r*2, r*2);
    if(isHovered) {
     fill(255);
     textSize(16);
    }
    else {
      fill(gray1);
      textSize(12);
    } 
    textAlign(CENTER,CENTER);
    text(c.name,pos.x,pos.y);
  }
  
  void hitTest(Bubble b) {
    
    float minDistance = b.r + r;
    
    // if a hit test is registered, propell balls in the opposite direction 
    if (dist(b.pos.x, b.pos.y, pos.x, pos.y) <= minDistance) {
            
      // first, get the difference between the two x, y coordinates
      float dx = b.pos.x - pos.x;
      float dy = b.pos.y - pos.y;
      
      /*
      next, calculate the angle in polar coordinates
      atan2 calculates the angle (in radians) from a specified point to the coordinate origin, 
      as measured from the positive x-axis. more info here: http://processing.org/reference/atan2_.html
      */
      float angle = atan2(dy, dx);
      
      // now, calculate the target coordinates of the current ball by using the minimum distance
      float targetX = pos.x + cos(angle) * minDistance;
      float targetY = pos.y + sin(angle) * minDistance;
      
      // increment the x and y coordinates for both objects
      pos.x = pos.x - (targetX - b.pos.x) * spring;
      pos.y = pos.y - (targetY - b.pos.y) * spring;
      b.pos.x = b.pos.x + (targetX - b.pos.x) * spring;
      b.pos.y = b.pos.y + (targetY - b.pos.y) * spring;
    } 
  }
  
  void propell() {
    
    // randomize angle relative to sketch center
    float angle = random(360);
    
    // increment endX and endY coordinates
    destPos.x = pos.x - cos(angle) * height/2;
    destPos.y = pos.y - sin(angle) * height/2;
  }
  
  boolean onMouseOver(float mx, float my) {
    if (dist(mx, my, pos.x, pos.y) < r) {
      isHovered = true;
    } 
    else {
      isHovered = false; 
    }
    return isHovered;
  }
  void onMousePressed(float mx, float my) {
    if (dist(mx, my, pos.x, pos.y) < r) {
      pos.x = mx;
      pos.y = my;
    }     
  }
  void onMouseDragged(float mx, float my) {
    if (dist(mx, my, pos.x, pos.y) < r) {
      pos.x = mx;
      pos.y = my;
    }     
  }
  
}

class City {
  String name;
  String continent;
  PVector pos = new PVector();
  String oil;
  int gauge;
  
  float getOil() {
    return Float.valueOf(this.oil).floatValue();  
  }
}

class PriceComparator implements Comparator<City> {
  public int compare(City c1, City c2) {
    if(c1.oil.equals(c2.oil)) {
      return c1.name.compareTo(c2.name);
    }
    return c1.oil.compareTo(c2.oil);
  }  
}

class CityComparator implements Comparator<City> {
  public int compare(City c1, City c2) {
    return c1.name.compareTo(c2.name);
  }  
}

class ContinentalComparator implements Comparator<City> {
  public int compare(City c1, City c2) {
    if(c1.continent.equals(c2.continent)) {
      return c1.oil.compareTo(c2.oil);
    }   
    return c1.continent.compareTo(c2.continent);
  }  
}


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


void drawBubbleChart() {
  background(gray4);
  noStroke();
  
  String title = "One liter of gasoline";
  String source = "Data from the Guardian datablog: Cost of living survey 2012";
  String keyDescription ="'  ': propell bubbles  '2': fuel Gauge  '3': bar chart";
  
  textAlign(LEFT, CENTER);
  int txtX = 45;
  int txtY = 50;

  textSize(38);
  fill(gray1);  
  text(title, txtX, txtY);
  
  textSize(16);
  fill(80);
  text(source, txtX+10, txtY+40);
  
  textAlign(LEFT, TOP);
  textSize(12);
  text(keyDescription, txtX, height-25);
  
  // draw bubbles
  for (Bubble b1:bubbles) {
    b1.display();
    
    // run a hit test on all other bubbles
    for (Bubble b2:bubbles) {
      if (bubbles.indexOf(b2) != bubbles.indexOf(b1)) {
        b1.hitTest(b2);
      } 
    }
  }
  
  // check for mouse over
  float r=0;
  for (Bubble b:bubbles) {
    if(b.onMouseOver(mouseX, mouseY)) {
      r = b.r;
      bSelect = true;
      selectedCity = bubbles.indexOf(b);
      break;  
    }
    bSelect = false;
  }
  if(bSelect) {
    strokeWeight(3);
    stroke(getContinentColor(bubbles.get(selectedCity).c.continent));
    noFill();
    for (Bubble b:bubbles) {
      ellipse(b.pos.x,b.pos.y,r*2,r*2);
    }
  }

    
}

void createBubbles() {
  for(City c:cityList) {
    Bubble b = new Bubble(new PVector(random(width),random(height)), c);
    bubbles.add(b);  
  }  
}
int animationIndex = 0;

PImage imgMap;
PImage imgGauge0;
PImage imgGauge1;
PImage imgGauge2;
PImage imgGauge3;
PImage imgGauge4;
PImage imgGauge5;
PImage imgGauge6;
PImage imgGauge7;
PImage imgGauge8;
PImage imgGauge9;
PImage imgGauge10;

// BMW Mini Cooper S gas tank: 13.2 gallons = 50 liters
void drawFuelGauge() {
  noStroke();
  image(imgMap, 0, 0);

  String title = "How much gasoline will €20.00 buy?";
  String source = "Data from the Guardian datablog: Cost of living survey 2012";
  String keyDescription ="'1': bubble chart  '3': bar chart";
  
  textAlign(RIGHT);
  int txtX = width-50;
  int txtY = 20;

  textSize(32);
  fill(0);
  text(title, txtX+4, txtY+40+3);
  fill(255);  
  text(title, txtX, txtY+40);
  
  textSize(14);
  fill(0);
  text(source, txtX+2, txtY+65+2);
  fill(228);
  text(source, txtX, txtY+65);

  textAlign(LEFT, TOP);
  textSize(12);
  text(keyDescription, 45, height-25);
  
  for(City c:cityList) {  
    fill(255);
    ellipse(c.pos.x, c.pos.y, 7, 7);
  }

  textSize(16);
  
  // selected city
  if(bSelect) {
    City c = cityList.get(selectedCity);
    fill(255,87,103);
    ellipse(c.pos.x,c.pos.y,10,10);
    
    int w = 100;
    fill(0,0,0,200);
    textSize(16);
    float cityNameLen = textWidth(c.name);
    String unitPrice = "(€ "+c.oil+"/ℓ)";
    textSize(12);
    float unitPriceLen = textWidth(unitPrice);
    rectMode(CORNER);
    rect(c.pos.x-w/2-15, c.pos.y-w/2-15, w+max(cityNameLen,unitPriceLen)+40, w+30,10);
    
    fill(255);
    textAlign(LEFT,CENTER);
    textSize(16);
    text(c.name,c.pos.x+w/2+10,c.pos.y-20);
    
    text(calculateVolume(c.oil)+"ℓ",c.pos.x+w/2+10,c.pos.y+5);
    textSize(12);
    text(unitPrice,c.pos.x+w/2+10,c.pos.y+25);
    
    if(animationIndex < c.gauge) {
      image(drawGauge(animationIndex),c.pos.x-w/2, c.pos.y-w/2, w,w);
      if(frameCount% map(c.gauge, 0, 10, 12, 2) == 0)
        animationIndex++;
    }
    else 
      image(drawGauge(c.gauge),c.pos.x-w/2, c.pos.y-w/2, w,w);
  }
}

String calculateVolume(String unitPrice) {
  float price = Float.valueOf(unitPrice).floatValue();
  float currency = 20;
  return nf(currency / price, 2, 2);  
}

int calculateGauge(float unitPrice) {
  // gas tank = 50 liter, 13.2 gallon
  // 20 euro 
  float currency = 20;
  float value = currency / unitPrice;
  return (int)value /(50/10); 
}

PImage drawGauge(int gauge) { 
  PImage img = null;
  switch(gauge) {
    case 0: img = imgGauge0; break;
    case 1: img = imgGauge1; break;
    case 2: img = imgGauge2; break;
    case 3: img = imgGauge3; break;
    case 4: img = imgGauge4; break;
    case 5: img = imgGauge5; break;
    case 6: img = imgGauge6; break;
    case 7: img = imgGauge7; break;
    case 8: img = imgGauge8; break;
    case 9: img = imgGauge9; break;
    case 10: img = imgGauge10; break;
  }
  return img;
}

void loadResources() {
  
  imgContinents = loadImage("worldmap_cont.jpeg");
  if(imgContinents == null) {
    println("[ERROR] worldmap_cont.jpeg not loaded");
    return;
  }
  
  imgMap = loadImage("worldmap.jpg"); 
  if(imgMap == null) {
    println("[ERROR] worldmap.jpg not loaded");
    return;
  }
  
  imgGauge0 = loadImage("gas0.png");
  if(imgGauge0 == null) {
    println("[ERROR] gas0.png not loaded");
    return;
  }  
  imgGauge1 = loadImage("gas1.png");
  if(imgGauge1 == null) {
    println("[ERROR] gas1.png not loaded");
    return;
  }  
  imgGauge2 = loadImage("gas2.png");
  if(imgGauge2 == null) {
    println("[ERROR] gas2.png not loaded");
    return;
  }  
  imgGauge3 = loadImage("gas3.png");
  if(imgGauge3 == null) {
    println("[ERROR] gas3.png not loaded");
    return;
  }  
  imgGauge4 = loadImage("gas4.png");
  if(imgGauge4 == null) {
    println("[ERROR] gas4.png not loaded");
    return;
  }  
  imgGauge5 = loadImage("gas5.png");
  if(imgGauge5 == null) {
    println("[ERROR] gas5.png not loaded");
    return;
  }  
  imgGauge6 = loadImage("gas6.png");
  if(imgGauge6 == null) {
    println("[ERROR] gas6.png not loaded");
    return;
  }  
  imgGauge7 = loadImage("gas7.png");
  if(imgGauge7 == null) {
    println("[ERROR] gas7.png not loaded");
    return;
  }  
  imgGauge8 = loadImage("gas8.png");
  if(imgGauge8 == null) {
    println("[ERROR] gas8.png not loaded");
    return;
  }  
  imgGauge9 = loadImage("gas9.png");
  if(imgGauge9 == null) {
    println("[ERROR] gas9.png not loaded");
    return;
  }
  imgGauge10 = loadImage("gas10.png");
  if(imgGauge10 == null) {
    println("[ERROR] gas10.png not loaded");
    return;
  }
}


void keyPressed() {
  switch(key) {
    case ' ': {
      if(screenMode == BUBBLE_CHART) {
        for(Bubble b:bubbles) {
          b.propell();
        }
      }
    } break;
    case '3': { // bar chart
      screenMode = BAR_CHART;
      initialize();
    } break;
    case '2': { // fuel gauge
      screenMode = FUEL_GAUGE; 
      initialize();
    } break;
    case '1': { // bubble chart
      screenMode = BUBBLE_CHART; 
      initialize();
    } break;
    case 'a': { // sort by city alphabetically
      if(screenMode == BAR_CHART) {
        sortBy = 3;
        Collections.sort(cityList, new CityComparator());
      }
    } break;
    case 'c': { // sort by continent
      if(screenMode == BAR_CHART) {
        sortBy = 1;
        Collections.sort(cityList, new ContinentalComparator());
      }
    } break;
    case 'p': { // sort by price
      if(screenMode == BAR_CHART) {
        sortBy = 2;
        Collections.sort(cityList, new PriceComparator());
      }
    } break;
    case 's': {
      if(screenMode == BAR_CHART) saveFrame("costOfLiving_viz1.png"); 
      else if(screenMode == FUEL_GAUGE) saveFrame("costOfLiving_viz2.png");
      else if(screenMode == BUBBLE_CHART) saveFrame("costOfLiving_viz3.png");
    } break;
  }
}

void mouseMoved() {

  if(screenMode == BAR_CHART) {
    int index = (mouseX - left) / gap;
    if(index >= cityList.size() || index < 0) return;
    
    if( (left+index*gap <= mouseX) && (mouseX <= left+index*gap+30)) {
      City c = cityList.get(index);
      float barHeight = Float.valueOf(c.oil).floatValue() * 100 * 2;
      if( (bottom-barHeight <= mouseY) && (mouseY <= bottom)) {
//        println(c.name);
        bSelect = true;
        selectedCity = index;
        return;
      }
    }
 
    bSelect = false;
    selectedCity = -1;         
  }
  else if(screenMode == FUEL_GAUGE) {  
    for(City c:cityList) {
      if((mouseX >= c.pos.x-10 && mouseX <= c.pos.x+10) && (mouseY >= c.pos.y-10 && mouseY <= c.pos.y+10)) {
        if(bSelect == true && selectedCity == cityList.indexOf(c)) {
          return;
        }
        bSelect = true;      
        selectedCity = cityList.indexOf(c);
        animationIndex = 0;
        return;
      }
    }
    
    bSelect = false;
    selectedCity = -1;    
  }  
}

void mousePressed() {
  if(screenMode != BUBBLE_CHART) return;
  
  for (Bubble b:bubbles) {
    b.onMousePressed(mouseX, mouseY);
  }  
}

void mouseDragged() {
  if(screenMode != BUBBLE_CHART) return;
  
  for (Bubble b:bubbles) {
    b.onMouseDragged(mouseX, mouseY);
  }  
}

void initialize() {
  bSelect = false;
  selectedCity = -1;  
}

