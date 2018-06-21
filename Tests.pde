void assertInt(int expected, int actual) {
  if(expected != actual) {
    println("Test FAILED! Expected: " + expected + " - Actual: " + actual);
  } else {
    println("Test OK");
  }
}

void assertString(String expected, String actual) {
  if(!expected.equals(actual)) {
    println("Test FAILED! Expected: " + expected + " - Actual: " + actual);
  } else {
    println("Test OK");
  }
}

void noteToMidiTests() {
  assertInt(24, noteToMidi("C0"));
  assertInt(33, noteToMidi("A0"));
  assertInt(45, noteToMidi("A1"));
  assertInt(48, noteToMidi("C2"));
  assertInt(46, noteToMidi("A#1"));
  assertInt(58, noteToMidi("A#2"));
}

void midiToNoteTests() {
  assertString("C0", midiToNote(24));
  assertString("A0", midiToNote(33));
  assertString("C1", midiToNote(36));
  assertString("C2", midiToNote(48));
  assertString("A#1", midiToNote(46));
  assertString("A#2", midiToNote(58));
}