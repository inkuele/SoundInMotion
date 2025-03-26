(
/*
SynthDef(\GVerb, {|outbus, mix = 0.06, room = 0.2, damp = 0.5, amp = 1.0|
var signal;
signal = In.ar(outbus, 2);
	signal = GVerb.ar(signal, 100, 3);
	signal = LeakDC.ar(signal);
ReplaceOut.ar(outbus, signal);
}).add;
*/
SynthDef(\strangaS, {arg speed = 1, volume = 0, volume2 = 1, pitch =0.5, pitch_fine =0.5, pitch_dev = 0.0003, decay_time = 4, roomsize = 100, revtime = 3, trigger = 1, pan = 0, gate = 1;
    var num_voices = 8, output, reverbed;
	//pitch = MouseY.kr;
	speed = MouseX.kr(0, 10);
	//decay_time = MouseY.kr(6, 1);
	//pitch_dev = GrayNoise.kr(0.01).range(0.001, 0.009).poll;
//PinkNoise.ar(Decay.kr((trigger + Impulse.kr(speed, 0, 10) + Trig.kr(sensitive, 0.05)), 0.05 * decay_scale)) * volume * volume2;
	output = CombC.ar( PinkNoise.ar(Decay2.kr(Trig.kr(trigger, 0.01), 0.01, 0.1, 0.1).dup(num_voices)),  0.1, {((
		gauss(0.002, pitch_dev.linlin(0, 1, 0.0001, 0.0005)).abs
		//0.004.rand
		+ pitch_fine.linlin(0, 1, 0.0009,0.0001).lag(0.4)) * pitch.linlin(0, 1, 5, 0.5)) }.dup(num_voices), decay_time) ;
	output = RLPF.ar(output, pitch.linlin(0, 1, 300, 3000 ), 0.3, 1);

	output = Pan2.ar(output, {1.0.rand2}.dup(num_voices));
	//output = Impulse.ar([3,4]);
	output = Mix.ar(output);

	output = output * Lag3UD.kr(volume * volume2, 0, 0.1)  * EnvGen.ar(Env.perc(0.02, 3), gate, doneAction:2);


	output = LeakDC.ar(output);

	output = Mix.ar(output);

	output = Pan2.ar(output, pan);
	output = LeakDC.ar(output);

	Out.ar(0, output  * 0.25);
}).add;

SynthDef(\freq_wanderS, { arg out=0, lo=70, hi=80, step=1, rate=10, volume=0, volume2 = 1, pan=0, lgate = 1, scale_val = 1, scale_tones = 1, deviation = 1, bwr = 0.2, gate = 1;
	var output, freq, num_comb, num_tones, freq_list, bpassFreq;
	num_comb = 2;
	num_tones = num_comb*2;
	//deviation = MouseX.kr(1, 150);step = MouseX.kr(0.01, 10);
//	freq = Demand.ar(Impulse.ar(rate), 0,Dbrown(lo, hi, step) ).midicps.poll * scale_val;
	freq = rrand(lo, hi).midicps* scale_val;
//	freq = Demand.ar(Impulse.ar(rate), 0, SinOsc.ar(0.02).range(lo, hi)).midicps * scale_val;

	output = RLPF.ar(
		//Mix.new(VarSaw.ar((freq + [0, -0.2, 0.2, 0.4, -0.4]).poll, 0, 0.8, 0.1)),
		Mix.new(VarSaw.ar((freq  + Array.fill(num_tones, {gauss(0.0, 0.5) * deviation})), 0, 0.8, 0.1)), LFNoise2.ar(0.5).range((freq * 0.634423), (freq* 0.834232)), 0.5, 0.5
	);

	output = Mix.ar(Array.fill(num_comb,{ CombN.ar(output, 0.02, rrand(0.001, 0.02), 0.5, 1/num_comb) })) * 0.2 * volume * volume2 * EnvGen.ar(Env.perc(0.02, 2, curve:-14), gate, doneAction:Done.freeSelf);
//	bpassFreq = freq * 0.45232423;

//	output = Resonz.ar(output, bpassFreq, bwr, 6);

	output = LeakDC.ar(output);
//	output = GVerb.ar(output, 200, 3):
//	output = FreeVerb.ar(output, 0.5, 0.5) * 1.5;
	output = Mix.new(output);

	Out.ar(out, Limiter.ar(Pan2.ar(output, pan, 1), 0.9));
}).add;
)

