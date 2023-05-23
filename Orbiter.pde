class Orbiter
{
  float angle;
  
  public Orbiter()
  {
    angle = 0;
  }
  
  void move()
  {
    angle += 0.05;
    angle %= TWO_PI;
  }
  
  void drawOrbiter()
  {
    image(orbiterPic,xPos(),yPos());
  }
  
  float xPos()
  {
    return player.xPos + sin(angle)*40; //30 is radius
  }
  
  float yPos()
  {
    return player.yPos + (cos(angle)*40)/4;  //not sure what 4.3 is for
  }
}
