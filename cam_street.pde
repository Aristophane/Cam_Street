import themidibus.*; //Import the library
import peasy.*;
PeasyCam cam;
MidiBus myBus; // The MidiBus

boolean isScalingUp = false;
boolean isScalingDown = false;
boolean isLightOn = false;

int spacing = 800  ;
int numberOfLamps = 50;
int polePosition = 120;
int i = 0;
float scale = 60;
PShape sun;
ArrayList<PShape> rainList = new ArrayList<PShape>();
PShape[] lampLeftArray = new PShape[numberOfLamps];
PShape[] lampRightArray = new PShape[numberOfLamps];
PShape[] lampLightsLeftArray = new PShape[numberOfLamps];
PShape[] lampLightsRightArray = new PShape[numberOfLamps];
PShape[] dottedLine = new PShape[numberOfLamps];
PShape[] buildingsRightArray = new PShape[20];
PShape[] buildingsLeftArray = new PShape[20];

void setup() {
  size(1000, 1000, P3D);
  pixelDensity(2);
  MidiBus.list();
  myBus = new MidiBus(this, 4, 0); 
  //cam = new PeasyCam(this, 100);
  for (int i = 0; i < numberOfLamps; i++) {
    lampadaires(i);
    lampLights(i);
  }

  for (int i = 0; i <buildingsRightArray.length; i ++) {
    buildBuildings(i);
  }

  sun = createShape(ELLIPSE, 0, 0, 30, 30);
}

void draw() {
  float translation = -i*0.5;
  camera(0, -70, 0, 0, 0, -10000, 0, 1, 0);
  background(0);
  translate(0, 0, translation);
  stroke(255);
  line(-100, 0, 0, -100, 0, -10000);
  line(-100, 10, 0, -100, 10, -10000);
  line(100, 0, 0, 100, 0, -10000);
  line(100, 10, 0, 100, 10, -10000);
  /*for(int j =0; j <dottedLine.length; j ++){
   shape(dottedLine[i]);
   }*/
  stroke(255);
  fill(255);
  for (int j = 0; j  < numberOfLamps; j++) {
    shape(lampLeftArray[j]);
    shape(lampRightArray[j]);
    shape(lampLightsLeftArray[j]);
    shape(lampLightsRightArray[j]);
  }

  for (int i = 0; i <buildingsRightArray.length; i ++)
  {
    shape(buildingsRightArray[i]);
    shape(buildingsLeftArray[i]);
  }


  if (isScalingUp)
  {
    scale = scale + 2;
    scaleSun();
  } else if (isScalingDown)
  {
    scale = scale - 1;
    descaleSun();
  }

  translate(166, -280, -translation-500);
  shape(sun);
  i--;
}

void lampadaires(int i)
{
  lampLeftArray[i] = lampadaireCreator(1, i);
  lampRightArray[i] = lampadaireCreator(-1, i);
}

void lampLights(int i) {
  lampLightsRightArray[i] = lampLightsCreator(-1, i);
  lampLightsLeftArray[i] = lampLightsCreator(1, i);
}

int bLenght = 700;
int buildingHeight = 300;
int bDepth = 70;

void buildBuildings(int i)
{
  buildingsRightArray[i] = buildingCreator(1, i, int(-buildingHeight + random(120)));
  buildingsLeftArray[i] = buildingCreator(-1, i, int(-buildingHeight + random(120)));
}

PShape buildingCreator(int orientation, int buildingNumber, int bHeight)
{
  int p = -buildingNumber*bLenght-bLenght;
  PShape building = createShape(GROUP);
  PShape leftSide = createShape();
  leftSide.beginShape();
  leftSide.vertex(0, 0, p+bLenght);
  leftSide.vertex(0, bHeight, p+bLenght);
  leftSide.vertex(orientation*bDepth, bHeight, p+bLenght);
  leftSide.vertex(orientation*bDepth, 0, p+bLenght);
  leftSide.endShape(CLOSE);

  PShape topSide = createShape();
  topSide.beginShape();
  topSide.vertex(0, bHeight, p+bLenght);
  topSide.vertex(0, bHeight, p);
  topSide.vertex(orientation*bDepth, bHeight, p);
  topSide.vertex(orientation*bDepth, bHeight, p+bLenght);
  topSide.endShape(CLOSE);

  PShape frontSide = createShape();
  frontSide.beginShape();
  frontSide.vertex(0, 0, p);
  frontSide.vertex(0, 0, p+bLenght);
  frontSide.vertex(0, bHeight, p+bLenght);
  frontSide.vertex(0, bHeight, p);
  frontSide.endShape(CLOSE);

  int wSize = 15;
  int dLenght = 30;
  float dHeight = -bHeight*0.5-2*wSize;

  for (int zi = 1; zi < 4; zi++)
  {
    for (int yi = 1; yi < 4; yi++)
    {
      float centerZ = -zi*0.25*bLenght;
      float centerY = yi*0.25*bHeight;

      if (!(zi == 2 && yi == 1))
      {
        PShape window = createShape();
        window.beginShape();
        window.fill(245, 255, 0);
        window.vertex(-1*orientation, centerY+wSize, centerZ+wSize+p+bLenght);
        window.vertex(-1*orientation, centerY+wSize, centerZ-wSize+p+bLenght);
        window.vertex(-1*orientation, centerY-wSize, centerZ-wSize+p+bLenght);
        window.vertex(-1*orientation, centerY-wSize, centerZ+wSize+p+bLenght);
        window.endShape(CLOSE);
        building.addChild(window);
      } else {
        PShape door = createShape();
        door.beginShape();
        door.fill(245, 255, 0);
        door.vertex(-1*orientation, 0, dLenght+centerZ+p+bLenght);
        door.vertex(-1*orientation, 0, -dLenght+centerZ+p+bLenght);
        door.vertex(-1*orientation, -dHeight, -dLenght+centerZ+p+bLenght);
        door.vertex(-1*orientation, -dHeight, dLenght+centerZ+p+bLenght);
        door.endShape(CLOSE);
        building.addChild(door);
      }
    }
  }


  building.addChild(leftSide);
  building.addChild(topSide);
  building.addChild(frontSide);
  building.translate(orientation*240, 0);
  return building;
}

PShape lampadaireCreator(int orientation, int i)
{
  int position = -i*spacing;
  PShape lamp;
  lamp = createShape();
  lamp.beginShape();
  lamp.fill(255);
  lamp.vertex(0, 0, position);
  lamp.vertex(0, -152, position);
  lamp.vertex(orientation*28, -152, position);
  lamp.vertex(orientation*30, -150, position);
  lamp.vertex(orientation*30, -148, position);
  lamp.vertex(orientation*28, -146, position);
  lamp.vertex(orientation*5, -146, position);
  lamp.vertex(orientation*5, 0, position);
  lamp.translate(-orientation*polePosition, 0);
  lamp.endShape(CLOSE);
  return lamp;
}

PShape lampLightsCreator(int orientation, int i) {
  int position = -i*spacing;
  PShape lights = createShape(GROUP);
  PShape softLight1 = createShape();
  PShape hardLight = createShape();
  softLight1.beginShape();
  softLight1.fill(255, 90, 0);
  softLight1.noStroke();
  softLight1.vertex(orientation*16.5, -146, position);
  softLight1.vertex(orientation*(25+12), -100, position);
  softLight1.vertex(orientation*(35+12), -110, position);
  softLight1.translate(-orientation*polePosition, 0, 0);
  softLight1.endShape(CLOSE);
  hardLight.beginShape();
  hardLight.fill(255, 255, 0);
  hardLight.noStroke();
  hardLight.vertex(orientation*16.5, -146, position);
  hardLight.vertex(orientation*(8+10), -95, position);
  hardLight.vertex(orientation*(25+11), -95, position);
  hardLight.translate(-orientation*polePosition, 0, 0);
  hardLight.endShape(CLOSE);
  PShape softLight2 = createShape();
  softLight2.beginShape();
  softLight2.fill(255, 90, 0);
  softLight2.noStroke();
  softLight2.vertex(orientation*16.5, -146, position);
  softLight2.vertex(orientation*16, -100, position);
  softLight2.vertex(orientation*8, -100, position);
  softLight2.translate(-orientation*polePosition, 0, 0);
  softLight2.endShape(CLOSE);
  lights.addChild(hardLight);
  lights.addChild(softLight1);
  lights.addChild(softLight2);
  return lights;
}

void descaleSun() {
  if (scale != 30) {
    if (sun != null) {
      sun = createShape(ELLIPSE, 0, 0, scale, scale);
    }
  } else {
    sun = createShape(ELLIPSE, 0, 0, scale, scale);
    isScalingDown = false;
  }
}

void scaleSun()
{
  if (scale != 40) {
    if (sun != null) {
      sun = createShape(ELLIPSE, 0, 0, scale, scale);
    }
  } else {
    isScalingUp = false;
  }
}

void kickOn(int velocity) {
  isScalingUp = true;
  isScalingDown = false;
}

void kickOff(int velocity) {
  isScalingUp = false;
  isScalingDown = true;
}

void snareOn(int velocity) {
}

void snareOff(int velocity) {
}

void hihatOn(int velocity) {
  isLightOn = true;
}

void hihatOff(int velocity) {
  isLightOn = false;
}

void clapOn(int velocity) {
}        

void clapOff(int velocity) {
}    

void noteOn(int channel, int pitch, int velocity) {
  if (pitch == 36)
  {
    kickOn(velocity);
  } else if (pitch == 44)
  {
    snareOn(velocity);
  } else if (pitch == 48 || pitch == 50 || pitch == 40 || pitch == 42)
  {
    hihatOn(velocity);
  } else if (pitch == 45)
  {
    clapOn(velocity);
  }

  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
}

void noteOff(int channel, int pitch, int velocity) {
  if (pitch == 36)
  {
    kickOff(velocity);
  } else if (pitch == 44)
  {
    snareOff(velocity);
  } else if (pitch == 48 || pitch == 50 || pitch == 40 || pitch == 42)
  {
    hihatOff(velocity);
  } else if (pitch == 45)
  {
    clapOff(velocity);
  }

  // Receive a noteOff
  println();
  println("Note Off:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
}
