void myStroke(int _i,int _alpha){
  int _j=_i/256;
  switch(_j%6){
    case 0:{stroke(       255,    _i%256,         0,_alpha);break;}
    case 1:{stroke(255-_i%256,       255,         0,_alpha);break;}
    case 2:{stroke(         0,       255,    _i%256,_alpha);break;}
    case 3:{stroke(         0,255-_i%256,       255,_alpha);break;}
    case 4:{stroke(    _i%256,         0,       255,_alpha);break;}
    case 5:{stroke(       255,         0,255-_i%256,_alpha);break;}
  }
}
