import themidibus.*;

MidiBus virusBus;

// C2 = 48

String noteNames = "CCDDEFFGGAAB";

// supports only #
// starts at C0 = 24
int noteToMidi(String note) {
  int sharp = note.contains("#") ? 1 : 0;
  int octave = int(note.charAt(sharp > 0 ? 2 : 1)) - 48; // -48 from ASCII
  int base = 1;
  for(int i = 0; i < noteNames.length(); i++) {
    if(note.charAt(0) == noteNames.charAt(i)) {
      base = 24 + i;
      break;
    }
  }
  //println("  " + str(base) + " " + str(octave) + " " + str(sharp));
  return base + 12*octave + sharp;
}

String midiToNote(int m) {
  char n = noteNames.charAt(m % 12);
  int octave = (m / 12) - 2;
  int sharp = 0;
  switch(m % 12) {
    case 1:
    case 3:
    case 6:
    case 8:
    case 10:
      sharp = 1;
      break;
  }
  return str(n) + (sharp > 0 ? '#' : "") + str(octave) ;
}

// minor
// 48 50 51 53 55 56 58 60
// x +2 +1 +2 +2 +1 +2 +2
int minor[] = new int[] {0, 2, 1, 2, 2, 1, 2, 2};

// major
// 48 50 52 53 55 57 59 60
// x +2 +2 +1 +2 +2 +2 +1
int major[] = new int[] {0, 2, 2, 1, 2, 2, 2, 1};

// 60 mod 12 = 48

void newGame() {
  initStoredNotes();
  expectedNotes = newNotes();
  gameInProgress = true;
}

int[] newNotes() {
  int n = int(random(0,12));
  int ns[] = new int[8];
  int sum = n;
  for(int i = 0; i <8; i++) {
    sum += minor[i];
    ns[i] = sum % 12; 
  }
  
  return ns;
}

int[] expectedNotes;
int[] storedNotes = new int[8];
int storedIndex = -1;
boolean gameInProgress = false;

void initStoredNotes() {
  storedIndex = -1;
  for(int i = 0; i < storedNotes.length; i++) {
    storedNotes[i] = -128; 
  }
}

void setup() {
  size(600,400);
  textSize(20);
  MidiBus.list();
  virusBus = new MidiBus(this, 1, 4);
  //virusBus.sendNoteOn(0, 60, 80);
  //virusBus.sendNoteOff(0, 60, 90);
  //println(str(60 % 12));
  virusBus.sendControllerChange(0, 122, 1); // virus local echo on
  noteToMidiTests();
  midiToNoteTests();
  //noLoop();
  
  newGame();
}

String curNote = "";
int squareSize = 20;

void draw() {
  background(0);
  text(midiToNote(expectedNotes[0]), 20, 20);
  
  for(int i = 0; i < storedNotes.length; i++) {
    if(storedNotes[i] % 12 == expectedNotes[i]) fill(0,255,0) ;
    else fill(255,0,0);
    rect(10 + squareSize * i,100,squareSize,squareSize);
  }
}

void noteOn(int ch, int p, int v) {
  String s = "channel " + str(ch);
  s += " ";
  s += "note " + str(p) + " " + midiToNote(p);
  s += " ";
  s += "velocity " + str(v);
 
  curNote = midiToNote(p);
  
  println(s);
  //textSize(20);
  //text(midiToNote(p), 20,20);
  
  if(gameInProgress) {
    if(p % 12 == expectedNotes[storedIndex + 1]) {
      storedIndex += 1;
      storedNotes[storedIndex] = expectedNotes[storedIndex];
      
      if(storedIndex >= storedNotes.length - 1) {
        gameInProgress = false;
        println("ALL DONE!");
      }
      
    } else {
      println("Expected " + expectedNotes[storedIndex + 1] + " but got " + p % 12);
      println("RESTART");
      initStoredNotes();
    }
  }
}

void keyPressed() {
  if(key == 's') newGame();
  if(key == 'r') { initStoredNotes(); gameInProgress = true; }
}