class Face
{
  boolean open;
  PImage eyeOpen, eyeShut;
  
  boolean hurt;
  int hurtTimer;
  
  int volleyTimer;
  int round;
  
  int volleyRestTimer;
  int volleyCount;
  
  int health;
  
  public Face()
  {
    open = false;
    
    eyeOpen = loadImage("face.png");
      eyeOpen.resize(0,400);
    eyeShut = loadImage("face2.png");
      eyeShut.resize(0,400);
    
    hurt = false;
    hurtTimer = 0;
    
    volleyTimer = 0;
    round = 2;
    
    health = 10;
  }
  
  void moveAndDraw()
  {
    //Flash red
    if(hurt && millis()%200 < 100)
      tint(250,0,0);
    
    if(open)
      image(eyeOpen,width/2,200);
    else
      image(eyeShut,width/2,200);
      
    noTint();
     
    //Check for activation
    if( !open && !leftArm.active && !rightArm.active )
    {
      open = true;
      volleyTimer = millis() + 1000;
      health = 1+round*2;
      volleyCount = 3+round;
      volleyRestTimer = 0;
    }
      
    if( open )
    {
      if( millis() > volleyTimer && millis() > volleyRestTimer )
      {
        volleyTimer = millis() + 2000/round;
        addSpread( 450, 70, 3+round*2 );
        
        volleyCount--;
        if(volleyCount <= 0)
        {
          volleyRestTimer = millis()+2000;
          volleyCount = 3+round;
        }
      }
      
      //Check for taking damage
      for( Laser l: lasers )
        if( !hurt && dist( l.xPos, l.yPos, 450, 70 ) < 40 )
          getHurt();
          
      if( millis() > hurtTimer )
        hurt = false;
    }
  }
  
  void getHurt()
  {
    nextPickupCount++;
    
    health--;
    hurt = true;
    hurtTimer = millis()+1500;
    shots.add( new Bullet(450,70,random(-1,1), 6 ) );
    shots.get(shots.size()-1).size = 40;
    
    if( health <= 0 )
    {
      open = false;
      hurt = false;
      round++;
      leftArm.active = true;
      leftArm.health = 5+round;
      rightArm.active = true;
      rightArm.health = 5+round;
    }
  }
}
