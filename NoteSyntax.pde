String noteNames = "CCDDEFFGGAAB";


// Converts "C0" to Midi Note number 24
// Converts "C2" to Midi note number 48
// Midi notes range from "C-2" (0) to "..." (127)
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


// Converts a Midi Note number (24) to it's text representation
// It only knows about # not b, so only "F#2", not "Gb2"
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