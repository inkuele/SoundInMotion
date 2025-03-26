// reverb
//var reverb;
//reverb = Synth(\GVerb, [\outbus, 0], addAction:\addToTail);
(
// Define effect chain with reverb and companding
Ndef(\effect, {
	|in , thresh = 0.1, slopeBelow = 1.0, slopeAbove = 0.5, clampTime = 0.01, relaxTime = 0.3|
	var output, audioInput = In.ar(in); // Input signal at audio-rate

	// Apply compander for dynamic control
	output = Compander.ar(
		audioInput,
		audioInput,
		thresh,
		slopeBelow,
		slopeAbove,
		clampTime,
		relaxTime
	);

	// Reverb effect for spaciousness
	output =  GVerb.ar(output) * 0.5;

	// Limiting to control final peaks
	output = Limiter.ar(output, 0.9);
}).play;


// Routing all Ndefs to the effect chain
Ndef(\effect) << [
	Ndef(\freq_wander), Ndef(\complexB), Ndef(\complexB)];
)

/*
(

SynthDef(\impulse, {

	Out.ar(0,Pan2.ar(Saw.ar(440,Decay2.ar(Impulse.ar(1),0.001,0.1,0.5)),0.0) * EnvGen.ar(Env.perc, doneAction:2));

}).add;

)

a = Group.basicNew(s,1);
x = Synth.head(a, \impulse);


x.free;

x = Synth.head(a, \impulse);

y= Synth.tail(a, \GVerb);
*/



