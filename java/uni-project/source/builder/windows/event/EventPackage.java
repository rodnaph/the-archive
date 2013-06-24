package builder.windows.event;

import java.beans.*;
import java.lang.reflect.*;

import builder.beans.*;

public class EventPackage {

  private BuilderBean source;
  private EventSetDescriptor descriptor;
  private Method method;
  private Class listener;

  public EventPackage( BuilderBean source, EventSetDescriptor descriptor, Method method, Class listener ) {

    this.source = source;
    this.descriptor = descriptor;
    this.method = method;
    this.listener = listener;

  }

  public BuilderBean getSource() {
    return source;
  }

  public EventSetDescriptor getDescriptor() {
    return descriptor;
  }

  public Method getMethod() {
    return method;
  }

  public String getType() {
    return listener.getName();
  }

  public Class getListener() {
    return listener;
  }

}