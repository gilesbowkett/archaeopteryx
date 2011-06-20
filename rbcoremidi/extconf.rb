require 'mkmf'
$CPPFLAGS += " -I/Developer/SDKs/MacOSX10.5.sdk/System/Library/Frameworks/CoreMIDI.framework/Headers"
$LDFLAGS += " -framework CoreMIDI"
create_makefile('rbcoremidi')
