package builder.windows.event;

import java.awt.*;

import builder.beans.*;

public class EventLink implements java.io.Serializable {

  private BuilderBean to, from;

  public EventLink( BuilderBean from, BuilderBean to ) {
    this.from = from;
    this.to = to;
  }

  public Point getFrom() {
    return from.getPosition();
  }

  public Point getTo() {
    return to.getPosition();
  }

}