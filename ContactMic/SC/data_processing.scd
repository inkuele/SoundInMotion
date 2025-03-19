(
var envelope = Env([0, 0.3, 0.7, 1], [1, 3, 1].normalizeSum, [-2, 2, 2]);
~lastVal = 0;
~sensitivity = 0.5;
	~sound = 0;


// Create a MIDI connection to the virtual port
MIDIClient.init;  // Initialize MIDI system
~midiOut = MIDIOut.newByName("IAC Driver", "Bus 1"); // Use the correct MIDI port name



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
	~sma = ~data.expMA;
	~expMa = envelope[~data.expMA.linlin(0,0.7, 0, 1)];
			//~ratef = (Scale.bartok.ratios.choose * 0.7);

	~data_sel.value(~expMa, ~rawamp, ~sound );
	    // Convert amplitude to MIDI CC value (0-127)
    ccValue = (~expMa * 127).clip(0, 127).round;

    // Send MIDI CC message (CC #1 is Modulation Wheel, change if needed)
    ~midiOut.control(0, 1, ccValue); // (MIDI channel 0, CC#1, value)


}, '/input');
(thisProcess.nowExecutingPath.dirname ++ "/data_selection.scd").load;

//envelope.plot;
)