class Player
{
  //Position Data
  float xPos, yPos;
  float xSpd, ySpd;
  float maxX, maxY;
  boolean up,down,left,right;
  
  //Image Data
  PImage pic;
  
  //Damage Data
  boolean hurt;
  int hurtTimer;
  int health;
  
  //Shot Data
  int shotTimer;
  boolean shooting;
  
  //Shield Data
  int shields;
  boolean shielded;
  int shieldTimer;
  
  //Powerup Data
  int powerLevel = 0;
  ArrayList<Orbiter> orbits = new ArrayList<Orbiter>();
  
  public Player()
  {
    xPos = width/2;
    yPos = height/2;
    maxX = 10;
    maxY = 10;
    up=down=left=right=false;
    pic = loadImage("RedTrollz.png");
    pic.resize(40,0);
    health = 100;
    hurt = false;
    hurtTimer = 0;
    shotTimer = 0;
    shooting = false;
    imageMode(CENTER);
    shields = 3;
    shieldTimer = 0;
    shielded = false;
  }
  
  void moveAndDraw()
  {
    //Momentum
    if(up)
      ySpd-=0.75;
    if(down)
      ySpd+=0.75;
    if(left)
      xSpd-=0.75;
    if(right)
      xSpd+=0.75;
     
    //Speed cap
    if( xSpd > maxX )  xSpd =  maxX;
    if( xSpd < -maxX ) xSpd = -maxX;
    if( ySpd > maxY )  ySpd =  maxY;
    if( ySpd < -maxY ) ySpd = -maxY;
    
    //Friction
    xSpd *= .90;
    ySpd *= .90;
    
    //Movement
    xPos += xSpd;
    yPos += ySpd;
    
    //Edge of screen
    if( xPos > width-20 ) { xPos = width-20;  xSpd=min(0,xSpd); }
    if( xPos < 20 )       { xPos = 20;        xSpd=max(0,xSpd); }
    if( yPos > height-20) { yPos = height-20; ySpd=min(0,ySpd); }
    if( yPos < 20 )       { yPos = 20;        ySpd=max(0,ySpd); }
    
    //Touched face
    if( dist( xPos, yPos, width/2, 0 ) < 200 )
    {
      getHurt();
      ySpd = 10;
    }    
    
    //Handle being hurt
    if(hurt)
    {
      if(millis()>hurtTimer)
        hurt = false;
      else if( millis() % 100 > 50 )
        tint(100);
    }
    
    
    //Orbiters (behind)
    for( Orbiter o: orbits )
      if( o.angle > HALF_PI && o.angle < PI*1.5 )
        o.drawOrbiter();
        
    //Draw player
    image(pic,xPos,yPos);
    noTint();
    
    //Orbiters (front)
    for( Orbiter o: orbits )
    {
      if( o.angle < HALF_PI || o.angle > PI*1.5 )
        o.drawOrbiter();
      o.move();
    }
    
    //Draw Shield
    if(shielded)
    {
      push();
      noStroke();
      fill(0,(player.xPos/250*width)/10,(player.yPos/250*height)/10,100);
      if( shieldTimer - millis() < 500 && millis()%100 < 50 ) //flicker
        fill(0,(player.xPos/250*width)/10,(player.yPos/250*height)/10,50);
      circle(player.xPos,player.yPos,90);
      pop();
    }
    
    //Check shield time
    if( millis() > shieldTimer )
      shielded = false;
    
    //Shoot laser(s)
    if(shooting && millis() > shotTimer)
    {
      lasers.add(new Laser());
      for(Orbiter o: orbits)
        lasers.add( new Laser(o.xPos(),o.yPos()) );
      player.shotTimer = max(100+millis(), millis()+700-(powerLevel*75));
    }
  }
  
  void activateShield()
  {
    if(shields > 0 && !shielded)
    {
      shields--;
      shielded = true;
      shieldTimer = millis()+3000;
    }
  }
  
  void getHurt()
  {
    if(!shielded)
    {
      //Take Damage
      if(!hurt)
        health -= 10;
       
      //Keep health at 0
      if( health <= 0 )
        health = 0;
        
      //Get one health back if you have an orbiter
      if( health == 0 && orbits.size() > 0 )
      {
        health = 1;
        powerLevel = max(0,powerLevel-1);
        orbits.remove(0);
      }
      
      //If still alive
      if( health > 0 )
      {
        hurt = true;
        hurtTimer = millis()+1000;
      }
      else
      {
        noLoop(); //temp end state
      }
    }
  }
  
  void gainHealth( int amount )
  {
    health += amount;
    if( health > 100 ) //overcharge
    {
      score += (health-100)*5; //convert to points
      health = 100;
    }
  }
  
  void gainShields()
  {
    shields+=5;
    if(shields > 5)
    {
      score += 20*(shields-5);
      shields = 5;
    }
  }
}

void keyPressed()
{
  if( key == '4' )
    player.left=true;
  if( key == '5' )
    player.down=true;
  if( key == '6' )
    player.right=true;
  if( key == '8' )
    player.up=true;
    
  if( key == ' ' )
    player.shooting = true;
  if( key == 's' )
    player.activateShield();
}

void keyReleased()
{
  if( key == '4' )
    player.left=false;
  if( key == '5' )
    player.down=false;
  if( key == '6' )
    player.right=false;
  if( key == '8' )
    player.up=false;
  if( key == ' ' )
    player.shooting = false;
}
