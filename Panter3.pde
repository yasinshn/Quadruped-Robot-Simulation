import controlP5.*;
ControlP5 cp5;
ControlGroup messageBox;

PShape baldir, bacak, govde;

PFont font;

public static final float len1 = 130, len2 = 120;
float govdeX, govdeY, govdeZ;

float[] baldirX = new float[4];
float[] baldirY = new float[4];
float[] baldirZ = new float[4];

float[] bacakX = new float[4];
float[] bacakY = new float[4];
float[] bacakZ = new float[4];

float[] alpha = new float[4];
float[] beta = new float[4];

float[] alphaBias = new float[4];

float[] endPointX = new float[4];
float[] endPointY = new float[4];
float[] endPointZ = new float[4];

float yaw, pitch, roll;
boolean activateStatikRot = true;
boolean activateBias = false;
boolean tersK = true;
boolean bezierBool = true;
float alphaRef = radians(0), betaRef = radians(0);

float rotX,rotY;
int count = 0;
byte adimPol = -1;
float alphaRefOld;

float olcek = 0.75f;

public void settings(){
System.setProperty("jogl.disable.openglcore", "true");
size(1400,900,P3D);
}

void setup(){
background(#302f2d);

font = loadFont("NotoSansMonoCJKsc-Bold-16.vlw");

baldir = loadShape("robot_baldır.obj");
baldir.disableStyle();

bacak = loadShape("robot_bacak.obj");
bacak.disableStyle();

govde = loadShape("Panter-Body.obj");
govde.disableStyle();  

govdeX = 0;  
govdeY = -190;  
govdeZ = 0;

for(byte i = 0; i < alpha.length; i++){
  alpha[i] = radians(45);
  beta[i] = radians(90);
  alphaBias[i] = radians(-135);
}

pitch = radians(0);
roll = radians(0);
yaw = radians(0);

ControlP5 cp5 = new ControlP5(this);
arayuz(cp5);

}


void draw(){
  clear();
  tersK = !(activateStatikRot);
  bezierBool = !(activateStatikRot);
  pushMatrix();
  translate(width/2,height/2,0);
  rotateX(rotX);
  rotateY(-rotY);
  scale(olcek);
  smooth();
  lights();
  statikRot(activateStatikRot);
  govdeHiyerarsi();
  duzKinematik(alphaRef,betaRef);
  bezierCurve(adimL, bezierBool);
  tersKinematik(bezX,bezY,endPointZ, tersK);
  alphaRefOld = alphaRef;
  pushMatrix();
  translate(govdeX,govdeY,govdeZ);
  fill(50);
  stroke(50);
  rotateY(yaw);
  rotateZ(pitch);
  rotateX(roll);
  shape(govde);
  popMatrix();
  
  //Sol Ön baldir
  pushMatrix();
  translate(baldirX[0], baldirY[0], baldirZ[0]);
  fill(#85c1e9);
  stroke(#85c1e9);
  rotateZ(alpha[0]);
  shape(baldir);
  popMatrix();
  
  //Sol Ön Bacak
  pushMatrix();
  translate(bacakX[0], bacakY[0], bacakZ[0]);
  fill(50);
  stroke(50);
  rotateZ(beta[0] + alpha[0]);
  shape(bacak);
  popMatrix();
  
  //Sağ On Baldir
  pushMatrix();
  translate(baldirX[1], baldirY[1], baldirZ[1]);
  fill(#85c1e9);
  stroke(#85c1e9);
  rotateZ(alpha[1]);
  shape(baldir);
  popMatrix();
  
  //Sağ On Bacak
  pushMatrix();
  translate(bacakX[1], bacakY[1], bacakZ[1]);
  fill(50);
  stroke(50);
  rotateZ(beta[1] + alpha[1]);
  shape(bacak);
  popMatrix();
  
  //Sol Arka Baldir
  pushMatrix();
  translate(baldirX[2], baldirY[2], baldirZ[2]);
  fill(#85c1e9);
  stroke(#85c1e9);
  rotateZ(alpha[2]);
  shape(baldir);
  popMatrix();
  
  //Sol Arka Bacak
  pushMatrix();
  translate(bacakX[2], bacakY[2], bacakZ[2]);
  fill(50);
  stroke(50);
  rotateZ(beta[2] + alpha[2]);
  shape(bacak);
  popMatrix();
  
  //Sağ Arka Baldir
  pushMatrix();
  translate(baldirX[3], baldirY[3], baldirZ[3]);
  fill(#85c1e9);
  stroke(#85c1e9);
  rotateZ(alpha[3]);
  shape(baldir);
  popMatrix();
  
  //Sağ Arka Bacak
  pushMatrix();
  translate(bacakX[3], bacakY[3], bacakZ[3]);
  fill(50);
  stroke(50);
  rotateZ(beta[3] + alpha[3]);
  shape(bacak);
  popMatrix();
  
  kareDuzlem();
  
  popMatrix();
  //Deneme Alanı  
  println("alpha[0]: "+degrees(alpha[0])+"  beta[0]: "+degrees(beta[0]));
  println("bezX[0]: "+bezX[0]+ "  bezY[0]: "+bezY[0]);
  println("alpha_1: "+degrees(alpha[1])+"  beta_1: "+degrees(beta[1]));

}

void kareDuzlem(){
  pushMatrix();
  translate(-2000,0,-1000);
  strokeWeight(3);
  stroke(#defc65);
  rotateX(radians(90));
  rotateZ(pitch - radians(3));
  for(int i = 0; i < 45; ++i){
    for(int j = 0; j < 45; ++j){
      fill(#e5e8e8);
      rect(i*75, j*75, (i+1)*75, (j+1)*75);
    }
  
  }
  //rotateZ(-pitch + radians(3));
  //rotateX(-90);
  popMatrix();

}


void govdeHiyerarsi(){
   //Sol Ön Baldir
  baldirX[0] = govdeX - 150; 
  baldirY[0] = (roll == 0 && pitch == 0) ? govdeY : govdeY - 75 *sin(roll) - 150 * sin(pitch);
  baldirZ[0] = govdeZ + 70;
  //Sol On Bacak
  bacakX[0] = baldirX[0] + len1 * cos(alpha[0]);
  bacakY[0] = baldirY[0] + len1 * sin(alpha[0]);
  bacakZ[0] = baldirZ[0];
  
  //Sağ Ön Baldir
  baldirX[1] = govdeX - 150;
  baldirY[1] = (roll == 0 && pitch == 0) ? govdeY : govdeY + 65 * sin(roll) - 150 * sin(pitch);
  baldirZ[1] = govdeZ - 75;
  //Sağ On Bacak
  bacakX[1] = baldirX[1] + len1 * cos(alpha[1]);
  bacakY[1] = baldirY[1] + len1 * sin(alpha[1]);
  bacakZ[1] = baldirZ[1];
  
  //Sol Arka Baldir
  baldirX[2] = govdeX +150; 
  baldirY[2] = (roll == 0 && pitch == 0) ? govdeY : govdeY - 75 * sin(roll) + 150 * sin(pitch); 
  baldirZ[2] = govdeZ + 70; 
  //Sol Arka Bacak
  bacakX[2] = baldirX[2] + len1 * cos(alpha[2]);
  bacakY[2] = baldirY[2] + len1 * sin(alpha[2]);
  bacakZ[2] = baldirZ[2];
  
  //Sağ Arka Baldir
  baldirX[3] = govdeX +150; 
  baldirY[3] = (roll == 0 && pitch == 0 ) ? govdeY : govdeY + 65 * sin(roll) + 150 * sin(pitch); 
  baldirZ[3] = govdeZ - 75;
  //Sağ Arka Bacak
  bacakX[3] = baldirX[3] + len1 * cos(alpha[3]);
  bacakY[3] = baldirY[3] + len1 * sin(alpha[3]);
  bacakZ[3] = baldirZ[3];
  
}

public void arayuz(ControlP5 cp5){
  messageBox = cp5.addGroup("Islemler", 0,100);
  messageBox.setSize(300,300);
  messageBox.setBackgroundColor(color(120,120,80,120));
 
  cp5.addButton("ILERI")
  .setValue(0)
  .setPosition(10,180)
  .setSize(80,30);
  
  cp5.addButton("GERI")
  .setValue(0)
  .setPosition(110,180)
  .setSize(80,30);
  
  cp5.addSlider("BIAS ACISI-P")
  .setPosition(10,110)
  .setSize(180,20)
  .setRange(0,30)
  .setValue(0);
  
  
  cp5.addSlider("BIAS ACISI-N")
  .setPosition(10,140)
  .setSize(180,20)
  .setRange(0,30)
  .setValue(0)
  .setColorForeground(255);
   
  cp5.addTextlabel("label")
  .setText("Quadruped Robot by YASIN SAHIN")
  .setPosition(10,350)
  .setColorValue(#16dca0)
  .setFont(font)
  ; 
  
  cp5.addButton("pitchInc1")
  .setValue(0)
  .setPosition(10,230)
  .setSize(80,30);
  
  cp5.addButton("pitchDec1")
  .setValue(0)
  .setPosition(110,230)
  .setSize(80,30);
  
  cp5.addButton("statikRot")
  .setValue(0)
  .setPosition(200,230)
  .setSize(80,30);
  
  cp5.addButton("BIAS")
  .setValue(0)
  .setPosition(200,180)
  .setSize(80,30);

  cp5.addButton("rollInc")
  .setValue(0)
  .setPosition(10,270)
  .setSize(80,30);
  
  cp5.addButton("rollDec")
  .setValue(0)
  .setPosition(110,270)
  .setSize(80,30);
  }
  
  public int ILERI(){
    count++;
    return count;
  }
  public int GERI(){
  adimPol *= -1;
  return adimPol;
  }
  
  public float BIASP(){
  alphaRef -= radians(3);
  //betaRef += radians(3);
  return alphaRef;
  }
  
  public void controlEvent(ControlEvent event){
    
    if(event.isController()){
      if(event.getController().getName() == "BIAS ACISI-P"){
         alphaRef += radians(event.getController().getValue());
         betaRef -= radians(event.getController().getValue());
         govdeY -= (degrees(alpha[0])/30);  
     }
       if(event.getController().getName() == "BIAS ACISI-N"){
         alphaRef -= radians(event.getController().getValue());
         betaRef += radians(event.getController().getValue());
         govdeY += (degrees(alpha[0])/30);  
     }
     if(event.getController().getName() == "pitchInc1"){
       
          alpha[1] += radians(0.5);
          alpha[0] += radians(0.5);
          beta[1] += radians(0.1);
          beta[0] += radians(0.1);
          
          alpha[2] -= radians(0.5);
          alpha[3] -= radians(0.5);
          beta[2] -= radians(0.1);
          beta[3] -= radians(0.1);
     }
     if(event.getController().getName() == "pitchDec1"){
       alpha[1] -= radians(0.5);
       alpha[0] -= radians(0.5);
       beta[1] -= radians(0.1);
       beta[0] -= radians(0.1);
       
       alpha[2] += radians(0.5);
       alpha[3] += radians(0.5);
       beta[2] += radians(0.1);
       beta[3] += radians(0.1);
     }
     if(event.getController().getName() == "statikRot"){
       activateStatikRot = !(activateStatikRot);
     }
     if(event.getController().getName() == "BIAS"){
       activateBias = !(activateBias);
     }
     if(event.getController().getName() == "rollInc"){
       alpha[1] -= radians(1);
       alpha[3] -= radians(1);
       beta[1] -= radians(1);
       beta[3] -= radians(1);
       
       alpha[2] += radians(1);
       alpha[0] += radians(1);
       beta[2] += radians(1);
       beta[0] += radians(1);
     }
     if(event.getController().getName() == "rollDec"){
       alpha[1] += radians(1);
       alpha[3] += radians(1);
       beta[1] += radians(1);
       beta[3] += radians(1);
       
       alpha[2] -= radians(1);
       alpha[0] -= radians(1);
       beta[2] -= radians(1);
       beta[0] -= radians(1);
     }
     if(event.getController().getName() == "GERI"){
       
     }
     
    }
  }

void mouseDragged(){
  rotY -= (mouseX - pmouseX) * 0.002;
  rotX -= (mouseY - pmouseY) * 0.005;
}

void keyPressed(){
  switch(keyCode){
  case UP:
  olcek += 0.1;
  break;
  case DOWN:
  olcek -= 0.1;
  break;
  case LEFT:
  olcek += 0.01;
  //alphaRef += radians(5);
  break;
  case RIGHT:
  olcek -= 0.01;
  //alphaRef -= radians(5);
  break;
  }
}
