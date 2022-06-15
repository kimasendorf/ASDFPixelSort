/* ASDF Pixel Sort
 Kim Asendorf | 2010 | kimasendorf.com
 
 sorting modes
 0 = black
 1 = brightness
 2 = white
 */

import controlP5.*;
ControlP5 cp5;

Toggle sortOrientationToggle;
boolean horizontallySorted;
Slider sortIntensitySlider;
int sort_intensity = -10000000;
RadioButton styleRadioButton;
int randomSortIntensity;
int randomSortOrientation;

int mode = 0;

PImage img;
PImage unsortedImage;
PImage savingImage;

String filePath = "";

int loops = 1;

int blackValue = sort_intensity;
int brightnessValue = sort_intensity;
int whiteValue = sort_intensity;

int row = 0;
int column = 0;

void setup() {
  unsortedImage = img = loadImage("asdfPixelSortOpening.jpg");
  // use only numbers (not variables) for the size() command, Processing 3
  size(1, 1);

  PFont verdanaFont = createFont("Verdana", 11); 
  ControlFont font = new ControlFont(verdanaFont);

  // allow resize and update surface to image dimensions
  surface.setResizable(true);
  surface.setSize(img.width, img.height);

  // load image onto surface - scale to the available width,height for display
  image(img, 0, 0, width, height);

  cp5 = new ControlP5(this); 
  cp5.setFont(font);
  cp5.addButton("choose_image")
    .setPosition(10, 10)
    .setSize(100, 30)
    .setLabel("choose image"); 
    
  styleRadioButton = cp5.addRadioButton("style")
    .setPosition(10, 50)
    .setSize(40, 20)
    .setSpacingRow(5)
    .addItem("black", 0)
    .addItem("brightness", 1)
    .addItem("white", 2)
    .activate("black");    

  sortOrientationToggle = cp5.addToggle("sort_orientation")
    .setPosition(10, 130)
    .setSize(60, 25)
    .setMode(ControlP5.SWITCH)
    .setLabel("orientation");     

  sortIntensitySlider = cp5.addSlider("sort_intensity")
    .setLabel("")
    .setSize(100, 30)
    .setPosition(10, 180)
    .setRange(-4000000, -16700000)
    .setValue(-10000000);
    
  cp5.addTextlabel("label","SORT INTENSITY",7,213); 

  cp5.addButton("random_sort")
    .setPosition(10, 235)
    .setSize(100, 30)
    .setLabel("random sort");
    
  cp5.addButton("save_image")
    .setPosition(10, 275)
    .setSize(90, 30)
    .setLabel("save image");    
}
void draw() {
  image(img, 0, 0, width, height);
}

void resetImage() {
  if (filePath == "") {
    img = unsortedImage;
  } else {
    img = loadImage(filePath);
  }
  loops = 1;
  blackValue = sort_intensity;
  brightnessValue = sort_intensity;
  whiteValue = sort_intensity;
  row = 0;
  column = 0;
  surface.setSize(img.width, img.height);
  image(img, 0, 0, width, height);
}

public void choose_image() {
  selectInput("Choose an image", "inputFile");
}
void inputFile(File selected) {
  filePath = selected.getAbsolutePath();
  unsortedImage = loadImage(filePath);
  img = unsortedImage;
  //reset variables
  loops = 1;
  blackValue = sort_intensity;
  brightnessValue = sort_intensity;
  whiteValue = sort_intensity;
  row = 0;
  column = 0;
  //
  surface.setSize(img.width, img.height);
  image(img, 0, 0, width, height);
  verticalSort();
  //  sortOrientationToggle.setValue(false);
} 

void style(int a) {
  resetImage();
  mode = a;
  setSliderValues(mode);
  if (sortOrientationToggle.getBooleanValue()) {
    horizontalSort();
  } else {
    verticalSort();
  }
}

void sort_orientation(boolean horizontallySorted) {
  resetImage();
  if (horizontallySorted==true) {
    horizontalSort();
  } else {
    verticalSort();
  }
}

void controlEvent(ControlEvent theEvent) { 
  if (theEvent.isController()) {
    if (theEvent.getController().getName()=="sort_intensity") {
      resetImage();
      if (sortOrientationToggle.getBooleanValue()) {
        horizontalSort();
      } else {
        verticalSort();
      }
    }
  }
}

void random_sort() {
  mode = int(random(0, 3));
  if (mode==0) {
    randomSortIntensity = int(random(-16700000, -4000000));
    styleRadioButton.activate("black");
  }
  if (mode==1) {
    randomSortIntensity = int(random(0, 200));
    styleRadioButton.activate("brightness");
  }
  if (mode==2) {
    randomSortIntensity = int(random(-8000000, -1));
    styleRadioButton.activate("white");
  }
  sort_intensity = randomSortIntensity;
  resetImage();
  setSliderValues(mode);
  randomSortOrientation = int(random(2));
  if (randomSortOrientation==0) {
    sortOrientationToggle.setValue(false);
    horizontalSort();
  } else {
    sortOrientationToggle.setValue(true);
    verticalSort();
  }
}

void setSliderValues(int mode) {
  if (mode==0) {
    sortIntensitySlider.setRange(-4000000, -16700000);
    sortIntensitySlider.setValue(int(random(-16700000, -4000000)));
  }
  if (mode==1) {
    sortIntensitySlider.setRange(200, 0);
    sortIntensitySlider.setValue(int(random(0, 200)));
  }
  if (mode==2) {
    sortIntensitySlider.setRange(-8000000, -1);
    sortIntensitySlider.setValue(int(random(-8000000, -1)));
  }
}

void save_image() {
  savingImage = get(0, 0, img.width, img.height);
  selectOutput("Select a file to write to:", "fileSelected");
}
void fileSelected(File selection) { 
  savingImage.save(selection.getAbsolutePath()+"."+month()+day()+hour()+minute()+second()+".jpg");
} 


//below is original ASDF Pixel Sort Algorithm
void horizontalSort() {
  // loop through columns
  while (column < img.width-1) {
    img.loadPixels(); 
    sortColumn();
    column++;
    img.updatePixels();
  }
  // loop through rows
  while (row < img.height-1) {
    img.loadPixels(); 
    sortRow();
    row++;
    img.updatePixels();
  }
} 

void verticalSort() {
  while (row < img.height-1) {
    img.loadPixels(); 
    sortRow();
    row++;
    img.updatePixels();
  } 
  while (column < img.width-1) {
    img.loadPixels(); 
    sortColumn();
    column++;
    img.updatePixels();
  }
}

void sortRow() {
  // current row
  int y = row;

  // where to start sorting
  int x = 0;

  // where to stop sorting
  int xend = 0;

  while (xend < img.width-1) {
    switch(mode) {
    case 0:
      x = getFirstNotBlackX(x, y);
      xend = getNextBlackX(x, y);
      break;
    case 1:
      x = getFirstBrightX(x, y);
      xend = getNextDarkX(x, y);
      break;
    case 2:
      x = getFirstNotWhiteX(x, y);
      xend = getNextWhiteX(x, y);
      break;
    default:
      break;
    }

    if (x < 0) break;

    int sortLength = xend-x;

    color[] unsorted = new color[sortLength];
    color[] sorted = new color[sortLength];

    for (int i=0; i<sortLength; i++) {
      unsorted[i] = img.pixels[x + i + y * img.width];
    }

    sorted = sort(unsorted);

    for (int i=0; i<sortLength; i++) {
      img.pixels[x + i + y * img.width] = sorted[i];
    }

    x = xend+1;
  }
}

void sortColumn() {
  // current column
  int x = column;

  // where to start sorting
  int y = 0;

  // where to stop sorting
  int yend = 0;

  while (yend < img.height-1) {
    switch(mode) {
    case 0:
      y = getFirstNotBlackY(x, y);
      yend = getNextBlackY(x, y);
      break;
    case 1:
      y = getFirstBrightY(x, y);
      yend = getNextDarkY(x, y);
      break;
    case 2:
      y = getFirstNotWhiteY(x, y);
      yend = getNextWhiteY(x, y);
      break;
    default:
      break;
    }

    if (y < 0) break;

    int sortLength = yend-y;

    color[] unsorted = new color[sortLength];
    color[] sorted = new color[sortLength];

    for (int i=0; i<sortLength; i++) {
      unsorted[i] = img.pixels[x + (y+i) * img.width];
    }

    sorted = sort(unsorted);

    for (int i=0; i<sortLength; i++) {
      img.pixels[x + (y+i) * img.width] = sorted[i];
    }

    y = yend+1;
  }
}


// black x
int getFirstNotBlackX(int x, int y) {

  while (img.pixels[x + y * img.width] < blackValue) {
    x++;
    if (x >= img.width) 
      return -1;
  }

  return x;
}

int getNextBlackX(int x, int y) {
  x++;

  while (img.pixels[x + y * img.width] > blackValue) {
    x++;
    if (x >= img.width) 
      return img.width-1;
  }

  return x-1;
}

// brightness x
int getFirstBrightX(int x, int y) {

  while (brightness(img.pixels[x + y * img.width]) < brightnessValue) {
    x++;
    if (x >= img.width)
      return -1;
  }

  return x;
}

int getNextDarkX(int _x, int _y) {
  int x = _x+1;
  int y = _y;

  while (brightness(img.pixels[x + y * img.width]) > brightnessValue) {
    x++;
    if (x >= img.width) return img.width-1;
  }
  return x-1;
}

// white x
int getFirstNotWhiteX(int x, int y) {

  while (img.pixels[x + y * img.width] > whiteValue) {
    x++;
    if (x >= img.width) 
      return -1;
  }
  return x;
}

int getNextWhiteX(int x, int y) {
  x++;

  while (img.pixels[x + y * img.width] < whiteValue) {
    x++;
    if (x >= img.width) 
      return img.width-1;
  }
  return x-1;
}


// black y
int getFirstNotBlackY(int x, int y) {

  if (y < img.height) {
    while (img.pixels[x + y * img.width] < blackValue) {
      y++;
      if (y >= img.height)
        return -1;
    }
  }

  return y;
}

int getNextBlackY(int x, int y) {
  y++;

  if (y < img.height) {
    while (img.pixels[x + y * img.width] > blackValue) {
      y++;
      if (y >= img.height)
        return img.height-1;
    }
  }

  return y-1;
}

// brightness y
int getFirstBrightY(int x, int y) {

  if (y < img.height) {
    while (brightness(img.pixels[x + y * img.width]) < brightnessValue) {
      y++;
      if (y >= img.height)
        return -1;
    }
  }

  return y;
}

int getNextDarkY(int x, int y) {
  y++;

  if (y < img.height) {
    while (brightness(img.pixels[x + y * img.width]) > brightnessValue) {
      y++;
      if (y >= img.height)
        return img.height-1;
    }
  }
  return y-1;
}

// white y
int getFirstNotWhiteY(int x, int y) {

  if (y < img.height) {
    while (img.pixels[x + y * img.width] > whiteValue) {
      y++;
      if (y >= img.height)
        return -1;
    }
  }

  return y;
}

int getNextWhiteY(int x, int y) {
  y++;

  if (y < img.height) {
    while (img.pixels[x + y * img.width] < whiteValue) {
      y++;
      if (y >= img.height) 
        return img.height-1;
    }
  }

  return y-1;
}
