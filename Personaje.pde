class Astronauta {
  PImage astronaut;
  float x, y, diam;

  Astronauta (float x, float y, float diam) {
    this.x = x;
    this.y = y;
    this.diam = diam;
    astronaut = loadImage ("astronaut2.png");
  }

  void crearPJ() {
    dibujarAstronauta();
  }

  void dibujarAstronauta() {
    c1 = crearEsfera(x, y, diam, color(255, 0, 0));

    c1.setDamping(1);
    astronaut.resize (100, 120);
    c1.attachImage(astronaut);
    c1.setRotatable(false);

    world.add(c1);
  }

  
}
