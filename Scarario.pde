import themidibus.*;

MidiBus virusBus;

void setup() {
  MidiBus.list();
  virusBus = new MidiBus(this, 1, 4);
  //virusBus.sendNoteOn(0, 60, 80);
  //virusBus.sendNoteOff(0, 60, 90);
  //println(str(60 % 12));
  noteToMidiTests();
  midiToNoteTests();
}

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

// major
// 48 50 52 53 55 57 59 60
// x +2 +2 +1 +2 +2 +2 +1

// 60 mod 12 = 48

void draw() {
  
}

void noteOn(int ch, int p, int v) {
  String s = "channel " + str(ch);
  s += " ";
  s += "note " + str(p) + " " + midiToNote(p);
  s += " ";
  s += "velocity " + str(v);
  
  println(s);
  text(s, 10,10);
}