MidiIn min;
MidiMsg msg;

if ( !min.open(0) ) me.exit();

SndBuf s[50];
"drums/BOOM.aif" => s[36].read;
"drums/crikix.aif" => s[37].read;
"drums/bendy.aif" => s[39].read;
"drums/djembe-side.aif" => s[40].read;
"drums/electrotabla.aif" => s[41].read;
"drums/basic-ridebell.aif" => s[42].read;
"drums/african-pe-hi.wav" => s[43].read;
"drums/909-banging-lofi-hat.aif" => s[44].read;
"drums/707-ohh.aif" => s[45].read;

for( 0 => int i; i < s.cap(); i++)
  s[i] => dac;

while( true ) {
  min => now;

  while( min.recv( msg ) )
  {
  	<<< msg.data1, msg.data2, msg.data3 >>>;
  	if(msg.data1 >= 0x90 && msg.data1 < 0xa0) {
    	0 => s[msg.data2].pos;
    	(msg.data3 / 127.0) * 0.9 => s[msg.data2].gain;
    	(msg.data3 / 127.0) * 0.2 + 0.9 => s[msg.data2].rate;
  	}
  }
}
