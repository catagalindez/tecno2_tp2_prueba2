class Nave {
  color relleno = 200;
  PImage imgNave;
  int posX = width/2;
  int posY = height/2;

  Nave() {
    imgNave = loadImage("nave.png");
  }

  void dibujar() {
    pushStyle();
    imageMode(CENTER);
    image(imgNave, posX, posY);
    popStyle();
  }
}
