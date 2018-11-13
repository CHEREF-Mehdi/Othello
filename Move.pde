class Move{ 
private int recolte; //gain (score)
private Position pos; //position in the state game
private int range; // range of the position on a Matrice Range

public Move(Position p,int r,int[][] Rngs){
  recolte=r;
  pos=p;
  range=Rngs[p.GetX()][p.GetY()];
}

public int GetRange(){
  return range;
}

public Position GetPos(){
  return pos;
}

public int GetRec(){
  return recolte;
}

@Override
public String toString(){
  int x=pos.GetX()+1,
      y=pos.GetY()+1;   
  return "X="+pos.GetX()+", Y="+pos.GetY()+", Score ="+recolte+", range ="+range+" case : "+lettres[y]+(x);
}

@Override
public boolean equals(Object o){
  Move x;
  if(o==null) return false;
  if(o instanceof Move){ 
    x=(Move) o;
    return pos.equals(x.pos);
  }
  return false;
}

}//end class