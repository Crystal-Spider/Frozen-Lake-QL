class Agent
{
  int x; //Agent icon x coordinate.
  int y; //Agent icon y coordinate.
  int dim; //Agent icon dimension.
  
  boolean done; //True if the current game reached a terminal state, false otherwise.
  
  double learningRate = 0.8;
  double discountFactor = 0.99;
  double explorationRate = 1;
  double explorationDecay = (double)1/gameData.gamesThreshold;
  
  double[][] Q = new double[cellNum][4];
  
  public Agent(int dim)
  {
    this.reset();
    this.dim = dim;
  }
  
  public void train()
  {
    if(!done) //If game is not completed.
    {
      int state = getState(); //Get Agent state (number of the cell the Agent is on).
      int action = getAction(state); //Choose the action to take.
      gameData.gameMoves++; //Increase the moves done for this game.
      double reward = move(action); //Take the action and get the reward.
      //Update Q table.
      Q[state][action] = Q[state][action] + learningRate*(reward + discountFactor*(getMaxReward(getState()) - Q[state][action]));
    }
    else
    {
      //Decrease the exploration rate at every game completed.
      if(explorationRate >= explorationDecay)
      {
        explorationRate -= explorationDecay;
      }
      
      gameData.increaseGames(); //Increase games played.
      gameData.printData(); //Print game data.
      gameData.gameMoves = 0; //Set moves for the next game to 0.
      reset(); //Set the Agent back to the start position.
    }
  }
  
  public void play()
  {
    if(!done)
    {
      int state = getState(); //Get Agent state (number of the cell the Agent is on).
      int action = getAction(state); ///Choose the action to take.
      gameData.gameMoves++; //Increase the moves done for this game.
      move(action); //Take the action.
    }
    else
    {
      gameData.increaseGames(); //Increase games played.
      gameData.printData(); //Print game data.
      gameData.gameMoves = 0; //Set moves for the next game to 0.
      reset(); //Set the Agent back to the start position.
    }
  }
  
  //Choose an action to take depending on the state passed as parameter and whether the Agent is training or playing.
  public int getAction(int state)
  {
    if(gameData.trainingGames < gameData.gamesThreshold)
    {
      if(random(0, 1) < explorationRate)
      {
        return (int)random(0, 4); //Random action.
      }
      else
      {
        return this.getBestAction(state); //Best action.
      }
    }
    else
    {
      return this.getBestAction(state); //Best action.
    }
  }
  
  //Get the action with the highest reward value associated for the state passed as parameter.
  private int getBestAction(int state)
  {
    int action = 0;
    double max = Q[state][0];
    
    for(int c = 1; c < 4; c++)
    {
      if(Q[state][c] > max)
      {
        max = Q[state][c];
        action = c;
      }
      else if(Q[state][c] == max && random(0, 1) > 0.5) //If there's more than 1 action with the same highest value, randomly take one of those.
      {
        max = Q[state][c];
        action = c;
      }
    }
    
    return action;
  }
  
  //Move the Agent depending on the action passed as parameter and after update the Environment that the Agent moved.
  public double move(int action)
  {
    switch(action)
    {
      case 0: //Left.
        x -= cellDim;
        break;
      case 1: //Up.
        y -= cellDim;
        break;
      case 2: //Right.
        x += cellDim;
        break;
      case 3: //Down.
        y += cellDim;
        break;
    }
    return lake.moved(); //Update the Environment that the Agent moved.
  }
  
  //Get the highest reward value for the actions associated with the state passed as parameter.
  private double getMaxReward(int state)
  {
    double max = 0;
    
    if(state >= 0 && state < cellNum) //If the state is inside the game map (valid indices for the Q table).
    {
      max = Q[state][0];
      
      for(int c = 1; c < 4; c++)
      {
        if(Q[state][c] > max)
        {
          max = Q[state][c];
        }
      }
    }
    
    return max;
  }
  
  //Get the number of the cell the Agent is on [0 - cellNum].
  private int getState()
  {
    return ((x-cellDim/2)+(y-cellDim/2)*sideLength)/cellDim;
  }
  
  //Draw Agent icon.
  public void render()
  {
    fill(150, 150, 150);
    ellipse(x, y, dim, dim);
  }
  
  //Set the Agent back to the starting state.
  public void reset()
  {
    x = cellDim/2;
    y = cellDim/2;
    done = false;
  }
}
