void tiempoRandom() {
  if (resetCuenta == false){
    cuenta=round(random(50,200));
    resetCuenta = true;
  }
}

void tiempoDeEspera(){
  tiempoRandom();
  if (cuenta >= 0){
  cuenta--;
  impulso = false;
  } else {
  resetCuenta = false;
  impulso = true;
  }  
}

void cuentaRegresivaDanio(){
  if (refreshDanio == true){
    if(cuentaDanio >= 0){
    cuentaDanio --;
    } else {
      refreshDanio = false;
      cuentaDanio = 200;
    }
  }
}

void tiempoDeJuego (){
  if (segundos > 0 && frameCount%60 == 0){
    segundos -= 1;
  }
}
