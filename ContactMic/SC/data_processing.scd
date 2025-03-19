(
var envelope = Env([0, 0.3, 0.7, 1], [1, 3, 1].normalizeSum, [-2, 2, 2]);
~lastVal = 0;
~sensitivity = 0.5;
~sound = 0;


// Create a MIDI connection to the virtual port
MIDIClient.init;  // Initialize MIDI system
// ~midiOut = MIDIOut.newByName("IAC Driver", "Bus 1"); // OSX
~midiOut = MIDIOut.newByName("loopMIDI Port", "loopMIDI Port"); // Use the correct MIDI port name



~responder = OSCdef(\resp, {|msg,time|
	var pitch = msg[5], ccValue;

	//env = ControlSpec(0, 1, \exp, 0.001);
	//msg[3].postln;
	//~amp = env.map(msg[3]);

	~rawamp = msg[3].curvelin(0.001, 1.0, 0, 1, 3);
	~amp = msg[4].curvelin(0.001, 1.0, 0, 1.0, 3);
	//~amp.postln;

	~data.addValue( ~amp );
	~data.stlen_( 5 );
	//	~sma = ~data.shortSMA;
	~sma = ~data.movingAverage1;
	~ma = envelope[~data.movingAverage1.linlin(0,0.7, 0, 1)];
	//~ratef = (Scale.bartok.ratios.choose * 0.7);

	~data_sel.value(~ma, ~rawamp, ~sound );
	// Convert amplitude to MIDI CC value (0-127)
	ccValue = (~ma * 127).clip(0, 127).round;

	if(ccValue > 0, {
		// Send MIDI CC message (CC #1 is Modulation Wheel, change if needed)
		// Send MIDI only if the value is more than 0
		~midiOut.control(0, 1, ccValue.asInteger); // (MIDI channel 0, CC#1, value)
	});

}, '/input');
(thisProcess.nowExecutingPath.dirname ++ "/data_selection.scd").load;

//envelope.plot;
)