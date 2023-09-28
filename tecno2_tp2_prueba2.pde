import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import netP5.*;
import oscP5.*;
import fisica.*;
Minim minim;
AudioPlayer musica;

Obstaculo obstaculo;
Astronauta astronauta;
Nave nave;

int PUERTO_OSC = 12345;

Receptor receptor;

PImage fondo1, fondo2, fondo3, fondo4;

FWorld world;
FCircle c1;
FCircle obs1, obs2, obs3, obs4, obs5;

float x = 300;
float y = height/2;
float  diam = 20;

boolean randomOff = false;
boolean resetCuenta = false;
boolean impulso = false;
boolean derecha;
boolean izquierda;
boolean arriba;
boolean abajo;
boolean refreshDanio = false;
int cuentaDanio = 200;
int cuenta;
int fx;
int fy;
int puntos = 0;
int puntosParaPerder = 5;
int segundos = 30;


int pantalla = 1;

void setup() {
  size(600, 1000);

  astronauta = new Astronauta(x, y, diam);
  obstaculo = new Obstaculo();
  nave = new Nave();

  fondo1 = loadImage("inicio.jpeg");
  fondo2 = loadImage("instrucciones.jpeg");
  fondo3 = loadImage("espacio1.jpg");
  fondo4 = loadImage("perder.jpg");

  minim = new Minim(this);
  musica = minim.loadFile("musica.wav");

  Fisica.init(this);
  world = new FWorld();
  world.setEdges();
  world.setGravity(0, 0);

  setupOSC(PUERTO_OSC);
  receptor = new Receptor();

  astronauta.crearPJ();
  obstaculo.crearObstaculo();

}

void draw() {
  background(255);
  //INICIO
  if (pantalla == 1) {
    fondo1.resize(width, height);
    image (fondo1, 0, 0);
  }
  //INSTRUCCIONES
  else if (pantalla ==2) {
    fondo2.resize(width, height);
    image(fondo2, 0, 0);
  }
  //JUEGO
  else if (pantalla ==3) {
    fondo3.resize(width, height);
    image(fondo3, 0, 0);
    //cosas que se inician cuando empieza el juego
    musica.play();
    world.step();
    world.draw();
    juego();
    lugarDeCara();
    nave.dibujar();
  }
  //PERDER
  else if (pantalla == 4) {
    fondo4.resize(width, height);
    image(fondo4, 0, 0);
    segundos = 30;
  }

}

void keyPressed() {
  if (keyCode == RIGHT) {
    c1.addForce(100000, 0);
  }
  if (keyCode == LEFT) {
    c1.addForce(-100000, 0);
  }
  if (keyCode == UP) {
    c1.addForce(0, -100000);
  }
  if (keyCode == DOWN) {
    c1.addForce(0, 100000);
  }


  if ( pantalla == 1 && keyCode == 'i' || keyCode == 'I' ) {
    pantalla = 2;
  }
  if ( pantalla == 2 && keyCode == 'c' || keyCode == 'C' ) {
    pantalla = 3;
  }
}

void moverAstronauta() {
  if (derecha == true && izquierda == false) {
    c1.addForce(20000, 0);
  }
  if (izquierda == true && derecha == false) {
    c1.addForce(-20000, 0);
  }
  if (arriba == true && abajo == false) {
    c1.addForce(0, -20000);
  }
  if (abajo == true && arriba == false) {
    c1.addForce(0, 20000);
  }
}


void juego() {
  resetearRandom();
  tiempoDeEspera();
  obstaculo.impulsarObjetos();
  moverAstronauta();
  verColisiones();
  cuentaRegresivaDanio();
  cambiarPantalla();
  
  tiempoDeJuego();  
  
  println("punto: "+puntos+" refresh: "+refreshDanio+" "+segundos);
}

void lugarDeCara() {
  receptor.actualizar(mensajes); //  
  //receptor.dibujarBlobs(width, height);
  for (Blob b : receptor.blobs) {
    println(b.centerY);
    if (b.centerX > 0.55) {
      derecha = true;
      izquierda = false;
    } else if (b.centerX < 0.45) {
      derecha = false;
      izquierda = true;
    }
    if (b.centerY < 0.40) {
      arriba = true;
      abajo = false;
    } else if (b.centerY > 0.75) {
      arriba = false;
      abajo = true;
    }
  }
}


void resetearRandom() {
  if (randomOff == false) {    
    fx=round(random(-50000, 50000));
    fy=round(random(-50000, 50000));
    randomOff = true;
  }
}

void verColisiones() {
  ArrayList<FContact> contacts = c1.getContacts();
  for (int i = 0; i < contacts.size(); i++) {
    FContact fc = contacts.get(i);
    if (fc.contains("obstaculo")) {
      if (refreshDanio == false) {
        puntos++;
        refreshDanio = true;
      }
    }
  }
}

void cambiarPantalla(){
  if ( pantalla == 3 && puntos == puntosParaPerder){
    pantalla = 4;
    puntos = 0;
  }
}
