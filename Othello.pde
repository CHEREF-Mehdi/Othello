//import libreries to play sounds

import ddf.minim.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer put,loose,music,choose,win;

final int infinity=99999999;
PImage img,Ah,Ac,Ab,img1,sound;
int h,menu;
char[] lettres={' ','A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'};
PFont font;
boolean newGameClicked,colorChoosed,restart,Home,turnhuman,clickH,clickC,mute;
Player cmp,human;
Tree IA;
PShape rectsound;
Move NextmoveCmp=null,lastMove;

int [][] StateGame={
  {0, 0, 0,  0,  0, 0, 0, 0}, 
  {0, 0, 0,  0,  0, 0, 0, 0}, 
  {0, 0, 0,  0,  0, 0, 0, 0}, 
  {0, 0, 0, -1,  1, 0, 0, 0}, 
  {0, 0, 0,  1, -1, 0, 0, 0}, 
  {0, 0, 0,  0,  0, 0, 0, 0}, 
  {0, 0, 0,  0,  0, 0, 0, 0}, 
  {0, 0, 0,  0,  0, 0, 0, 0}, 
};

int [][] Ranges={
  {150, -50, 16, 10, 10, 16, -50, 150}, 
  {-50, -60,-15,-10,-10,-15, -60, -50}, 
  { 16, -15,  8,  5,  5,  8, -15,  16}, 
  { 10, -10,  5,  2,  2,  5, -10,  10}, 
  { 10, -10,  5,  2,  2,  5, -10,  10}, 
  { 16, -15,  8,  5,  5,  8, -15,  16}, 
  {-50, -60,-15,-10,-10,-15, -60, -50}, 
  {150, -50, 16, 10, 10, 16, -50, 150},  
};

void setup() {
  size(854, 627);
  
  //importe images
  img = loadImage("2p.jpg");
  Ah = loadImage("angleH.jpg");
  Ac=loadImage("angleC.jpg");
  Ab=loadImage("angleBB.jpg");
  img1=loadImage("texture - Copy.jpg");
  sound=loadImage("sound.png");
  
  //import sonds
  minim = new Minim(this);    
  put = minim.loadFile("put.mp3");
  loose=minim.loadFile("628.mp3");
  music=minim.loadFile("10670.mp3");
  choose=minim.loadFile("14199.mp3");
  win=minim.loadFile("19266.mp3");
  
  music.setGain(-15); 
  loose.setGain(-25);
  put.setGain(-17);
  win.setGain(-17);
  choose.setGain(-17);  
  
  //init booleans
  newGameClicked=false;
  colorChoosed=false;
  restart=false;
  Home=false;
  clickH=false;
  clickC=false;
  mute=false;
  
  //init menu
  menu=0;  
  h=595;
  
  loadPixels();
}

void draw() {
  
  switch(menu){
    
    case(0):{
        cursor(ARROW);
        textAlign(LEFT);
        image(img1, 0, 0,854,627);
        fill(color(154,212,204));           
        font=createFont("Old English Text MT",100);
        textFont(font);        
        text("Othello", 290, 570);
        
        
        //go back home
        if(mouseX>=14 && mouseX<=94 && mouseY>=15 && mouseY<=45 && newGameClicked){
            fill(color(154,212,204));
            font=createFont("Old English Text MT",40);
            textFont(font);
            text("Othello", 5, 35);
            
        }else{            
            fill(255);
            font=createFont("Old English Text MT",30);
            textFont(font);
            text("Othello", 15, 30);            
        }
        
        
        if(mouseX>=280 && mouseX<=592 && mouseY>=80 && mouseY<=145 && !newGameClicked){
            fill(color(154,212,204));          
            font=createFont("Old English Text MT",80);
            textFont(font);
            text("New game", 260, 134);
            
            
        }else{
          if(newGameClicked){
              
              fill(255);              
              font=createFont("Old English Text MT",50);
              textFont(font);
              text("Choose your color", 250, 70);
              font=createFont("Old English Text MT",25);
              textFont(font);
              text("(The black one begins first)", 300, 100);
              
              //choisir la couleur
              if(mouseX>=339 && mouseX<=410 && mouseY>=100 && mouseY<=179){
                  WightPawn(380,150,70,20);
                  BlackPawn(480,150,55,15);
              }else{
                  if(mouseX>=444 && mouseX<=515 && mouseY>=100 && mouseY<=179){
                      WightPawn(380,150,55,15);
                      BlackPawn(480,150,70,20);
                  }else{
                        WightPawn(380,150,55,15);
                        BlackPawn(480,150,55,15);
                  }             
                }
                                
          }else{
            fill(255);            
            font=createFont("Old English Text MT",70);
            textFont(font);
            text("New game", 280, 134);
          }
          
        }
        break;
    }//case 0
    
    case(1) :{
                cursor(ARROW);
                showSpaceGame();
                
                dashboard();                
                                
                //show moves palayble
                human.showPositionPlayable();  
                
                if(human.MovePossible.size()==0) human.cantPlay=true;
                break;
                
    }//case 1
    case 11 :{ //computers turn
                  showSpaceGame();                 
                  
                  cursor(ARROW);
                  
                  println("------------------------------------------//////---------------------------------------");
                  //create root's tree
                  IA=new Tree(cmp.GetPawn(),StateGame,null,cmp.GetScore()-human.GetScore(),Ranges);                               
                  //show the state of the game before computer's turn
                  IA.showMatrice(StateGame);
                  //create the tree of possibilities
                  IA.CreateTree(3,0);  
                  
                  if(IA.sons!=null && IA.sons.size()!=0) {  

                    //brows the tree with alphabeta algho                   
                    IA.ALPHABETA(1,-infinity,infinity);
                    
                    println("\nnbr moves playable :"+IA.sons.size());
                    println("root node = "+IA.node);
                    
                    //print all possible moves that cpm could play
                    for(int i=0;i<IA.sons.size();i++) print("son node "+(i+1)+" ="+IA.sons.get(i).node+" move :"+IA.sons.get(i).move+"\n");
                    println();
                                        
                    //get the next move
                    NextmoveCmp=IA.NextMove();
                    
                    IA.negaMax(1,-infinity,infinity);
                                                           
                    println("root node = "+IA.node);
                    //print all possible moves that cpm could play
                    for(int i=0;i<IA.sons.size();i++) print("son node "+(i+1)+" ="+IA.sons.get(i).node+" move :"+IA.sons.get(i).move+"\n");
                    println();
                    
                    
                    cmp.cantPlay=false;
                    
                    menu=12;                    
                  }else{                    
                      NextmoveCmp=null;
                      cmp.cantPlay=true;                
                  }

                  dashboard();
              break;
    }//case 11
    
    case 12 :{//execute move cmp
                
                //delay(500);
                lastMove=new Move(NextmoveCmp.GetPos(),NextmoveCmp.GetRec(),Ranges);
                println("CMP's move :"+lastMove.toString());                
                
                if(!mute) put.play(500);                
                //update stategame
                StateGame[NextmoveCmp.GetPos().GetX()][NextmoveCmp.GetPos().GetY()]=cmp.GetPawn();
                cmp.score(NextmoveCmp.GetPos(),false,StateGame); 
                
                UpdateScore();
                turnhuman=true;              

                menu=1;
                
                UpdateScore();
                
                //update ranges
                SetRanges(); 
                  
                //show state game after computer's turn
                IA.showMatrice(StateGame);      
                
                //init list move playable human
                human.resetMovePossible();
                
                //get moves playable human
                for(int i=0;i<8;i++){
                  for(int j=0;j<8;j++){
                    if(StateGame[i][j]==human.GetPawn()){
                      human.MovePossible(new Position(i,j),StateGame,Ranges);
                    }                    
                  }
                }//boucle for
                
                println("------------------------------------------//////----------------------------------");
                  
                  
                  //delay(5000);
                  
                  /*jouer a la place du pc
                  cmp.resetMovePossible();
                    for(int i=0;i<8;i++){
                      for(int j=0;j<8;j++){
                        if(StateGame[i][j]==cmp.GetPawn()){
                          cmp.MovePossible(new Position(i,j),StateGame);
                        }                    
                      }
                    }                    
                    cmp.showPositionPlayable();   */                                     
                        
                
                break;
    }//case 12
    
    case 2 :{  //show finale score
                cursor(ARROW);
                showSpaceGame();
                
                dashboard(); 
                
                ShowFinalScore();
                break;
    }//case ==2
        
    
  }//switch
  
  
}//draw



void mouseClicked(){
  int x,y;
  if(menu==0){
      if(!newGameClicked){
          if(mouseX>=280 && mouseX<=592 && mouseY>=80 && mouseY<=140){            
            if(!mute) music.loop();  
            newGameClicked=true;
            Home=false;
            cursor(HAND);
          }
      }else{
        if(mouseX>=339 && mouseX<=410 && mouseY>=100 && mouseY<=179){
              //WightPawn choosed;
              if(!mute) choose.play(0);cursor(HAND);
              cmp=new Player(1);
              human=new Player(-1);
              menu=11;
              restart=false;
              turnhuman=false;
              initStateGame();
              println("---------------------------------------/////////////---------------------------------------------------");
              println("                                        new Game");
              println("---------------------------------------/////////////---------------------------------------------------");
        }else{
            if(mouseX>=444 && mouseX<=515 && mouseY>=100 && mouseY<=179){                
                //BlackPawn choosed;
                if(!mute) choose.play(0);cursor(HAND);
                cmp=new Player(-1);
                human=new Player(1);
                menu=1;
                restart=false; 
                turnhuman=true;
                initStateGame();
                
                //init list move playable human
                human.resetMovePossible();
                
                //get moves playable human
                for(int i=0;i<8;i++){
                  for(int j=0;j<8;j++){
                    if(StateGame[i][j]==human.GetPawn()){
                      human.MovePossible(new Position(i,j),StateGame,Ranges);
                    }                    
                  }
                }//boucle for
                
                println("---------------------------------------/////////////---------------------------------------------------");
                println("                                        new Game");
                println("---------------------------------------/////////////---------------------------------------------------");
            }else{
                if(mouseX>=14 && mouseX<=94 && mouseY>=15 && mouseY<=45){
                    Home=true;
                    newGameClicked=false;                   
                }
            }
        }
      }//end else (newGameClicked =false)
      
      
        
  }else{
      if(menu==1 || menu==2 || menu==11){
        
        if(mouseX>=660 && mouseX<=820 && mouseY>=580 && mouseY<=600 && !restart){//click on "yes" to restart
            restart=true;
            cursor(HAND);
        }                
        
        if(restart){
          if(mouseX>=680 && mouseX<=720 && mouseY>=590 && mouseY<=615){
            //yes restart parti
            cursor(HAND);
            if(!mute) music.loop(0);
            restart=false;            
            Home=false;
            menu=0;            
          }else{
              if(mouseX>=780 && mouseX<=810 && mouseY>=590 && mouseY<=615){
                  //not restat parti
                  cursor(HAND);
                  restart=false;
              }
           }
         }// if restart
         
         //sound
        if(mouseX>=810 && mouseX<=850 && mouseY>=2 && mouseY<=42){
            cursor(HAND);
            if(!mute) { sound = loadImage("mute.png");  soundPause();  mute=true;}
            else {      sound = loadImage("sound.png");   soundPlay();   mute=false;}
         }
        
        //execute move's player
        if(turnhuman){                                                                  
            if(human.GetCantPlay()){ //if human can't play                               
                if(mouseX>=680 && mouseX<=800 && mouseY>=105 && mouseY<=130){ //click on end turn
                      turnhuman=false;
                      menu=11;
                      cursor(HAND);
                }
            }else{// human can play
                
                for(int i=0;i<human.GetMovep().size();i++){
                  
                    x=(human.GetMovep().get(i).GetPos().GetX()+1)*70;
                    y=(human.GetMovep().get(i).GetPos().GetY()+1)*70;
                    
                    if(mouseX>=y-35 && mouseX<=y+35 && mouseY>=x-35 && mouseY<=x+35){
                      
                      println("Player's move : "+human.GetMovep().get(i).toString());
                      cursor(HAND);
                      if(!mute) put.play(500);
                      StateGame[x/70-1][y/70-1]=human.GetPawn();
                      human.score(human.GetMovep().get(i).GetPos(),false,StateGame);                                            
                      UpdateScore();
                      turnhuman=false; 
                      menu=11;
                      showSpaceGame();
                      dashboard();
                    }
                }//boucle for
                
            }//end else if human can't play   
            
        }// end if tour humain        
        else{// computer turn  
        
          if(cmp.GetCantPlay()){//cumputer can't play
              if(mouseX>=680 && mouseX<=800 && mouseY>=105 && mouseY<=130){ //click on end turn
                      turnhuman=true;
                      menu=1;
                      cursor(HAND);
                      //init list move playable human
                      human.resetMovePossible();
                      
                      //get moves playable human
                      for(int i=0;i<8;i++){
                        for(int j=0;j<8;j++){
                          if(StateGame[i][j]==human.GetPawn()){
                            human.MovePossible(new Position(i,j),StateGame,Ranges);
                          }                    
                        }
                      }//boucle for
               }
          }
          
          /* jouer a la place du pc
          if(!cmp.GetCantPlay()){ //cumputer can play
              for(int i=0;i<cmp.GetMovep().size();i++){
                x=(cmp.GetMovep().get(i).GetPos().GetX()+1)*70;
                y=(cmp.GetMovep().get(i).GetPos().GetY()+1)*70;
                  if(mouseX>=x-35 && mouseX<=x+35 && mouseY>=y-35 && mouseY<=y+35){

                          if(!put.isPlaying()){                            
                            put.play(500);
                          } 
                          
                          
                    delay(100);      
                    StateGame[x/70-1][y/70-1]=cmp.GetPawn();
                    cmp.score(cmp.GetMovep().get(i).GetPos(),false,StateGame);                    
                    UpdateScore();
                    turnhuman=true;  
                    human.resetMovePossible();
                  }
              }//boucle for
              
          }//if cmp can play
          else{
                turnhuman=true;                 
          }*/
          
        }//else if tourhuman
        
      }//end if menu 1
  
  }//end else menu ==0
  
  
}//end mouseClicked function


void dashboard(){
  
  stroke(color(154,212,204));
  strokeWeight(2);
  
  //drow Array score
  //lignes horisontales
  line(645,160,840,160);
  line(645,215,840,215);
  line(645,255,840,255);
  line(645,300,840,300);
  
  //lignes verticales
  line(644,160,644,300);
  line(841,160,841,300);
  line(733,216,733,300);
  textAlign(LEFT);
  
  //start new game
  if(mouseX>=660 && mouseX<=820 && mouseY>=580 && mouseY<=600 && !restart){
    fill(255);
    font=createFont("Old English Text MT",30);
    textFont(font);
    text("Start new game", 650, 600);
  }else{
      if(mouseX>=660 && mouseX<=820 && mouseY>=580 && mouseY<=600){
        fill(255);
        font=createFont("Old English Text MT",22);
        textFont(font);
        text("Do you want to restart?", 640, 580);
        //yes or no
        if(mouseX>=680 && mouseX<=720 && mouseY>=590 && mouseY<=615){
          fill(255);
          font=createFont("Old English Text MT",25);
          textFont(font);
          text("Yes", 680, 610);
          font=createFont("Old English Text MT",22);
          textFont(font);
          text("No", 780, 610);
        }else{
          if(mouseX>=780 && mouseX<=810 && mouseY>=590 && mouseY<=615){
              fill(255);  
              font=createFont("Old English Text MT",25);
              textFont(font);
              text("No", 780, 610);              
              font=createFont("Old English Text MT",22);
              textFont(font);
              text("Yes", 680, 610);
          }else{
            fill(255);
            font=createFont("Old English Text MT",22);
            textFont(font);
            text("Yes", 680, 610);
            text("No", 780, 610);
          }
        }
        
      }else{
        if(!restart){
          fill(255);
          font=createFont("Old English Text MT",25);
          textFont(font);
          text("Start new game", 660, 600);          
        }else{
          fill(255);
          font=createFont("Old English Text MT",22);
          textFont(font);
          text("Do you want to restart?", 640, 580);
          //yes or no
        if(mouseX>=680 && mouseX<=720 && mouseY>=590 && mouseY<=615){
          fill(255);
          font=createFont("Old English Text MT",25);
          textFont(font);
          text("Yes", 680, 610);
          font=createFont("Old English Text MT",22);
          textFont(font);
          text("No", 780, 610);
        }else{
          if(mouseX>=780 && mouseX<=810 && mouseY>=590 && mouseY<=615){
              fill(255);  
              font=createFont("Old English Text MT",25);
              textFont(font);
              text("No", 780, 610);              
              font=createFont("Old English Text MT",22);
              textFont(font);
              text("Yes", 680, 610);
          }else{
            fill(255);
            font=createFont("Old English Text MT",22);
            textFont(font);
            text("Yes", 680, 610);
            text("No", 780, 610);
          }
        }
        
        }
        
      }
  }
  
  //show score's players-----------------
  textAlign(LEFT);
  fill(255);
  font=createFont("Old English Text MT",50);
  textFont(font);
  text("Score", 683, 204);
  
  
  font=createFont("Old English Text MT",24);
  textFont(font);
  text("You", 670, 244);
  text("Computer", 740, 244);
  textAlign(CENTER);
  fill(color(27,178,253));
  text(human.GetScore(), 690, 284);
  text(cmp.GetScore(), 785, 284);
  
  //show pawn players
  textAlign(LEFT);
  fill(255);
  font=createFont("Old English Text MT",50);
  text("You         :", 655, 375);
  text("Computer :", 655, 440);
  
  if(human.GetPawn()==1){
    BlackPawn(800,368,55,15);
    WightPawn(800,433,55,15);
  }else{
    WightPawn(800,368,55,15);
    BlackPawn(800,433,55,15);
  }
    //cmp last move
    textAlign(CENTER);
    fill(color(154,212,204));
    font=createFont("Old English Text MT",22);
    textFont(font);
    text("Computer's last move :", 740, 510);
    
    if(lastMove!=null){
      fill(color(224,240,1));
      font=createFont("Old English Text MT",35);
      textFont(font);
      int x=lastMove.GetPos().GetX()+1,
          y=lastMove.GetPos().GetY()+1;
      text(""+lettres[y]+x, 740, 550);
    }
    
    
  fill(color(255));
  textAlign(CENTER);  
  font=createFont("Old English Text MT",25);
  textFont(font);
  
  //sound
  image(sound, 810, 2,40,40);
  
  fill(color(255));
  
  
  //specifie le tour de qui
  if(turnhuman){    
                                 
    if(human.GetCantPlay()){
                           
        if(cmp.GetCantPlay()){//if cmp alredy passed his turn
          //terminer la partis si les deux joueur ne peuvent pas jouer 
          if(menu!=2){
            if(human.GetScore()>cmp.GetScore()){               
              if(!mute) win.play(1400);
            }else{
              if(!mute) loose.play(0);
            }
          }
          menu=2;
          
        }
        else{//if cmp played
            if(!StateGameSatured(StateGame)){//si la matrice du jeu engendre encore des case vide
                text("Your turn", 740, 60);
                fill(color(224,240,1));
                font=createFont("Old English Text MT",20);
                textFont(font);
                text("You can't make any move!", 740, 100);
              
                  if(mouseX>=680 && mouseX<=800 && mouseY>=105 && mouseY<=130){
                    fill(255);
                    font=createFont("Old English Text MT",24);           
                  }else{          
                    font=createFont("Old English Text MT",20);
                  }
              
              textFont(font);
              text("Click to end turn...", 740, 130);
            }else{
              if(menu!=2){
                if(human.GetScore()>cmp.GetScore()){               
                  if(!mute) win.play(1400);
                }else{
                  if(!mute) loose.play(0);
                }
              }
              menu=2;
              cmp.cantPlay=true;
              human.cantPlay=true;
            }
        }
                                 
    }//end if human can't play 
    else{
      text("Your turn", 740, 60);
    }
  }//if turnhuman
  else{ //turn cmp
    
    if(cmp.GetCantPlay()){ //if cmp can't play  
    
      if(human.GetCantPlay()){//if human alredy passed his turn can't play too
          //terminer la partis si les deux joueur ne peuvent pas jouer          
          if(menu!=2){
            if(human.GetScore()>cmp.GetScore()){               
              if(!mute) win.play(1400);
            }else{
              if(!mute) loose.play(0);
            }
          }
          
          menu=2;
          
      }else{
         if(!StateGameSatured(StateGame)){//si la matrice du jeu engendre encore des case vide
            text("Computer's turn", 740,60);
            fill(color(224,240,1));
            font=createFont("Old English Text MT",20);
            textFont(font);
            text("I can't make any move!", 740, 100);
          
              if(mouseX>=680 && mouseX<=800 && mouseY>=105 && mouseY<=130){
                fill(255);
                font=createFont("Old English Text MT",24);           
              }else{          
                font=createFont("Old English Text MT",20);
              }           
              
            textFont(font);
            text("Click to end turn...", 740, 130);
          }else{
            if(menu!=2){
              if(human.GetScore()>cmp.GetScore()){               
                if(!mute)win.play(1400);
              }else{
                if(!mute)loose.play(0);
              }
            }
            
            menu=2;            
            cmp.cantPlay=true;
            human.cantPlay=true;
            
          }
      }
                             
    }else{
      
          text("Computer's turn", 740, 60);
        }
    
  }//else if turnhuman
  
  
}//deashbord


void UpdateScore(){  
  cmp.SetScore(StateGame);
  human.SetScore(StateGame);
}

//check if the stategame is satured we can't put anymore moves
boolean StateGameSatured(int[][] Matrix){
  Player J=new Player(1);int movesP1,movesP2;
  
    for(int i=0;i<8;i++){
      for(int j=0;j<8;j++){
        J.MovePossible(new Position(i,j),Matrix,Ranges);
      }
    }
    movesP1=J.GetMovep().size();
    
    J.SetPawn();
    for(int i=0;i<8;i++){
      for(int j=0;j<8;j++){
        J.MovePossible(new Position(i,j),Matrix,Ranges);
      }
    }
    movesP2=J.GetMovep().size();
    
    if(movesP1==0 && movesP2==0) return true;
    else{
      for(int i=0;i<8;i++) 
        for(int j=0;j<8;j++) 
          if (Matrix[i][j]==0) return false;;
    }
    
    return true;    
}

//for the sounds
void stop() {
  put.close();
  loose.close();
  music.close();
  choose.close();
  win.close();
  minim.stop();
  super.stop();
}

void soundPause(){
  music.pause();
}

void soundPlay(){
  music.loop();
}

//draw wight pawn
void WightPawn(int x,int y,int w,int s){
  int k;
  
  fill(color(250,250,250));
  stroke(color(250,250,250));
  ellipse(x, y, w, w);
 
  k=w-s;
  for(int i=145;i<=230;i=i+5,k--){
    stroke(color(i,i,i));
    fill(color(230,230,230));
    ellipse(x, y, k, k);
  }
}//end wight pawn

//draw black pawn
void BlackPawn(int x,int y,int w,int s){
  int k;
  
  fill(color(21,21,21));
  stroke(color(11,11,11));
  ellipse(x, y, w, w);
  
  k=w-s;
  for(int i=65;i>=11;i=i-3,k--){
    stroke(color(i,i,i));
    fill(color(11,11,11));
    ellipse(x, y, k, k);
  }
}//end black pawn

//draw matrix
void drawPawns(){
  
    for(int i=0;i<8;i++){
      for(int j=0;j<8;j++){
        
          if(StateGame[i][j]==1){//black pawn
              BlackPawn((j+1)*70,(i+1)*70,55,15);
          }else{
            if(StateGame[i][j]==-1){ //wight pawn
                WightPawn((j+1)*70,(i+1)*70,55,15);
            }
          }
      }
    }
}//end draw matrix

//in case of new game

void initStateGame(){
  for(int i=0;i<8;i++) for(int j=0;j<8;j++) StateGame[i][j]=0;
       
  StateGame[3][3]=-1;
  StateGame[4][3]=1;
  StateGame[4][4]=-1;
  StateGame[3][4]=1;
  NextmoveCmp=null;  
  
  int [][] initR={
  {150, -50, 16, 10, 10, 16, -50, 150}, 
  {-50, -60,-15,-10,-10,-15, -60, -50}, 
  { 16, -15,  8,  5,  5,  8, -15,  16}, 
  { 10, -10,  5,  2,  2,  5, -10,  10}, 
  { 10, -10,  5,  2,  2,  5, -10,  10}, 
  { 16, -15,  8,  5,  5,  8, -15,  16}, 
  {-50, -60,-15,-10,-10,-15, -60, -50}, 
  {150, -50, 16, 10, 10, 16, -50, 150}, 
};
   for(int i=0;i<8;i++) for(int j=0;j<8;j++) Ranges[i][j]=initR[i][j];
}

void ShowFinalScore(){
    font=createFont("Old English Text MT",31);
    textFont(font);
    fill(color(224,240,1));
    
    if(human.GetScore()>cmp.GetScore()){
          //human won 
        
        text("Congratulation!", 742, 80);        
        text("YOU WON...", 745, 130);
    }else{
      if(cmp.GetScore()>human.GetScore()){
        
        text("Computer won!", 740, 80);        
        text("Try again...", 740, 120);
      }else{
          // none won    
          
        text("Void party!", 740, 80);         
        text("Try again...", 740,120);
      }
                            
    }
}

//heuristic update ranges 
void SetRanges(){
           
    if(StateGame[0][0]==cmp.GetPawn()){
        if(Ranges[0][1]<0){
          println("update ranges 0.0");
          Ranges[0][1]=-3/2*Ranges[0][1];
          Ranges[1][0]=-3/2*Ranges[1][0];
          Ranges[1][1]=-3/2*Ranges[1][1];
        }
        
        if(Ranges[0][6]<0){
          int i;
          for(i=1;i<=7 && StateGame[0][i]==human.GetPawn();i++){}
          if(i==6) Ranges[0][6]=75;
        }        
        if(Ranges[0][7]==150) Ranges[0][7]=2*150;
        
        if(Ranges[6][0]<0){
          int i;
          for(i=1;i<=7 && StateGame[i][0]==human.GetPawn();i++){}
          if(i==6) Ranges[6][0]=75;
        }
        if(Ranges[7][0]==150) Ranges[7][0]=150*2;
    }
    
    if(StateGame[0][7]==cmp.GetPawn()){
        if(Ranges[0][6]<0){
          println("update ranges 0.7");
          Ranges[0][6]=-3/2*Ranges[0][6];
          Ranges[1][6]=-3/2*Ranges[1][6];
          Ranges[1][7]=-3/2*Ranges[1][7];
        }
        
        if(Ranges[0][1]<0){
          int i;
          for(i=6;i>=0 && StateGame[0][i]==human.GetPawn();i--){}    
          if(i==1) Ranges[0][1]=75;
        }
        if(Ranges[0][0]==150) Ranges[0][0]=150*2;
        
        if(Ranges[6][7]<0){
          int i;
          for(i=1;i<=7 && StateGame[i][7]==human.GetPawn();i++){}    
          if(i==6) Ranges[6][7]=75;
        }  
        if(Ranges[7][7]==150) Ranges[7][7]=150*2;
    }
    
    if(StateGame[7][0]==cmp.GetPawn() ){
      if(Ranges[6][0]<0){
        println("update ranges 7.0");
        Ranges[6][0]=-3/2*Ranges[6][0];
        Ranges[6][1]=-3/2*Ranges[6][1];
        Ranges[7][1]=-3/2*Ranges[7][1];
      }
      
      if(Ranges[1][0]<0){
          int i;
          for(i=6;i>=0 && StateGame[i][0]==human.GetPawn();i--){}  
          if(i==1) Ranges[1][0]=75;
      }
      if(Ranges[0][0]==150) Ranges[0][0]=150*2;
      
      if(Ranges[7][6]<0){
          int i;
          for(i=1;i<=7 && StateGame[7][i]==human.GetPawn();i++){}   
          if(i==6) Ranges[7][6]=75;
      }  
      if(Ranges[7][7]==150) Ranges[7][7]=150*2;
    }
    
    if(StateGame[7][7]==cmp.GetPawn()){                  
        if(Ranges[7][6]<0){
          println("update ranges 7.7");
          Ranges[7][6]=-3/2*Ranges[7][6];
          Ranges[6][6]=-3/2*Ranges[6][6];
          Ranges[6][7]=-3/2*Ranges[6][7];
        }
        if(Ranges[7][1]<0){
          int i;
          for(i=6;i>=0 && StateGame[7][i]==human.GetPawn();i--){}    
          if(i==1) Ranges[7][1]=75;
        } 
        if(Ranges[7][0]==150) Ranges[7][0]=150*2;
        
        if(Ranges[1][7]<0){
          int i;
          for(i=6;i>=0 && StateGame[i][7]==human.GetPawn();i--){}     
          if(i==1) Ranges[1][7]=75;
        } 
        if(Ranges[0][7]==150) Ranges[0][7]=150*2;
                
    }

}

void showSpaceGame(){
 textAlign(LEFT);
  image(img, 0, 0);
  strokeWeight(2);
  stroke(color(254,254,254));

  //show images
  image(Ah, 0, 0);
  image(Ah, 0, 597);
  image(Ac, 0, 0);
  image(Ac, 597, 0);
  image(Ab,0 , 313);
  image(Ab, 597, 313);
  
  //Frame the space of the game
  line(h,h,h+35,h+35);
  line(0,h+35,35,h);
  line(h+33,0,h,35);
  line(0,0,35,35);
  line(h+33,0,h+35,h+35);
  line(0,0,h+33,0);

  for (int x=35; x<=h; x=x+70) {
        line(x,35,x,h);
        line(35,x,h,x);
  }
  
  //write the letters and the numbers to define positions
  fill(255);               
  textSize(26);
  font=createFont("Old English Text MT",20);
  textFont(font);
  for (int i=1; i<9; i++) {
    text(i, 10, i*70);
    text(i, 10+h, i*70);
    text(lettres[i], i*70, 23);
    text(lettres[i], i*70, 23+h);
  }
  
 //draw pawns
  drawPawns();

}
