~fw.stop
~stranga.stop
//Ndef(\complexB).set(\speed, 1.5,\volume, 0.4, \mulDelay, 1, \delaytime, 0.1, \decaytime, 1, \decay_bass, 1);
(
var wave, buf;
wave = Wavetable.chebyFill(512, [1]);
buf = Buffer.alloc(s, 1024, 1);
buf.sendCollection(wave.asWavetableNoWrap);
/*
Ndef(\complexB, {arg volume = 0, volume2 = 1,speed = 1.5 , speed2 = 0, hpfFreq = 10, lpfFreq = 20000, which = 0, filter = 0, decay_bass = 1, distortion = 0, freqBmul = 1, delaytime = 0.1, decaytime = 0.1, mulDelay = 0;


var ctrigs, ctrigsB, freq, freqW, freqB, clicks, output, waves, bass, chain;
	//decay_bass = MouseX.kr(0.01, 3).poll;which = MouseY.kr();filter = MouseX.kr;
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

	output = (bass + waves + clicks) * 0.5;
/*
	chain = FFT(LocalBuf(2048), output, hop:0.25, wintype:1);
	// PV_RandComb is cool
	// chain = PV_PhaseShift(chainB, -120, 31);
	chain = PV_MagShift(chain,  MouseX.kr(0.25, 4, 1).poll);
	output = IFFT(chain);
	*/
	output = RLPF.ar(output, lpfFreq, 0.7);
	output = RHPF.ar(output, hpfFreq.lag(0.1), 0.7);
//BBCut2
	output = MidEQ.ar(output, 2000, 0.7, 6) * volume * volume2;
//	output = GVerb.ar(output, 100, 1.24, 0.1, 0.95, 15, 0.dbamp, -9.dbamp, -11.dbamp);

	//output = output+CombN.ar(output, 0.5, delaytime, decaytime, mulDelay);
//	output = output + (output * ToggleFF.ar(TDelay.ar(ctrigs, decaytime) * mulDelay) );
	output = LeakDC.ar(output);
	Out.ar(0, output);
}).play;
*/
~fw = Ndef(\freq_wander, { arg out=0, lo=70, hi=80, step=1, rate=10, volume=0, volume2 = 1, pan=0, lgate = 1, scale_val = 0.5339359416674, scale_tones = 1, deviation = 1, freq_scale = 1, bwr = 0.2, lowPass_scale = 1;
	var output, freq, num_comb, num_tones, freq_list, bpassFreq;
	num_comb = 24;
	num_tones = num_comb*2;
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

	output = Mix.ar(Array.fill(num_comb,{ CombN.ar(output, 0.02, rrand(0.001, 0.02), 0.5, 1/num_comb) })) *1 * Lag3UD.kr(volume * volume2, 0, 0.5 );
//	output = Resonz.ar(output, bpassFreq, bwr, 10);
	//output = LPF.ar(output, 1000);
	output = LeakDC.ar(output);
//	output = GVerb.ar(output, 200, 3):
//	output = FreeVerb.ar(output, 0.5, 0.5) * 1.5;
	output = Mix.new(output);

	OffsetOut.ar(out, Limiter.ar(Pan2.ar(output, pan, 1), 0.9));
}, [\ir]).play;
/*
~trigDrones = Ndef(\trigDrones, {| out = 0, speed = 0, select = 0, decaytime = 0.5, volume = 0, volume2 = 1, sensitive = 0, rate = 1, octave = 0.5, lpfFreq = 4000, decay_scale =1 |

	var pitch, mousex, ausgang, size, pluck, period, string,trigger = 0, triggerNote, timer;

	//pitch = Scale.rast.cents;		// e a d g b e
	pitch = [1,9/8,6/5,4/3,3/2,8/5,7/4] * octave * 0.5;// * 52;
	mousex = select.lag(0.1);//

	//mousex = MouseX.kr;speed = MouseY.kr(0, 10);
size = 100;

	trigger = Mix.fill(size, { arg i;


		// place trigger points from 0.25 to 0.75
	//timer = Timer.kr(trigger);  // how long since the last trigger?
		trigger =  HPZ1.kr(mousex > (0.01 +(i * size.reciprocal)).postln).abs * 0.5;
		//trigger = HPZ1.kr(mousex).abs;

		//string = CombL.ar(pluck, period, period, 4);

		//Pan2.ar(string, 0);// i * 0.2 - 0.5);

	});
	//trigger = triggerNote;// +  HPZ1.kr(speed);
	pluck = PinkNoise.ar(Decay.kr((trigger + Impulse.kr(speed, 0, 10) + Trig.kr(sensitive, 0.05)), 0.05 * decay_scale)) * volume * volume2;

	period = Select.kr(mousex * pitch.size, pitch);

	ausgang = RLPF.ar(Ringz.ar(pluck, {rrand(500, 10000)}.dup(12) * period * rate,{rrand(0.5, 1.5)}.dup(12) * decaytime, 0.1).mean, lpfFreq, 1.2 ) * 0.02;
		//string = LPF.ar(Ringz.ar(pluck, {rrand(500, 10000)}.dup(12) * period.poll,{rrand(0.5, 1.5)}.dup(12), 0.1).mean, 10000) * 0.2;
	//ausgang = Streson.ar(ausgang);

	//ausgang = CombL.ar(string, period, period, 4);
	//ausgang = RLPF.ar(ausgang, 4000);

	ausgang = LeakDC.ar(ausgang) ;
//	ausgang = GVerb.ar(ausgang, 200, 3);
//	ausgang = AdCVerb.ar( ausgang, 2 ) ;
	Out.ar(out,ausgang);

});
*/

~stranga = Ndef(\stranga, {arg speed = 0, volume = 0, volume2 = 1, pitch =0.8, pitch_fine =0.5, pitch_dev = 1, decay_time = 2, reverb_amt = 1, pan = 1,
	predelay = 0.048, combdecay=5, allpassdecay=1, revVol=0.31;
    var num_voices = 16, output, reverbed;
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

	Out.ar(0, output  );
}).play;
/*
~pad = Ndef(\pad, { arg  freqMul = 0.6,  master_vol = 0.3, volume = 0, scale_freq = 0.5, filter_mod = 1, rq_mod = 1,  volume2 = 1, pan =0;
	var sig, freq, gen, fmod, rqmod;
	freq = { ([60, 67, 75, 89, 106].choose.midicps * VarLag.kr(scale_freq, 20, 4) )* LFNoise2.kr(1,0.01,1) }!24;
	gen = LFSaw.ar(freq* freqMul) * 0.1;
	//filter_mod = MouseX.kr(0.1, 4.5, 1); rq_mod = MouseY.kr(0.1, 2.0);
	fmod = LFCub.kr(1/12).range(1, 1.5) * filter_mod; // modulate filter
	rqmod = LFNoise2.kr(1/8).range(0.5,1.2) * rq_mod;
//	sig = BPF.ar(gen, (freq.mean * fmod).poll , rqmod.poll) * master_vol * volume;
	sig = Resonz.ar(gen, (freq.mean * fmod) ,rqmod, rqmod.reciprocal * 0.5);
	//sig = Mix.ar(sig);
	//sig = AdCVerb.ar( sig, 4)* 0.015;
	//sig = Mix.ar(sig);
	//sig = Limiter.ar(sig);
	//sig =  BBandPass.ar(gen, (freq.mean * fmod).poll , rqmod.poll) * master_vol * volume;
	sig = Splay.ar(sig, 1, 3, BrownNoise.kr(1)) *
//	(volume * volume2)
	Lag3UD.kr(volume * volume2, 0.1, 0.5) * 0.4
	;
//	sig = GVerb.ar(sig, 200, 5, 0.7, 0.5, 50) * 0.1;
//	sig = AdCVerb.ar(sig, 3) * 0.2;
//	sig = FreeVerb.ar(sig, 1, 0.9);
//	sig = Mix.new(sig);

	//sig = Pan2.ar(sig, pan) * 0.4;
	Out.ar(0, sig);
}).play;


~drC = Ndef(\droneCymbal, {arg lowPassFreq  =400, lowPassQ = 1, freq_scale = 0.7, volume = 0,volume2 = 0, pan = 0;
	var lfo, num_freq, ratios, output, volFilter;
	num_freq = 50;//MouseY.kr(1,50);//50;
	ratios = Scale.whole.ratios;
	lfo =  LFCub.kr(1/8);
	//lowPassFreq = MouseX.kr(100, 8000);lowPassQ = MouseY.kr(2, 1);

	output = BPF.ar(Ringz.ar(BrownNoise.ar(0.1), {exprand(50, 15000) * ratios.choose}.dup(num_freq) *
		freq_scale
		,{rrand(0.1, 1)}.dup(num_freq), 0.25).mean, (lowPassFreq * lfo.range(0.7, 1.2) ).lag(0.3)
		, lowPassQ.reciprocal.lag(0.3), lowPassFreq.linlin(100, 8000, 1, 12).lag(0.3)
	) * 1/4 * Lag3UD.kr(volume * volume2, 0, 0.5);

	output = Out.ar(0, Pan2.ar(output, pan));

}).play;
*/
)