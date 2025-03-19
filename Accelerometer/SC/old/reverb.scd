// reverb
//var reverb;
//reverb = Synth(\GVerb, [\outbus, 0], addAction:\addToTail);

ProxyChain.add(
	    \GVerb,  \filter -> { |in| GVerb.ar(in, 100) },
		\FreeVerb,  \filter -> { |in| FreeVerb.ar(in, 1, 0.8) }

);

m = MasterFX.new(server: s,
    numChannels: 8,
    slotNames: [ \GVerb, \FreeVerb ],
    busIndex: 0
);
m.gui;

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



