
/********

 ASDF Pixel Sort
 Kim Asendorf | 2010 | kimasendorf.com
 
 Sorting modes
 0 = white
 1 = black
 2 = bright
 3 = dark
 
 */

int mode = 0;

// image path is relative to sketch directory
PImage img;
String imgFileName = "mountains";
String fileType = "jpg";

int loops = 1;

// threshold values to determine sorting start and end pixels
// using the absolute rgb value
// r*g*b = 255*255*255 = 16581375
// 0 = white
// -16581375 = black
// sort all pixels whiter than the threshold
int whiteValue = -12345678;
// sort all pixels blacker than the threshold
int blackValue = -3456789;
// using the brightness value
// sort all pixels brighter than the threshold
int brightValue = 127;
// sort all pixels darker than the threshold
int darkValue = 223;


int row = 0;
int column = 0;

boolean saved = false;

void setup() {
  img = loadImage(imgFileName + "." + fileType);
  
  // use only numbers (not variables) for the size() command, Processing 3
  size(1, 1);
  
  // allow resize and update surface to image dimensions
  surface.setResizable(true);
  surface.setSize(img.width, img.height);
  
  // load image onto surface - scale to the available width,height for display
  image(img, 0, 0, width, height);
}


void draw() {
  
  if (frameCount <= loops) {
    
    // loop through columns
    println("Sorting Columns");
    while (column < img.width-1) {
      img.loadPixels();
      sortColumn();
      column++;
      img.updatePixels();
    }
    
    // loop through rows
    println("Sorting Rows");
    while (row < img.height-1) {
      img.loadPixels();
      sortRow();
      row++;
      img.updatePixels();
    }
  }
  
  // load updated image onto surface and scale to fit the display width and height
  image(img, 0, 0, width, height);
    
  if (!saved && frameCount >= loops) {
    // save img
    img.save(imgFileName + "_" + mode + ".png");
  
    saved = true;
    println("Saved frame " + frameCount);
    
    // exiting here can interrupt file save, wait for user to trigger exit
    println("Click or press any key to exit...");
  }
}

void keyPressed() {
  if (saved) {
    System.exit(0);
  }
}

void mouseClicked() {
  if (saved) {
    System.exit(0);
  }
}

void sortRow() {
  // current row
  int y = row;
  
  // where to start sorting
  int x = 0;
  
  // where to stop sorting
  int xEnd = 0;
  
  while (xEnd < img.width-1) {
    switch (mode) {
      case 0:
        x = getFirstNoneWhiteX(x, y);
        xEnd = getNextWhiteX(x, y);
        break;
      case 1:
        x = getFirstNoneBlackX(x, y);
        xEnd = getNextBlackX(x, y);
        break;
      case 2:
        x = getFirstNoneBrightX(x, y);
        xEnd = getNextBrightX(x, y);
        break;
      case 3:
        x = getFirstNoneDarkX(x, y);
        xEnd = getNextDarkX(x, y);
        break;
      default:
        break;
    }
    
    if (x < 0) break;
    
    int sortingLength = xEnd-x;
    
    color[] unsorted = new color[sortingLength];
    color[] sorted = new color[sortingLength];
    
    for (int i = 0; i < sortingLength; i++) {
      unsorted[i] = img.pixels[x + i + y * img.width];
    }
    
    sorted = sort(unsorted);
    
    for (int i = 0; i < sortingLength; i++) {
      img.pixels[x + i + y * img.width] = sorted[i];      
    }
    
    x = xEnd+1;
  }
}


void sortColumn() {
  // current column
  int x = column;
  
  // where to start sorting
  int y = 0;
  
  // where to stop sorting
  int yEnd = 0;
  
  while (yEnd < img.height-1) {
    switch (mode) {
      case 0:
        y = getFirstNoneWhiteY(x, y);
        yEnd = getNextWhiteY(x, y);
        break;
      case 1:
        y = getFirstNoneBlackY(x, y);
        yEnd = getNextBlackY(x, y);
        break;
      case 2:
        y = getFirstNoneBrightY(x, y);
        yEnd = getNextBrightY(x, y);
        break;
      case 3:
        y = getFirstNoneDarkY(x, y);
        yEnd = getNextDarkY(x, y);
        break;
      default:
        break;
    }
    
    if (y < 0) break;
    
    int sortingLength = yEnd-y;
    
    color[] unsorted = new color[sortingLength];
    color[] sorted = new color[sortingLength];
    
    for (int i = 0; i < sortingLength; i++) {
      unsorted[i] = img.pixels[x + (y+i) * img.width];
    }
    
    sorted = sort(unsorted);
    
    for (int i = 0; i < sortingLength; i++) {
      img.pixels[x + (y+i) * img.width] = sorted[i];
    }
    
    y = yEnd+1;
  }
}


// white x
int getFirstNoneWhiteX(int x, int y) {
  while (img.pixels[x + y * img.width] < whiteValue) {
    x++;
    if (x >= img.width) return -1;
  }
  return x;
}

int getNextWhiteX(int x, int y) {
  x++;
  while (img.pixels[x + y * img.width] > whiteValue) {
    x++;
    if (x >= img.width) return img.width-1;
  }
  return x-1;
}

// black x
int getFirstNoneBlackX(int x, int y) {
  while (img.pixels[x + y * img.width] > blackValue) {
    x++;
    if (x >= img.width) return -1;
  }
  return x;
}

int getNextBlackX(int x, int y) {
  x++;
  while (img.pixels[x + y * img.width] < blackValue) {
    x++;
    if (x >= img.width) return img.width-1;
  }
  return x-1;
}

// bright x
int getFirstNoneBrightX(int x, int y) {
  while (brightness(img.pixels[x + y * img.width]) < brightValue) {
    x++;
    if (x >= img.width) return -1;
  }
  return x;
}

int getNextBrightX(int x, int y) {
  x++;
  while (brightness(img.pixels[x + y * img.width]) > brightValue) {
    x++;
    if (x >= img.width) return img.width-1;
  }
  return x-1;
}

// dark x
int getFirstNoneDarkX(int x, int y) {
  while (brightness(img.pixels[x + y * img.width]) > darkValue) {
    x++;
    if (x >= img.width) return -1;
  }
  return x;
}

int getNextDarkX(int x, int y) {
  x++;
  while (brightness(img.pixels[x + y * img.width]) < darkValue) {
    x++;
    if (x >= img.width) return img.width-1;
  }
  return x-1;
}

// white y
int getFirstNoneWhiteY(int x, int y) {
  if (y < img.height) {
    while (img.pixels[x + y * img.width] < whiteValue) {
      y++;
      if (y >= img.height) return -1;
    }
  }
  return y;
}

int getNextWhiteY(int x, int y) {
  y++;
  if (y < img.height) {
    while (img.pixels[x + y * img.width] > whiteValue) {
      y++;
      if (y >= img.height) return img.height-1;
    }
  }
  return y-1;
}


// black y
int getFirstNoneBlackY(int x, int y) {
  if (y < img.height) {
    while (img.pixels[x + y * img.width] > blackValue) {
      y++;
      if (y >= img.height) return -1;
    }
  }
  return y;
}

int getNextBlackY(int x, int y) {
  y++;
  if (y < img.height) {
    while (img.pixels[x + y * img.width] < blackValue) {
      y++;
      if (y >= img.height) return img.height-1;
    }
  }
  return y-1;
}

// bright y
int getFirstNoneBrightY(int x, int y) {
  if (y < img.height) {
    while (brightness(img.pixels[x + y * img.width]) < brightValue) {
      y++;
      if (y >= img.height) return -1;
    }
  }
  return y;
}

int getNextBrightY(int x, int y) {
  y++;
  if (y < img.height) {
    while (brightness(img.pixels[x + y * img.width]) > brightValue) {
      y++;
      if (y >= img.height) return img.height-1;
    }
  }
  return y-1;
}

// dark y
int getFirstNoneDarkY(int x, int y) {
  if (y < img.height) {
    while (brightness(img.pixels[x + y * img.width]) > darkValue) {
      y++;
      if (y >= img.height) return -1;
    }
  }
  return y;
}

int getNextDarkY(int x, int y) {
  y++;
  if (y < img.height) {
    while (brightness(img.pixels[x + y * img.width]) < darkValue) {
      y++;
      if (y >= img.height) return img.height-1;
    }
  }
  return y-1;
}
