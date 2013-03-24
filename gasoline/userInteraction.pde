

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
