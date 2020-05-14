int size = 900; //Canvas size (pixels)
int sideLength = 8; //Cells number per row/column (To make the game work, this value must be >= 2).
int cellNum = sideLength*sideLength; //Total cells number.
int cellDim = size/sideLength; //Single cell dimension.
int frame = 1000; //FPS.
int div = 10; //To slow down Agent while playing.

//cellNum - gamesThreshold (experimental values)
/*
        2 - 10
        3 - 25
        4 - 50
        5 - 100
        6 - 200
        7 - 300
        8 - 300
        9 - 400
       10 - 500
       11 - 600
       12 - 700
       13 - 800
       14 - 900
       15 - 1100
       16 - 1400
*/

GameData gameData = new GameData(300); //Game infos.
Lake lake = new Lake(); //Environment
Agent agent = new Agent(cellDim/2); //Agent

void settings()
{
  size(size, size);
}

void setup()
{
  frameRate(frame);
  background(0);
  noStroke();
}

void draw()
{
  lake.render(); //Draw Environment.
  agent.render(); //Draw Agent.
  
  if(gameData.trainingGames < gameData.gamesThreshold)
  {
    agent.train();
  }
  else
  {
    if(frameCount%(frame/10) == 0) //To slow down the agent.
    {
      agent.play();
    }
  }
}
