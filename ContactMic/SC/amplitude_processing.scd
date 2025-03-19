Ndef(\receiveAmp, {|input = 0, gain = 1, attack = 0.01, release = 0.1|
	var in, output, smoothed, pitch, amp, rawamp;
	in = SoundIn.ar(input, gain);
	in = LeakDC.ar(in);
	    smoothed = HPF.ar(in, 20);  // Highpass to remove DC offset
	// smoothed = RunningSum.ar(smoothed, SampleRate.ir, 120);  // Running sum over 1 second

	rawamp = Amplitude.kr(smoothed, attack, release).explin(0.0018, 0.9, 0, 1);
	amp = Lag2UD.kr(rawamp, 0, 1);
	pitch = Pitch.kr(in)[0];
	SendReply.kr(Impulse.kr(SampleRate.ir/1200), '/input', [rawamp, amp,pitch]);

}).play;