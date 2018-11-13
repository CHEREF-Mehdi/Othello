
class Tree{
  private int[][] stateIA=new int[8][8];
  private int[][] RangesIA=new int[8][8];
  private Move move;
  private Player J;  
  private ArrayList <Tree> sons;
  private int heuristic;
  private int node;
  
  public Tree(int j,int[][] STATE,Move m,int hrtc,int[][] RNGS){    
    int scoreCPM=0,scoreH=0;
    Position p1,p2,p3,p4;
    
    //critical positions
    if(stateIA[0][0]==0) p1=new Position(0,0);
    else p1=null;
    
    if(stateIA[0][7]==0) p2=new Position(0,7);
    else p2=null;
    
    if(stateIA[7][0]==0) p3=new Position(7,0);
    else p3=null;
    
    if(stateIA[7][7]==0) p4=new Position(7,7);
    else p4=null;
    
    J=new Player(j);
    
    for(int i=0;i<8;i++){
      for(int k=0;k<8;k++){
        stateIA[i][k]=STATE[i][k];
      }
    }        
    
    for(int i=0;i<8;i++){
      for(int k=0;k<8;k++){
        RangesIA[i][k]=RNGS[i][k];
      }
    } 
    
    if(m==null) {//root tree
          //println("--------la tete--------");
          //showMatrice(stateIA);          
          heuristic=hrtc;

    }   
    else{//son's root
          move=m;
          stateIA[m.GetPos().GetX()][m.GetPos().GetY()]=j; 
          J.score(m.GetPos(),false,stateIA);  
          
          //changer les poids de l'IA    
          SetRnages();
          J.SetScore(stateIA); 
          
          if(J.GetPawn()==cmp.GetPawn()) scoreCPM=J.GetScore();
          else{
            scoreH=J.GetScore();
          }
          
          //next player
          J.SetPawn();
          J.SetScore(stateIA); 
          
          if(J.GetPawn()==cmp.GetPawn()) scoreCPM=J.GetScore();
          else{
            scoreH=J.GetScore();
          }
          
          //println("new son "+m.toString()); 
          //showMatrice(stateIA);
          
          //heuristic add range & harvest of the move
          if(J.GetPawn()==human.GetPawn()) heuristic=hrtc+m.GetRange()+3*m.GetRec();
          else heuristic=hrtc-2*m.GetRange()-6*m.GetRec();
    }
    
        
    // possible moves next player    
    for(int i=0;i<8;i++){
      for(int k=0;k<8;k++){
        if(stateIA[i][k]==J.GetPawn()){          
          J.MovePossible(new Position(i,k),stateIA,RangesIA);
        }                    
      }
    }//boucle for 
        
    //println("next move's player ="+J.GetPawn());
    
    //heuristique criticle positions
    for(int i=0;i<J.GetMovep().size();i++){ 
      //println(J.GetMovep().get(i).toString());
      
      if(  J.GetMovep().get(i).GetPos().equals(p1) ||
           J.GetMovep().get(i).GetPos().equals(p2) ||
           J.GetMovep().get(i).GetPos().equals(p3) ||
           J.GetMovep().get(i).GetPos().equals(p4) ){
           
          if(J.GetPawn()==human.GetPawn()){
           heuristic-=100;
          }  
      }           
           
    }//end for         
    
   
    if(J.GetMovep().size()==0) { 
        sons=null;
        //heuristic
        if(!StateGameSatured(stateIA)){
            if(J.GetPawn()==human.GetPawn()) {
              heuristic+=50; 
            }
            else {
              heuristic-=50;
            }  
        }
    }else {
      sons=new ArrayList <Tree>();           
    }  
    //end of game                  
    if(StateGameSatured(stateIA)){
        heuristic+=(scoreCPM-scoreH)*100;      
    }
    
  }// end constructor
  
  //create tree of possibilities
  public void CreateTree(int depth,int indx){                 
      Tree son;
      
      if(!StateGameSatured(stateIA)){                
        
          if(depth%2==0 ){  //humain turn
              if(indx<J.GetMovep().size()){ 
                
                //println("-\nhuman : profondeur= "+profondeur);
                //println(J.GetMovep().get(indx).toString()); 
                            
                son=new Tree(human.GetPawn(),stateIA,J.GetMovep().get(indx),heuristic,RangesIA);            
                sons.add(son);                                   
                CreateTree(depth,indx+1);
              }else{            
                
                if(depth-1>=0 && sons!=null){for(int i=0;i<sons.size();i++) sons.get(i).CreateTree(depth-1,0);}
                else sons=null;
                
              }
          }else{ // cmp turn
              if(indx<J.GetMovep().size()){
                
                //println("\ncmp : profondeur= "+profondeur);
                //println(J.GetMovep().get(indx).toString());
                            
                son=new Tree(cmp.GetPawn(),stateIA,J.GetMovep().get(indx),heuristic,RangesIA);            
                sons.add(son);                                              
                CreateTree(depth,indx+1);            
              }else{
                           
                if(depth-1>=0  && sons!=null){for(int i=0;i<sons.size();i++) sons.get(i).CreateTree(depth-1,0);}
                else sons=null;
                
              }
          }  
      }     
    
  }// end construire arbre
  
  //alphabeta algo
  public int ALPHABETA(int maxORmin,int alpha,int beta){
      if(sons==null) { node=heuristic; return heuristic;}
      else{
          if(maxORmin==-1){//Min node
            node=infinity; //node=+(l'infini) pire cas
            for(int i=0;i<sons.size();i++){
               node = min(node, sons.get(i).ALPHABETA(-maxORmin, alpha, beta));               
               if (alpha >= node) return node;  /* elagage */                    
               beta = min(beta, node);
            }//for
          
          }else{//Max node
              node = -infinity; //node=-(l'infini) pire cas
           for(int i=0;i<sons.size();i++){
               node=max(node,sons.get(i).ALPHABETA(-maxORmin, alpha, beta));
               if(node>= beta) return node;  /* elagage */
               alpha = max(alpha, node);
           }//for  
           
          }
          return node;
      }//else (sons!=null)
  
  }//end ALPHABETA
  
   public int negaMax(int MinOrMax,int alpha,int beta){
     if(sons==null) { node=heuristic; return heuristic;}    
     
      int bestValue =-infinity;
      
       for(int i=0;i<sons.size();i++){
           node = -sons.get(i).negaMax(-MinOrMax, -beta, -alpha);
           if(node>bestValue) {
             bestValue=node;
             if(bestValue>alpha){
               alpha=bestValue;
               if (alpha >= beta) break;
             }           
           }           
                           
        }//end for
        
       return bestValue;
       
    }//end negaMax
  
 
  //return the move the cmp have to play
  public Move NextMove(){
      if(sons==null) return null;
      
      for(int i=0;i<sons.size();i++){        
        if(sons.get(i).node==node) {return sons.get(i).move;}        
      }      
      
      return null;
  }
  
  //drow precised matrix 
  public void showMatrice(int[][] STATE){
    for(int i=0;i<8;i++){
      for(int j=0;j<8;j++){
        if(j==0) if(STATE[i][j]>=0) print(" "+STATE[i][j]);
                 else print(STATE[i][j]);
        else{
            if(STATE[i][j]>=0) print("   "+STATE[i][j]);
            else print("  "+STATE[i][j]);
        }
        
      }
      println();
    }  
  }
  
  //update ranges
  public boolean SetRnages(){
    boolean set=false;
    if(stateIA[0][0]==cmp.GetPawn()){
      
        if(RangesIA[0][1]<0){          
          RangesIA[0][1]=-3/2*RangesIA[0][1];
          RangesIA[1][0]=-3/2*RangesIA[1][0];
          RangesIA[1][1]=-3/2*RangesIA[1][1];
          set=true;
        }
        if(RangesIA[0][6]<0){
          int i;
          for(i=1;i<=7 && stateIA[0][i]==human.GetPawn();i++){}          
          if(i==6) {RangesIA[0][6]=75; set=true;}         
        }
        if(RangesIA[0][7]==150) {RangesIA[0][7]=2*150;set=true;}
        
        if(RangesIA[6][0]<0){
          int i;
          for(i=1;i<=7 && stateIA[i][0]==human.GetPawn();i++){}             
          if(i==6) {RangesIA[6][0]=75;set=true;}          
        }
        if(RangesIA[7][0]==150) {RangesIA[7][0]=150*2;set=true;}
    }
    
    if(stateIA[0][7]==cmp.GetPawn()){
        if(RangesIA[0][6]<0){          
          RangesIA[0][6]=-3/2*RangesIA[0][6];
          RangesIA[1][6]=-3/2*RangesIA[1][6];
          RangesIA[1][7]=-3/2*RangesIA[1][7];
          set=true;
        }
        
        if(RangesIA[0][1]<0){
          int i;
          for(i=6;i>=0 && stateIA[0][i]==human.GetPawn();i--){}           
          if(i==1) {RangesIA[0][1]=75; set=true;}         
        }        
        if(RangesIA[0][0]==150) {RangesIA[0][0]=150*2; set=true;}
        
        if(RangesIA[6][7]<0){
          int i;
          for(i=1;i<=7 && stateIA[i][7]==human.GetPawn();i++){}           
          if(i==6) {RangesIA[6][7]=75; set=true;}         
        }  
        if(RangesIA[7][7]==150) {RangesIA[7][7]=150*2;set=true;}
    }
    
    if(stateIA[7][0]==cmp.GetPawn()){
      if(RangesIA[6][0]<0){       
        RangesIA[6][0]=-3/2*RangesIA[6][0];
        RangesIA[6][1]=-3/2*RangesIA[6][1];
        RangesIA[7][1]=-3/2*RangesIA[7][1];
        set=true;
      }
      
      if(RangesIA[1][0]<0){
          int i;
          for(i=6;i>=0 && stateIA[i][0]==human.GetPawn();i--){}                     
          if(i==1) {RangesIA[1][0]=75;set=true; }   
      }
      if(RangesIA[0][0]==150) {RangesIA[0][0]=150*2;set=true;}
      
      if(RangesIA[7][6]<0){
          int i;
          for(i=1;i<=7 && stateIA[7][i]==human.GetPawn();i++){}                      
          if(i==6) {RangesIA[7][6]=75;  set=true;}        
      }  
      if(RangesIA[7][7]==150) {RangesIA[7][7]=150*2;set=true;}
        
    }
    
    if(stateIA[7][7]==cmp.GetPawn()){                  
        if(RangesIA[7][6]<0){          
          RangesIA[7][6]=-3/2*RangesIA[7][6];
          RangesIA[6][6]=-3/2*RangesIA[6][6];
          RangesIA[6][7]=-3/2*RangesIA[6][7];
          set=true;
        }
        if(RangesIA[7][1]<0){
          int i;
          for(i=6;i>=0 && stateIA[7][i]==human.GetPawn();i--){}                      
          if(i==1) {RangesIA[7][1]=75; set=true;}          
        } 
        if(RangesIA[7][0]==150) RangesIA[7][0]=150*2;
        
        if(RangesIA[1][7]<0){
          int i;
          for(i=6;i>=0 && stateIA[i][7]==human.GetPawn();i--){}                      
          if(i==1) {RangesIA[1][7]=75;set=true;}
        } 
        if(RangesIA[0][7]==150) {RangesIA[0][7]=150*2; set=true;}       
    }
    
    return set;
  }//end set Ranges
  
 
  
}//class Arbre
