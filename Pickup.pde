class Pickup
{
  float xPos, yPos;
  int type;
  boolean active;
  
  public Pickup( float x, float y, int t )
  {
    xPos = x;
    yPos = y;
    type = t;
    active = true;
    pickupType++;
  }
  
  void moveAndDraw()
  {
    drawByType();
    
    yPos += 5;
    if( yPos > height+15 )
      active = false;
  }
  
  void checkForPickedUp()
  {
    if( dist( xPos, yPos, player.xPos, player.yPos ) < 40 )
    {
      active = false;
      getBonusByType();
    }
  }
  
  void getBonusByType()
  {
    score += 30;
    switch(type)
    {
      case 1:
        player.gainHealth(15);
        break;
      case 3:
        player.gainShields();
        break;
      case 5: //<>//
        player.powerLevel++;
        player.orbits.add( new Orbiter() );
        for( int i = 0; i < player.orbits.size(); i++)
        {
          player.orbits.get(i).angle = TWO_PI/player.orbits.size()*i; //reset rotations
        }
        break;
      default:
        score += 70 + scoreBonus*10;
        scoreBonus++;
        break;
    }
  }
  
  void drawByType()
  {
    push();
    textAlign(CENTER);
    textSize(20);
    fill(255);
    noStroke();

    switch(type)
    {
      case 1:
        text("H",xPos,yPos+5);
        fill(0,250,0,175);
        break;
      case 3:
        text("S",xPos,yPos+5);
        fill(0,250,250,175);
        break;
      case 5:
        text("P",xPos,yPos+5);
        fill(250,0,0,175);
        break;
      default:
        text("$",xPos,yPos+5);
        fill(250,250,0,175);
        break;
    }
    circle(xPos,yPos,30);
    pop();
  }
}

/*
0 - score
1 - health
2 - shield
3 - powerup
*/
