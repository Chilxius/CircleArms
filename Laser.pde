class Laser
{
  float xPos, yPos;
  float speed;
  float size;
  
  public Laser()
  {
    xPos = player.xPos;
    yPos = player.yPos;
    speed = 7;
    size = 50;
  }
  
  public Laser( float x, float y ) //for orbiters
  {
    xPos = x;
    yPos = y;
    speed = 7;
    size = 30;
  }
  
  void moveAndDraw()
  {
    yPos-=speed;
    
    noStroke();
    fill(200,150,0);
    ellipse(xPos,yPos,size/5,size);
  }
  
  void checkForHits()
  {
    if( leftArm.active && !leftArm.hurt && dist( xPos, yPos, leftArm.handX, leftArm.handY ) < 90 )
    {
      leftArm.hurt();
      yPos = -500;
      nextPickupCount++;
    }
    if( rightArm.active && !rightArm.hurt && dist( xPos, yPos, rightArm.handX, rightArm.handY ) < 90 )
    {
      rightArm.hurt();
      yPos = -500;
      nextPickupCount++;
    }
  }
}
