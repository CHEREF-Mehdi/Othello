class Position  {
private int x,y;

public Position(int xx,int yy){
  x=xx;
  y=yy;
}

public int  GetX(){
  return x;
}


public int GetY(){
  return y;
}

public void SetX(int xx){
  x=xx;
}

public void SetY(int xx){
  y=xx;
}

@Override
public boolean equals(Object o){
  Position p;
  if(o==null) return false;
  if(!(o instanceof Position)) return false;
  p= (Position) o;
  if(x==p.x && y==p.y) return true;
  else return false;
}


}