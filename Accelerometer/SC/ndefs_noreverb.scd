
(
var wave, buf;
wave = Wavetable.chebyFill(512, [1]);
buf = Buffer.alloc(s, 1024, 1);
buf.sendCollection(wave.asWavetableNoWrap);

Ndef(\complexB, {arg volume = 0, volume2 = 1,speed = 1.5 , speed2 = 0, hpfFreq = 10, lpfFreq = 20000, which = 0, filter = 0, decay_bass = 1, distortion = 0, freqBmul = 1, delaytime = 0.1, decaytime = 0.1, mulDelay = 0;


var ctrigs, ctrigsB, freq, freqW, freqB, clicks, output, waves, bass, chain;
ctrigs =
{
TDuty.ar
(

					Dxrand(((1/2!4) ++ (1/8!8) ++ (1/4!8) ++ [Dseq([1/16, 1/16], Drand([1, 2, 4], inf))] ++ [Dseq([1/32, 1/32], Drand([1, 2], inf))]  ) * (speed + speed2), inf), //see above logic
0,
Dwhite(0.5, 1, inf) //trigger values are between 0.5, 1
)
}!2;

freqB = 52.8 ;
ctrigsB = 	(ctrigs[0]  ).abs;

 bass =
	( SinOsc.ar([freqB, freqB*2.01, freqB*5] * 1, 0, [1, 1, 0.05] * 0.5).mean.tanh + FBSineC.ar(freqB*20, mul:0.05)!2 )  *
EnvGen.ar(Env([0, 0.5, 0.2, 0], [0.01, 0.13 * decay_bass, 0.1* decay_bass], -4), ctrigsB )!2;

	bass = bass + ( SinOsc.ar(freqB*1, 0, 0.1) * EnvGen.ar(Env.perc(0.01, 0.1 ), ctrigsB)!2 );
	bass = HPF.ar(bass, 20);
	bass = MidEQ.ar(bass, freqB * 2, 1, 6) * 0.5;

	f = Dwhite(500, 300) * freqBmul;
	freqW = Demand.ar(ctrigs, 0, f);

	waves = SinOsc.ar(([freqW, (freqW*{rand(0.9,1.1)})]), 0, Decay.ar(ctrigs, (0.05 * LFNoise1.ar(2).abs * decay_bass)));

	waves = Shaper.ar(buf.bufnum, waves, 0.5);

	waves = BPF.ar(waves, freqW*2, 0.1, 4);

	freq = Demand.ar(ctrigs, 0, Dwhite(8000, 12000));
clicks =
BPF.ar
(
		SinOsc.ar(1000 * freqBmul, 0, Decay.ar(ctrigs, 0.05 * LFNoise1.ar(2).abs * decay_bass)), //decay time is modulated
		freq,
		0.2,
 (50 * LFNoise1.ar(2).range(0, 1)) //extreme amplification of glitches.
	).fold(-0.5, 0.5) * 0.3;

	output = (bass + waves + clicks) * 0.25;

	output = RLPF.ar(output, lpfFreq, 0.7);
	output = RHPF.ar(output, hpfFreq.lag(0.1), 0.7);
	output = MidEQ.ar(output, 2000, 0.7, 6) * volume * volume2;

	output = LeakDC.ar(output);
		output = Mix.new(output);

}).play;

Ndef(\freq_wander, { arg lo=70, hi=80, step=1, rate=10, volume=0, volume2 = 1, pan=0, lgate = 1, scale_val = 0.5339359416674, scale_tones = 1, deviation = 1, freq_scale = 1, bwr = 0.2, lowPass_scale = 1;
	var output, freq, num_comb, num_tones, freq_list, bpassFreq;
	num_comb = 6;
	num_tones = num_comb * 2;
	//deviation = MouseX.kr(1, 150);step = MouseX.kr(0.01, 10);
	freq = Demand.ar(Impulse.ar(rate), 0,
//		Dbrown(lo, hi)
		Dbrown(lo, hi, step)
	).midicps * scale_val;
	bpassFreq = freq * 0.45232423;
//	freq = Demand.ar(Impulse.ar(rate), 0, SinOsc.ar(0.02).range(lo, hi)).midicps * scale_val;

	output = LPF.ar(
		//Mix.new(VarSaw.ar((freq + [0, -0.2, 0.2, 0.4, -0.4]).poll, 0, 0.8, 0.1)),
		Mix.new(VarSaw.ar(((freq  + Array.fill(num_tones, {gauss(0.0, 0.5) * deviation}))) * freq_scale, 0, 0.8, Array.fill(num_tones, {rrand(0.01, 0.1)}) )), LFNoise2.ar(0.5).range((freq * 0.634423), (freq* 1.45)) * lowPass_scale, 0.5
	);

	output = Mix.ar(Array.fill(num_comb,{ CombN.ar(output, 0.02, rrand(0.001, 0.02), 0.5, 1/num_comb) })) * 0.75 * Lag3UD.kr(volume * volume2, 0, 0.5 );
//	output = Resonz.ar(output, bpassFreq, bwr, 10);
	//output = LPF.ar(output, 1000);
	output = LeakDC.ar(output);
//	output = GVerb.ar(output, 200, 3):
//	output = FreeVerb.ar(output, 0.5, 0.5) * 1.5;
	// output = Mix.new(output);

    output = LeakDC.ar(output);

    // Stereo output
    output = Splay.ar(output, 1);  // Distributes across stereo channels

}).play;


Ndef(\stranga, {arg speed = 0, volume = 0, volume2 = 1, pitch =0.8, pitch_fine =0.5, pitch_dev = 1, decay_time = 2, reverb_amt = 1, pan = 1,
	predelay = 0.048, combdecay=5, allpassdecay=1, revVol=0.31;
    var num_voices = 6, output, reverbed;
	//pitch = MouseY.kr;
	//speed = MouseX.kr(0, 10);
	//decay_time = MouseY.kr(6, 1);

	output = CombL.ar( (
		Dust.ar(speed.dup(num_voices),0.5 * speed.linlin(0,10, 0.8, 1.4))), 0.1, {((
		gauss(0.002, pitch_dev.linlin(0, 1, 0.0001, 0.0005)).abs
		//0.004.rand+0.0003
		+ pitch_fine.linlin(0, 1, 0.0009,0.0001).lag(0.4)) * pitch.linlin(0, 1, 5, 0.5)
	) }.dup(num_voices), {decay_time.rand}, 1/num_voices);
	output = RLPF.ar(output, pitch_fine.linlin(0, 1, 100, 3000 ), 0.3, 1);

	output = Pan2.ar(output, {1.0.rand2}.dup(num_voices));

	output = output * Lag3UD.kr(volume * volume2, 0, 0.3);

	output = Mix.new( output) ;
	output = LeakDC.ar(output);

	output = Pan2.ar(output, pan, 2);
	output = Mix.new( output) ;

}).play;



)