package builder.beans;

public class LoadedBean {

  private String name;

  public LoadedBean( String name ) {
    this.name = name;
  }

  public String toString() {
    return getName();
  }

  // getters
  public String getFullName() { return name; }
  public String getName() { return name.substring( name.lastIndexOf('.') + 1 ); }

}