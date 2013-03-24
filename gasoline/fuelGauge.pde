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
