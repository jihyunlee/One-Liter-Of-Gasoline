
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

