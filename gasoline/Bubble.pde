
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
