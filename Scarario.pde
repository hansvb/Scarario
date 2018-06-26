import themidibus.*;

MidiBus virusBus;



// .. "MAIN MENU" ..
void keyPressed() {
  if(key == 's') newGame();
  if(key == 'r') { initStoredNotes(); gameInProgress = true; }
}


// .. SCALES ..

// 48..60 = C2..C3
// 60 % 12 = 48

// minor
// 48 50 51 53 55 56 58 60
//  0 +2 +1 +2 +2 +1 +2 +2
int minor[] = new int[] {0, 2, 1, 2, 2, 1, 2, 2};

// major
// 48 50 52 53 55 57 59 60
//  0 +2 +2 +1 +2 +2 +2 +1
int major[] = new int[] {0, 2, 2, 1, 2, 2, 2, 1};



// use `scale` to generate new notes to be used by the state-variables
int[] newNotes(int[] scale) {
  int n = int(random(0,12)); // 12 notes
  int ns[] = new int[8]; // 8-note scale
  int a = n; // accumulator helper variable
  
  // using minor notes
  for(int i = 0; i < 8; i++) {
    a += scale[i];
    ns[i] = a % 12; 
  }
  
  return ns;
}


// .. STATE VARIABLES (Model) ..

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

void newGame() {
  initStoredNotes();
  expectedNotes = newNotes(minor);
  gameInProgress = true;
}


void setup() {
  size(600,400);
  textSize(20);
  
  println(midiToNote(48));
  println(midiToNote(60));
  
  MidiBus.list();
  virusBus = new MidiBus(this, 1, 4);
  //virusBus.sendNoteOn(0, 60, 80);
  //virusBus.sendNoteOff(0, 60, 90);
  //println(str(60 % 12));
  virusBus.sendControllerChange(0, 122, 1); // virus local echo on
  
  NoteSyntax_noteToMidiTests();
  NoteSyntax_midiToNoteTests();
  
  newGame();
}


// .. EVENT HANDLER ..

// Should update state variables and preferably not modify UI
// Change UI-variables (ViewModel) only. Don't update UI directly.  
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


// .. UI ..

// ..constants
final int squareSize = 20;

// ..ui-variables (ViewModel)
String curNote = "";

// ..ui-loop (uses both Model- and ViewModel-variables)
void draw() {
  background(0);
  text(midiToNote(expectedNotes[0]), 20, 20);
  
  for(int i = 0; i < storedNotes.length; i++) {
    if(storedNotes[i] % 12 == expectedNotes[i]) fill(0,255,0) ;
    else fill(255,0,0);
    rect(10 + squareSize * i,100,squareSize,squareSize);
  }
}