{ t = MouseX.kr(1,100);GrainIn.ar(1, Impulse.kr(t), 0/o, SinOsc.ar, mul:0.1); }.play;
TGrains
(
SynthDef(\grainIn, {arg outbus = 0, volume = 0.5, trigRate = 10,  overlap = 2, pan = 0;
	var input, output;

	input = SoundIn.ar(0);
	output = GrainIn.ar(2, Impulse.kr(trigRate), overlap/trigRate, input, pan);
	Out.ar(outbus, output * volume);
}).add;
SynthDef(\noise, {Out.ar(2, GVerb.ar(x=LFNoise0.ar(0.1!2,2.5,3.5);SplayAz.ar(2,LatoocarfianL.ar(SampleRate.ir/2+16.rand,x,x,x,x)!66,x),9+x,9*x)*0.001)}).add;
)
b = Synth.after(a, \grainIn);
b.set(\overlap, 1, \trigRate, 40);

a = Synth(\noise);

Ndef(\