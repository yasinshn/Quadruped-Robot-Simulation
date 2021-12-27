long millisOld = 0;

float[] adimBX = new float[4];
float[] adimBY = new float[4];

float[] adimKX = new float[4];
float[] adimKY = new float[4];

float[] adimSX = new float[4];
float[] adimSY = new float[4];

float[] bezX = new float[4];
float[] bezY = new float[4];

float u1 = 0.1, u2 = 0.1;
int mod = 0;
float adimL = -60 ;
boolean sira = true;

void bezierCurve(float adimL_,boolean bezierBool_){
  adimL = adimL_;
  
  for(byte i = 0; i < adimSX.length; i++){
  adimSX[i] = adimBX[i] + adimL_;
  adimSY[i] = adimBY[i];
  adimKX[i] = adimBX[i] + adimL_/2;
  adimKY[i] = adimBY[i] - 50;
  }
 if(bezierBool_){
 if(sira == true && count % 2 == 0 ){ 
  if(millis() - (millisOld) > 0){
  bezX[0] = sq(1-u1)*adimBX[0] + 2*(1-u1)*u1*adimKX[0] + sq(u1)*adimSX[0]; 
  bezY[0] = sq(1-u1)*adimBY[0] + 2*(1-u1)*u1*adimKY[0] + sq(u1)*adimSY[0];
  
  bezX[3] = sq(1-u1)*adimBX[3] + 2*(1-u1)*u1*adimKX[3] + sq(u1)*adimSX[3]; 
  bezY[3] = sq(1-u1)*adimBY[3] + 2*(1-u1)*u1*adimKY[3] + sq(u1)*adimSY[3];

  u1 += 0.1;
  govdeX += (u1 >= 0.1)? adimL/(u1*100) :0;
 if(u1 > 1){
     u1 = 0.1;
     sira = false;
     yaw += radians(1);
    }
  }
//delay(10);  
millisOld = millis();
 }
 
 
 else if(sira == false && count % 2 == 0 ){ 
  if(millis() - (millisOld) > 0){
  bezX[1] = sq(1-u2)*adimBX[1] + 2*(1-u2)*u2*adimKX[1] + sq(u2)*adimSX[1]; 
  bezY[1] = sq(1-u2)*adimBY[1] + 2*(1-u2)*u2*adimKY[1] + sq(u2)*adimSY[1];
  
  bezX[2] = sq(1-u2)*adimBX[2] + 2*(1-u2)*u2*adimKX[2] + sq(u2)*adimSX[2]; 
  bezY[2] = sq(1-u2)*adimBY[2] + 2*(1-u2)*u2*adimKY[2] + sq(u2)*adimSY[2];

  u2 += 0.1;
  govdeX += (u1 >= 0.1)? adimL/(u2*100) :0;
 if(u2 > 1){
     u2 = 0.1;
     sira = true;
     yaw -= radians(1);
   }
  }
//delay(10);  
millisOld = millis();
 }
 }
}
