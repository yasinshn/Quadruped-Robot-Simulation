public void duzKinematik(float alphaD, float betaD){
 
  if(alphaRefOld != alphaRef){
  
  for(byte i = 0;i < bacakX.length; i++){
    alpha[i] += alphaD;
    beta[i] += betaD;
   }
  }
  govdeHiyerarsi();
}

public void statikRot(boolean rotGovde_){
  if(rotGovde_){
    pitch = (alpha[0] - alpha[2]);
    roll = (alpha[1] - alpha[2]);
  }
}

public void tersKinematik(float[] endPointXT, float[] endPointYT, float[] endPointZT , boolean tersK_){
 if(tersK_){
  for(byte i = 0; i < endPointX.length; i++){
    endPointX[i] = endPointXT[i];
    endPointY[i] = endPointYT[i];
    endPointZ[i] = endPointZT[i]; 
      
  alpha[i] = asin((sq(endPointX[i]) + sq(endPointY[i]) + sq(len1) - sq(len2)) 
  / ( 2 * len1 * sqrt(sq(endPointX[i])+sq(endPointY[i]))) ) - atan2(endPointY[i],endPointX[i]) + alphaBias[i]+ alphaRef;
   
   beta[i] = acos((sq(endPointX[i]) + sq(endPointY[i]) - sq(len1) - sq(len2)) 
 / (2 * sq(len1) * sq(len2)) ) + betaRef ;
    
  if(i == 0 || i == 3)  
  beta[i] += (alpha[i] < radians(72)) ? u1/2.5 : -u1/2.5;
  else beta[i] += (alpha[i] < radians(72)) ? u2/2.5 : -u2/2.5;
  
  }
 }
  govdeHiyerarsi();
}
