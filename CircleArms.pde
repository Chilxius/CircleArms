//Shoot-them-up Game

//Main classes
Player player;
Arm leftArm, rightArm;
Face face;

//Arraylists
ArrayList<Laser> lasers = new ArrayList<Laser>();
ArrayList<Bullet> shots = new ArrayList<Bullet>();
ArrayList<Pickup> goods = new ArrayList<Pickup>();

//Score Data
int score = 0;
int scoreBonus = 0;

//Pickup Data
int nextPickupCount = 0;
int pickupType = 0;

//Image for crystals
PImage orbiterPic;

void setup()
{
  size(900,800);
  
  player = new Player();
  leftArm= new Arm(100, true);
  rightArm = new Arm(100, false);
  face = new Face();
  
  orbiterPic = loadImage("save1.png");
  orbiterPic.resize(0,30);
  
  imageMode(CENTER);
}

void draw()
{
  background(0);
  drawHUD();
  face.moveAndDraw();
  handlePickups();
  player.moveAndDraw();
  handleBullets();
  handleLasers();
  leftArm.moveAndDraw();
  rightArm.moveAndDraw();
}

//Draw and move pickups, checks for new ones
void handlePickups()
{
  for( int i = 0; i < goods.size(); i++)
  {
    goods.get(i).moveAndDraw();
    goods.get(i).checkForPickedUp();
    if( !goods.get(i).active )
    {
      goods.remove(i);
      i--;
    }
  }
  
  if( nextPickupCount >= 7 ) //Drops a powerup every 7 hits
  {
    nextPickupCount=0;
    goods.add( new Pickup( random(50,width-50), 0, pickupType%6 ) );
  }
}

//Move, draw, check for hits, remove old ones
void handleLasers()
{
  for( int i = 0; i < lasers.size(); i++ )
  {
    lasers.get(i).moveAndDraw();
    lasers.get(i).checkForHits();
    if( lasers.get(i).yPos < -100 )
    {
      lasers.remove(i);
      i--;
    }
  }
}

//Move, draw, check for hits, remove old ones
void handleBullets()
{
  for( int i = 0; i < shots.size(); i++ ) //look at each bullet...
  {
    shots.get(i).moveAndDraw();  //draw and move it
    if( !player.hurt && dist( shots.get(i).xPos, shots.get(i).yPos, player.xPos, player.yPos ) < shots.get(i).size )
    {
      player.getHurt();
    }
    if( dist( shots.get(i).xPos, shots.get(i).yPos, width/2,height/2 ) > 1000 ) //has it gone far enough away?
    {
      shots.remove(i);  //remove it from the list
      i--;  //INCLUDE THIS FOR WEIRD REASONS
    }
  }
}

//Add a bullet spread (arc, downward)
void addSpread( float x, float y, int num ) //num will be off by 1
{
  int shotToRemove = shots.size();
  
  float number = num;
  float speed = 5;
  number+=2;
  float increment = (speed*2)/number;
  //Arc Pattern
  for(float i = -speed+increment; i < speed-increment; i+=increment)
    shots.add( new Bullet(x,y,i,sqrt((speed*speed) - (i*i))));
  
  shots.remove(shotToRemove); // <- remove strange extra shot
}

void drawHUD()
{
  push();
  
  //Draw health display
  textSize(25);
  fill(255);
  textAlign(LEFT);
  text("HEALTH",18,height-50);
  fill(250-player.health*2.5,player.health*2.5,0);
  rectMode(CORNER);
  noStroke();
  rect(20,760,player.health*2,20);
  noFill();
  stroke(255);
  strokeWeight(2);
  rect(20,760,200,20);
  
  //Draw shields display
  textAlign(RIGHT);
  fill(255);
  text("SHIELDS",width-18,height-50);
  noStroke();
  fill(0,(player.yPos/250*height)/10,(player.xPos/250*width)/10,100);
  for(int i = 0; i < player.shields; i++)
    circle( width - 35*(i+1), height-25, 30 );
  
  //Draw score display
  textAlign(CENTER);
  fill(255);
  text("SCORE",width/2,height-50);
  fill(255,200,0);
  text(score,width/2,height-25);
  
  pop();
}
