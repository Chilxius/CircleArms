class Arm
{
  //Position Data
  int distDown;
  float armThickness = 5;
  boolean left;
  float handX, handY;
  float destX, destY;
  
  //Image Data
  PImage arm, hand;
  
  //Shot Data
  int shotCountdown;
  
  //Hurt Status Data
  boolean hurt;
  int hurtTimer;
  int health;
  
  //Active Data
  boolean active;
  
  public Arm( int dist, boolean isLeft )
  {
    distDown = dist;
    left = isLeft;
    
    arm = loadImage("arm.png");
    arm.resize(70,0);
    hand = loadImage("hand.png");
    hand.resize(90,0);
    
    //Set starting x pos
    if(left)
      handX = 0;
    else
      handX = width;
    //Set starting y pos
    handY = distDown;
    
    //Set initial x destination
    if(left)
      destX = random(width/2);
    else
      destX = random(width/2,width);
    //Set initial y destination
    destY = random(distDown,distDown+300);
    
    //Set shot countdowns
    if(isLeft)
      shotCountdown = 4000;
    else
      shotCountdown = 6000;
     
    //Do not start hurt
    hurt = false;
    hurtTimer = 0;
    
    //Start alive and active
    health = 5;
    active = true;
  }
  
  void moveAndDraw()
  {
    for(int i = 0; i < armThickness+1; i++) //arm from left side
    {
      push();
      if(hurt)
        tint(250,0,0);
      
      //Check if touching player
      if(!player.hurt)
      {
        if(left) checkTouch(handX/armThickness*i, distDown+(handY/armThickness*i)-distDown/armThickness*i);
        else     checkTouch(width-(width-handX)/armThickness*i,distDown+(handY/armThickness*i)-distDown/armThickness*i);
      }
      
      if(left)
        translate(handX/armThickness*i,distDown+(handY/armThickness*i)-distDown/armThickness*i);
      else
        translate(width-(width-handX)/armThickness*i,distDown+(handY/armThickness*i)-distDown/armThickness*i);

      if( i == armThickness )
      {
        rotate( atan2( player.yPos-handY, player.xPos-handX ) - HALF_PI );
        image(hand,0,10);
      }
      else
        image(arm,0,0);
      
      pop();
      
      if(int(handX) == int(destX))
      {
        if(active)
        {
          if(left) destX = random(width/2);
          else     destX = random(width/2,width);
        }
        else
        {
          if(left) destX = 50;
          else     destX = width-50;
        }
      }
      if( handX < destX)
      {
        if(!hurt && active )
          handX+=0.1;
        else
          handX+=0.5;
      }
      else
      {
        if(!hurt && active)
          handX-=0.1;
        else
          handX-=0.5;
      }
        
      if(int(handY) == int(destY))
      {
        if(active)
          destY = random(distDown,distDown+300);
        else
          destY = distDown;
      }
      if( handY < destY)
      {
        if(!hurt && active)
          handY+=0.1;
        else
          handY+=0.5;
      }
      else
      {
        if(!hurt && active)
          handY-=0.1;
        else
          handY-=0.5;
      }
        
    }
    
    if( millis() > shotCountdown )
    {
      shotCountdown += 4000;
      addSpread( handX, handY, 10 );
    }
    
    if( hurt && millis() > hurtTimer )
    {
      hurt = false;
    }
  }
  
  void checkTouch( float x, float y )
  {
    if( dist( x, y, player.xPos, player.yPos ) < 50 )
    {
      player.ySpd = 10;
      player.getHurt();
    }
  }
  
  void hurt()
  {
    hurt = true;
    hurtTimer = millis() + 1000;
    health--;
    if( health <= 0 )
      active = false;
  }
}
