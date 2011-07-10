module CoreMIDI
  require 'dl/import'
  extend DL::Importable
  dlload '/System/Library/Frameworks/CoreMIDI.framework/Versions/Current/CoreMIDI'

  extern "int MIDIClientCreate(void *, void *, void *, void *)"
  extern "int MIDIClientDispose(void *)"
  extern "int MIDIGetNumberOfDestinations()"
  extern "void * MIDIGetDestination(int)"
  extern "int MIDIOutputPortCreate(void *, void *, void *)"
  extern "void * MIDIPacketListInit(void *)"
  # http://groups.google.com/group/ruby-midi/browse_thread/thread/85de6ea9373c57a4
  extern "void * MIDIPacketListAdd(void *, int, void *, int, int, void*)"
  extern "int MIDISend(void *, void *, void *)"
end
