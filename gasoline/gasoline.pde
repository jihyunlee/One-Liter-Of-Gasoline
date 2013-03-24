
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
