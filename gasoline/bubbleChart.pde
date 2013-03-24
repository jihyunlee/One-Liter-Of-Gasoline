
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
