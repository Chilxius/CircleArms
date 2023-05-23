class Bullet
{
  float xPos, yPos, xSpd, ySpd, size;

  
  public Bullet( float x, float y, float xS, float yS ) //give bullet set trajectory
  {
    xPos = x;
    yPos = y;
    xSpd = xS;
    ySpd = yS;
    size = 20;
  }
  
  boolean moveAndDraw()
  {
    xPos+=xSpd;
    yPos+=ySpd;
    
    fill(200,0,0);
    ellipse(xPos,yPos,size,size);
    
    if( dist(xPos,yPos,width/2,height/2)>1000)
      return true;
    return false;
  }
  

}
