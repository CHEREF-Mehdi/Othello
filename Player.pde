class Player{
private int pawn;
private int score;
private boolean cantPlay;
private ArrayList <Move> MovePossible;

public Player(int p){
  pawn=p;
  score=2;
  MovePossible=new ArrayList <Move>();
  cantPlay=false;
}

public int GetPawn(){
  return pawn;
}

public void SetPawn(){
  pawn=-pawn;
}

public int GetScore(){
  return score;
}

public boolean GetCantPlay(){
  return cantPlay;
}

public ArrayList <Move> GetMovep(){
  return MovePossible;
}

//calculate score of the player
public void SetScore(int [][] state){
  score=0;
  for(int i=0;i<8;i++){
    for(int j=0;j<8;j++){
        if(state[i][j]==pawn) score++;        
    }
  }  
  
}

public void resetMovePossible(){
  MovePossible=new ArrayList <Move>();
}

//find all the possibele moves in a specified stategame and range
public void MovePossible(Position p,int[][] state,int[][] Rngs){
  int i,k,recolte, adv=-pawn;
  Position pp;
  Move movepossible;
  //moitié diagonal gauche haut
  recolte=0;
  for(i=p.GetX()-1 ,k=p.GetY()-1; i>=0 && k>=0; i--,k--){
    
      if(state[i][k]==adv) recolte++;
      else{
          if(recolte>0 && state[i][k]==0){
              pp=new Position(i,k);
              movepossible=new Move(pp,score(pp,true,state),Rngs);
              if(!contains(movepossible)) MovePossible.add(movepossible);
              break;
          }else{              
              break;
          }
      }
  }
  
  //moitié vertical haut  
  recolte=0; i=p.GetX();
  for(k=p.GetY()-1; k>=0;k--){
    
      if(state[i][k]==adv) recolte++;
      else{
          if(recolte>0 && state[i][k]==0){
            pp=new Position(i,k);
            movepossible=new Move(pp,score(pp,true,state),Rngs);
            if(!contains(movepossible)) MovePossible.add(movepossible); 
            break;
          }else{              
              break;
          }
      }
  }
  
  //moitié diagonal droite haut
  recolte=0; 
  for(i=p.GetX()+1 ,k=p.GetY()-1; i<8 && k>=0; i++,k--){
    
      if(state[i][k]==adv) recolte++;
      else{
          if(recolte>0 && state[i][k]==0){
              pp=new Position(i,k);
              movepossible=new Move(pp,score(pp,true,state),Rngs);
              if(!contains(movepossible)) MovePossible.add(movepossible);
              break;
          }else{              
              break;
          }
      }
  }
  
  //moitié horisontal droit 
  recolte=0; k=p.GetY();
  for(i=p.GetX()+1; i<8;i++){
    
      if(state[i][k]==adv) recolte++;
      else{
          if(recolte>0 && state[i][k]==0){
            pp=new Position(i,k);
              movepossible=new Move(pp,score(pp,true,state),Rngs);
            if(!contains(movepossible)) MovePossible.add(movepossible);  
            break;
          }else{              
              break;
          }
      }
  }
  
  //moitié diagonal gauche bat
  recolte=0; 
  for(i=p.GetX()+1 ,k=p.GetY()+1; i<8 && k<8; i++,k++){
    
      if(state[i][k]==adv) recolte++;
      else{
          if(recolte>0 && state[i][k]==0){
              pp=new Position(i,k);
              movepossible=new Move(pp,score(pp,true,state),Rngs);
            if(!contains(movepossible)) MovePossible.add(movepossible);
              break;
          }else{              
              break;
          }
      }
  }
  
  //moitié vertical bat
  recolte=0;  i=p.GetX();
  for(k=p.GetY()+1; k<8 ;k++){
    
      if(state[i][k]==adv) recolte++;
      else{
          if(recolte>0 && state[i][k]==0){
            pp=new Position(i,k);
              movepossible=new Move(pp,score(pp,true,state),Rngs);
            if(!contains(movepossible)) MovePossible.add(movepossible);  
            break;
          }else{              
              break;
          }
      }
  }
  
  //moitié diagonal droit bat
  recolte=0; 
  for(i=p.GetX()-1 ,k=p.GetY()+1; i>=0 && k<8; i--,k++){
    
      if(state[i][k]==adv) recolte++;
      else{
          if(recolte>0 && state[i][k]==0){
              pp=new Position(i,k);
              movepossible=new Move(pp,score(pp,true,state),Rngs);
              if(!contains(movepossible)) MovePossible.add(movepossible);
              break;
          }else{              
              break;
          }
      }
  }
  
  //moitié horisontal droit  
  recolte=0; k=p.GetY();
  for(i=p.GetX()-1; i>=0;i--){
    
      if(state[i][k]==adv) recolte++;
      else{
          if(recolte>0 && state[i][k]==0){
            pp=new Position(i,k);
            movepossible=new Move(pp,score(pp,true,state),Rngs);
            if(!contains(movepossible)) MovePossible.add(movepossible);
            break;
          }else{              
              break;
          }
      }
  }
  
}//end MovePossible()

public void showPositionPlayable(){
  int x,y;
  stroke(255);
  strokeWeight(2.5);
  fill(color(27,178,253));
  textAlign(CENTER);
  
  for(int i=0;i<MovePossible.size();i++){
    x=(MovePossible.get(i).GetPos().GetX()+1)*70;
    y=(MovePossible.get(i).GetPos().GetY()+1)*70;
    
      if(mouseX>=y-35 && mouseX<=y+35 && mouseY>=x-35 && mouseY<=x+35){
        
        line(y-20,x-30,y+20,x-30);
        line(y-20,x+30,y+20,x+30);
        
        line(y-30,x-15,y-30,x+15);
        line(y+30,x-15,y+30,x+15);
        
        font=createFont("Old English Text MT",30);
        textFont(font);
        text("+"+MovePossible.get(i).GetRec(), y, x);
        
      }else{
        line(y-25,x-30,y-35,x-30);
        line(y+25,x-30,y+35,x-30);
        
        line(y-25,x+30,y-35,x+30);
        line(y+25,x+30,y+35,x+30);
        
        line(y-30,x-25,y-30,x-35);
        line(y-30,x+25,y-30,x+35);
        
        line(y+30,x-25,y+30,x-35);
        line(y+30,x+25,y+30,x+35);
                 
        font=createFont("Old English Text MT",22);
        textFont(font);
        text("+"+MovePossible.get(i).GetRec(), y, x);
         
      }
  }
 
  if(MovePossible.size()==0) cantPlay=true;
  else cantPlay=false;
  
}// end showPositionPlayable()


//retourn the move's score 
//if onlyScore==false then we excute the move 
public int score(Position p,boolean ScoreOnly,int[][] state){
    int ScoreT=0,i,k,recolte,adv=-pawn;
    boolean connected;
    
  recolte=0; connected=false;
  for(i=p.GetX()-1 ,k=p.GetY()-1; i>=0 && k>=0; i--,k--){
    
      if(state[i][k]==adv) recolte++;
      else{
          if(recolte>0 && state[i][k]==pawn){              
              connected=true;              
              break;
          }else{              
              break;
          }
      }
  }
  
  if(connected){
    ScoreT=ScoreT+recolte;
    if(!ScoreOnly){ 
      
      for(i=p.GetX()-1 ,k=p.GetY()-1; i>=0 && k>=0; i--,k--){        
          if(state[i][k]==adv) state[i][k]=pawn;
          else{
              break;
          }
      }//boucle for
      
    }
  }// if connected
  
   //moitié vertical haut  
  recolte=0; i=p.GetX(); connected=false;
  for(k=p.GetY()-1; k>=0;k--){
    
      if(state[i][k]==adv) recolte++;
      else{
          if(recolte>0 && state[i][k]==pawn){
            connected=true;
            break;
          }else{              
              break;
          }
      }
  }//boucle for
  
  if(connected){
    ScoreT=ScoreT+recolte;
    if(!ScoreOnly){   
      
      i=p.GetX();
      for(k=p.GetY()-1; k>=0;k--){        
          if(state[i][k]==adv) state[i][k]=pawn;
          else{
              break;
          }
      }//boucle for
      
    }
  }// if connected
  
  //moitié diagonal droite haut
  recolte=0; connected=false;
  for(i=p.GetX()+1 ,k=p.GetY()-1; i<8 && k>=0; i++,k--){
    
      if(state[i][k]==adv) recolte++;
      else{
          if(recolte>0 && state[i][k]==pawn){  
              connected=true;
              break;
          }else{              
              break;
          }
      }
  }//boucle for
  
  if(connected){
    ScoreT=ScoreT+recolte;
    if(!ScoreOnly){   
      
      for(i=p.GetX()+1 ,k=p.GetY()-1; i<8 && k>=0; i++,k--){
        
          if(state[i][k]==adv) state[i][k]=pawn;
          else{
              break;
          }
      }//boucle for
      
    }
  }// if connected
  
  //moitié horisontal droit 
  recolte=0; k=p.GetY(); connected=false;
  for(i=p.GetX()+1; i<8;i++){
    
      if(state[i][k]==adv) recolte++;
      else{
          if(recolte>0 && state[i][k]==pawn){
            connected=true;
            break;
          }else{              
              break;
          }
      }
  }//boucle for
  
  if(connected){
    ScoreT=ScoreT+recolte;
    if(!ScoreOnly){ 
      
      k=p.GetY();
      for(i=p.GetX()+1; i<8;i++){        
          if(state[i][k]==adv) state[i][k]=pawn;
          else{
              break;
          }
      }//boucle for
      
    }
  }// if connected
  
  //moitié diagonal gauche bat
  recolte=0; connected=false;
  for(i=p.GetX()+1 ,k=p.GetY()+1; i<8 && k<8; i++,k++){
    
      if(state[i][k]==adv) recolte++;
      else{
          if(recolte>0 && state[i][k]==pawn){
              connected=true;
              break;
          }else{              
              break;
          }
      }
  }//boucle for
  
  if(connected){
    ScoreT=ScoreT+recolte;
    if(!ScoreOnly){     
      for(i=p.GetX()+1 ,k=p.GetY()+1; i<8 && k<8; i++,k++){
    
          if(state[i][k]==adv) state[i][k]=pawn;
          else{
              break;
          }
      }//boucle for
      
    }
  }// if connected
  
  //moitié vertical bat
  recolte=0;  i=p.GetX(); connected=false;
  for(k=p.GetY()+1; k<8 ;k++){
    
      if(state[i][k]==adv) recolte++;
      else{
          if(recolte>0 && state[i][k]==pawn){
            connected=true;
            break;
          }else{              
              break;
          }
      }
  }//boucle for
  
  if(connected){
    ScoreT=ScoreT+recolte;
    if(!ScoreOnly){   
      
      i=p.GetX();
      for(k=p.GetY()+1; k<8 ;k++){
        
          if(state[i][k]==adv) state[i][k]=pawn;
          else{
             break;
          }
      }//boucle for
      
    }
  }// if connected
  
  
  //moitié diagonal droit bat
  recolte=0; connected=false;
  for(i=p.GetX()-1 ,k=p.GetY()+1; i>=0 && k<8; i--,k++){
    
      if(state[i][k]==adv) recolte++;
      else{
          if(recolte>0 && state[i][k]==pawn){
              connected=true;
              break;
          }else{              
              break;
          }
      }
  }//boucle for
  
  if(connected){
    ScoreT=ScoreT+recolte;
    if(!ScoreOnly){     
      
        for(i=p.GetX()-1 ,k=p.GetY()+1; i>=0 && k<8; i--,k++){      
            if(state[i][k]==adv) state[i][k]=pawn;
            else{
                break;
            }
        }//boucle for
      
    }
  }// if connected
  
  //moitié horisontal droit
  recolte=0; k=p.GetY(); connected=false;
  for(i=p.GetX()-1; i>=0;i--){
    
      if(state[i][k]==adv) recolte++;
      else{
          if(recolte>0 && state[i][k]==pawn){
            connected=true;
            break;
          }else{              
              break;
          }
      }
  }//boucle for
  
  if(connected){
    ScoreT=ScoreT+recolte;
    if(!ScoreOnly){     
      
        k=p.GetY();
        for(i=p.GetX()-1; i>=0;i--){
          
            if(state[i][k]==adv) state[i][k]=pawn;
            else{
                break;
            }
        }//boucle for
      
    }
  }// if connected
   
    return ScoreT+1;
    
}//end score()

//chech if a move is already added to list off possible moves
public boolean contains(Move newm){
    for(int i=0;i<MovePossible.size();i++){
      if(MovePossible.get(i).equals(newm)) return true;
    }
    return false;
}

}//end class player