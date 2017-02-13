function queryAngle(angle){
  if(angle==0){
    return "北"
  } else if(angle==90){
    return "东"
  } else if(angle==180){
    return "南"
  } else if(angle==270){
    return "西"
  }else if(angle>0 && angle<90){
    return "东北"
  }else if(angle>90 && angle<180){
    return "东南"
  }else if(angle>180 && angle<270){
    return "西南"
  }else if(angle>270){
    return "西北"
  }

}
function queryCarIcon(angle){

  if(angle==0){
    return "vehicle0.png"
  }else if(angle>0 && angle<45){
    return "vehicle0_45.png"
  }else if(angle==45){
    return "vehicle45.png"
  }else if(angle>45 && angle<90){
    return "vehicle45_90.png"
  }else if(angle==90){
    return "vehicle90.png"
  }else if(angle>90 && angle<135){
    return "vehicle90_135.png"
  }else if(angle==135){
    return "vehicle135.png"
  }else if(angle>135 && angle<180){
    return "vehicle135_180.png"
  }else if(angle==180){
    return "vehicle180.png"
  }else if(angle>180 && angle<225){
    return "vehicle180_225.png"
  }else if(angle==225){
    return "vehicle225.png"
  }else if(angle>225 && angle<270){
    return "vehicle225_270.png"
  }else if(angle==270){
    return "vehicle270.png"
  }else if(angle>270 && angle<315){
    return "vehicle270_315.png"
  }else if(angle==315){
    return "vehicle315.png"
  }else if(angle>315 && angle<350){
    return "vehicle315_350.png"
  }else{
    return "vehicle0.png"
  }

}