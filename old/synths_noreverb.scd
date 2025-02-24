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
SynthDef(\strangaS, {arg speed = 1, volume = 0, volume2 = 1, pitch =0.5, pitch_fine =0.5, pitch_dev = 0.0003, decay_time = 4, roomsize = 100, revtime = 3, trigger = 1, pan = 0;
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

	output = output * Lag3UD.kr(volume * volume2, 0, 0.1)  * EnvGen.ar(Env.perc(0.02, 3), 1, doneAction:2);


	output = LeakDC.ar(output);

	output = Mix.ar(output);

	output = Pan2.ar(output, pan);
	output = LeakDC.ar(output);

	Out.ar(0, output  * 0.25);
}).add;

SynthDef(\gran, { arg bufNum = 2, pos = 0.1, trigRate1 = 3,trigRate2 = 0,trigRate3 = 0, rate = 1, frate = 1, overlap = 4, amtRnd = 0, lfoR = 4, dur = 0.3, list_of_pos = [0, 0.5],
		amFreq = 64, amVol = 0.5, pan = 0,
	stretch_bins = 0.5, //0.1-4 exponential
	pv_amt = 0, freeze = 0,
	holdperiod = 0.02, multiplier = 1, stutter = 0,
	ffreq_low = 22000, drywet = -0.8, decay = 0.1,
	panMax = 1, amp = 0.5, interp = 4, volume = 0, volume2 = 1, volume3 = 1, master_vol = 1,
	rndTrigRate = 0, speedRndTrigRate = 2, speedRndRate = 5, rndRate = 0, combLevel = -1, envbufnum;
    var trate, rndPos, ausgang, am, midiOsc, freqMod, sig, reverbered, comb, chain;
	rate = rate * frate;
	//trigRate1 =MouseX.kr(0, 10); dur = MouseX.kr(0.2, 1);
	pos = pos + LFNoise0.kr(lfoR, amtRnd );

	trate = (trigRate1 + trigRate2 + trigRate3);
	ausgang = TGrains2.ar(2, Impulse.kr(trate) , bufNum, rate, pos.linlin(0, 1, 0,  BufDur.kr(bufNum)) , dur , 0, amp, 0.01, decay, 4);

	// AM
	am = SinOsc.ar( amFreq, mul:amVol*1.5) * SinOsc.ar( (amFreq)/2, mul:amVol*1.5);
	ausgang = XFade2.ar(ausgang, ausgang * am, amVol.linlin(0, 1, -1, 1));


	sig = ausgang * volume * volume2 * volume3 * master_vol;

	chain = FFT(LocalBuf(2048), sig);
	chain = PV_BinShift(chain, stretch_bins, 0, 4);
	sig = SelectX.ar(pv_amt, [sig,  IFFT(chain, 0) *4]);

	sig = RLPF.ar(sig, 3000, 0.8, 0.7);
//	sig = FreeVerb.ar(sig, 0.95, 0.9, 0.8);
	sig = Mix.ar(sig) * 1.5;

	sig = Limiter.ar(sig, 0.8);
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig, pan).clip2;

	Out.ar(0, sig  );

}).add;


SynthDef(\granS,{ arg out, bufnum, dur = 1, rate = 1, pos = 0.0, volume = 1,  speed =0.1, pan, drywet = 1, cutoff = 1000;//, freq = 400;
var env, grain, chain, chainout, mix, mixChain, reverbered;

     env = EnvGen.kr(Env.perc(0.01, dur), doneAction:0) - 0.001;
     grain = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * rate, 1,
                                                       BufFrames.kr(bufnum) * pos) * env;
	mix = BBandPass.ar(grain, cutoff, 0.7) * volume;

	//reverbered = FreeVerb.ar(grain, 0.8, 0.8, 1) *  (EnvGen.kr(Env.perc(0.01, dur*4), doneAction:2) - 0.001);
	//mix = XFade2.ar(grain, reverbered, drywet.linlin(0, 1, -1, 1));

	mix = Pan2.ar(mix, pan);
	mix = LeakDC.ar(mix);
	Out.ar(out, mix.clip2(0.9)) ;

}).add;

SynthDef(\glitch_sounds, { arg outbus = 0, modN = 0.5, modF = 0.4, modAmp1 = 0.1, modAmp2 = 1, modAmp3 = 1, modC = 1, gpos = 0,  volume = 0, volume2 = 1;
	var chain, snd;

	snd = BPF.ar(WhiteNoise.ar(mul: SinOsc.ar(modF,phase:Rand (0,pi), mul:Rand( 0.1,1) )),modAmp1 * modAmp2 * modAmp3 *  Rand(0,400) * modN  )!2
	+
	BPF.ar(WhiteNoise.ar(mul: SinOsc.ar(modF,phase:Rand (0,pi), mul:Rand( 0.1,1) )),modAmp1 * modAmp2 * modAmp3  * Rand(0,400)* modN )!2
	+
	BPF.ar(WhiteNoise.ar(mul: SinOsc.ar(modF,phase:Rand (0,pi), mul:Rand( 0.1,1) )),modAmp1 * modAmp2 * modAmp3  * Rand(0,400) * modN )!2 ;
	snd = BrownNoise.ar(modF, snd) + snd;
	snd = snd.clip2(0.5);
	snd = Array.fill(8, CombN.ar(snd, 0.2, {rrand(0.05,0.1)} * modC, {rrand(0.1,1)} * modC, 1/8));
	snd = Mix.new(snd);
	snd = HPF.ar(snd, 20);

	//snd = GVerb.ar(snd, 5, 0.83423432, 0.5, spread:15, mul:0.2);
	snd = Pan2.ar(snd, gpos) * volume * volume2 * 0.1;
	//snd = GVerb.ar(snd, 100);
	snd = LeakDC.ar(snd);
	Out.ar(outbus, snd ).clip2(0.5);

}).add;


SynthDef(\droneCymbal, {arg lowPassFreq  =400, lowPassQ = 1, freq_scale = 0.7, volume = 0.4, pan = 0;
	var lfo, num_freq, ratios, output, volFilter;
	num_freq = 50;//MouseY.kr(1,50);//50;
	ratios = Scale.whole.ratios;
	lfo =  LFCub.kr(1/8);
	//lowPassFreq = MouseX.kr(100, 8000);lowPassQ = MouseY.kr(2, 1);

	output = BPF.ar(Ringz.ar(BrownNoise.ar(0.1), {exprand(50, 15000) * ratios.choose}.dup(num_freq) *
		//Select.kr(MouseX.kr(0, 1).round(0.2) * r.size * 0.5, r).poll  *
		freq_scale
		//* lfo.range(0.9, 1.1)
		,{rrand(0.1, 1)}.dup(num_freq), 0.25).mean, (lowPassFreq * lfo.range(0.5, 1.5) )
		, lowPassQ.reciprocal, lowPassFreq.linlin(100, 8000, 1, 12)
	)  * volume * EnvGen.ar(Env.perc(), doneAction:2);
	//s = Array.fill(n, RLPF.ar(Ringz.ar(PinkNoise.ar(0.1), {rrand(300, 10000)} * Select.kr(MouseX.kr(0, 1) * r.size, r).poll *0.2 ,{rrand(0.5, 1.5)}, n.reciprocal/4), 1000)) * 1/16;
	//AdCVerb.ar( output, 2);
	//output = FreeVerb.ar(output, 0.5, 0.8) ;
	output = Out.ar(0, Pan2.ar(output, pan));

}).add;
/*
SynthDef(\stringS, {arg out=0, freq=211, freq2 = 0, pan=0, mx = 0, mx2 = 0,sustain=0.5, volume=0.5,sgate = 0, sensitive = 0, freq_dev = 1, sdecay =1, freq_scale = 1, brFreq = 400;
	var pluck, period, string, impulse, trig, res_num = 6;

	freq=freq + freq2;// + MouseY.kr(12,78).round(2) ;

	//mx=MouseX.kr(0,50).poll  ;

	impulse =  Impulse.ar(mx + mx2);
	//freq = Demand.ar(impulse, 0, Drand([60, 67, 64, 72, 58], inf)).midicps;
	freq = Demand.ar(impulse, 0, Dwhite((freq-freq_dev), (freq+freq_dev), inf)!res_num)  * freq_scale;
	sgate = Demand.ar(impulse, 0, Dseq([1,0], inf)) + sgate;

	sustain = Demand.ar(impulse, 0, Dwhite(0.4, 1.0, inf));

	period = freq.reciprocal;//Array.fill(4, {freq.reciprocal.rand});

	pluck = PinkNoise.ar(0.2) * EnvGen.ar(Env.perc(0.02, 0.03), sgate);

	//string = CombL.ar(pluck, 0.1, period, {sustain.rand}*6);

	string = Splay.ar(CombL.ar(pluck, 0.2, period, {sustain.rand}* sdecay) );
	//freq.poll;
	//string = BRF.ar(string, brFreq, 0.5);

	string = LeakDC.ar(LPF.ar(Pan2.ar(string, pan), 3000)) * volume * EnvGen.ar(Env.perc(0.02, 3), sgate, doneAction:2);
//	string = GVerb.ar(string, 200, 1) * 0.5;

//	string = GVerb.ar(string, 100, 1.85, 0.41, 0.19, 0.71, 0.35, 0.28 ) * 0.5;
	string = Mix.new(string);

	//string = GVerb.ar(string, 200, 1) * 0.5 ;
	string = Pan2.ar(string, pan, 3);
	//DetectSilence.ar(string, doneAction:2);

	Out.ar(out, string);
}).add;
*/
SynthDef(\freq_wanderS, { arg out=0, lo=70, hi=80, step=1, rate=10, volume=0, volume2 = 1, pan=0, lgate = 1, scale_val = 1, scale_tones = 1, deviation = 1, bwr = 0.2;
	var output, freq, num_comb, num_tones, freq_list, bpassFreq;
	num_comb = 24;
	num_tones = num_comb*2;
	//deviation = MouseX.kr(1, 150);step = MouseX.kr(0.01, 10);
//	freq = Demand.ar(Impulse.ar(rate), 0,Dbrown(lo, hi, step) ).midicps.poll * scale_val;
	freq = rrand(lo, hi).midicps* scale_val;
//	freq = Demand.ar(Impulse.ar(rate), 0, SinOsc.ar(0.02).range(lo, hi)).midicps * scale_val;

	output = RLPF.ar(
		//Mix.new(VarSaw.ar((freq + [0, -0.2, 0.2, 0.4, -0.4]).poll, 0, 0.8, 0.1)),
		Mix.new(VarSaw.ar((freq  + Array.fill(num_tones, {gauss(0.0, 0.5) * deviation})), 0, 0.8, 0.1)), LFNoise2.ar(0.5).range((freq * 0.634423), (freq* 0.834232)), 0.5, 0.5
	);

	output = Mix.ar(Array.fill(num_comb,{ CombN.ar(output, 0.02, rrand(0.001, 0.02), 0.5, 1/num_comb) })) * 0.2 * volume * volume2 * EnvGen.ar(Env.perc(0.02, 5, curve:-14), 1, doneAction:2);
//	bpassFreq = freq * 0.45232423;

//	output = Resonz.ar(output, bpassFreq, bwr, 6);

	output = LeakDC.ar(output);
//	output = GVerb.ar(output, 200, 3):
//	output = FreeVerb.ar(output, 0.5, 0.5) * 1.5;
	output = Mix.new(output);

	Out.ar(out, Limiter.ar(Pan2.ar(output, pan, 1), 0.9));
}).play;
/*
SynthDef(\trigDrones, {| out = 0, speed = 0, select = 0, decaytime = 0.5, volume = 0, volume2 = 1, sensitive = 0, rate = 1, octave = 0.5, lpfFreq = 4000 |

	var pitch, mousex, ausgang, size, pluck, period, string,trigger = 0, triggerNote, timer;

	//pitch = Scale.rast.cents;		// e a d g b e
	pitch = [1,9/8,6/5,4/3,3/2,8/5,7/4] * octave * 0.5;// * 52;
	mousex = select;//
//	mousex = MouseX.kr; speed = MouseY.kr(0, 4);
size = 100;

	trigger = Mix.fill(size, { arg i;
		trigger =  HPZ1.kr(mousex > (0.01 +(i * size.reciprocal)).postln).abs;
	});

	pluck = PinkNoise.ar(Decay.kr((trigger + Impulse.kr(speed, 0, 5) + Trig.kr(sensitive, 0.05)), 0.05)) * volume * volume2;

	period = Select.kr(mousex * pitch.size, pitch);

	ausgang = RLPF.ar(Ringz.ar(pluck, {rrand(500, 10000)}.dup(12) * period * rate,{rrand(0.5, 1.5)}.dup(12) * decaytime, 0.1).mean, lpfFreq ) * 0.02;

	ausgang = LeakDC.ar(ausgang) * EnvGen.ar(Env.perc(0.02, 1.5), 1, doneAction:2);


	Out.ar(out,ausgang);

}).add;

SynthDef(\padS, { arg  freqMul = 0.6,  master_vol = 0.3, volume = 0, scale_freq = 0.5, filter_mod = 1, rq_mod = 1,  volume2 = 1, pan = 0;
	var sig, freq, gen, fmod, rqmod;
	freq = { ([60, 67, 75, 89, 106].choose.midicps * scale_freq) * LFNoise2.kr(1,0.01,1) }!24;
	gen = LFSaw.ar(freq* freqMul) * 0.1;
	//filter_mod = MouseX.kr(0.1, 4.5, 1); rq_mod = MouseY.kr(0.1, 2.0);
	fmod = LFCub.kr(1/12).range(1, 1.5) * filter_mod; // modulate filter
	rqmod = LFNoise2.kr(1/8).range(0.7,1.3) * rq_mod;
		sig = Resonz.ar(gen, (freq.mean * fmod) , rqmod, rqmod.reciprocal * 0.5) * EnvGen.ar(Env.perc(0.5, 3, curve:-6), doneAction:2);

	sig = Splay.ar(sig, 1, 3, BrownNoise.kr(3)) * volume * volume2;

	sig = Mix.new(sig);
	sig = Pan2.ar(sig, pan);
	Out.ar(0, sig);
}).add;
*/
// ~path="/Users/marcello/Music/Samples/GranularSelection/*.wav";
~path="/home/marcello/Music/Samples/Slices_GiantSteps/*.wav";

//~path="/Users/marcello/Music/Samples/metabody_tolouse/*.wav";
//~path="/Users/marcello/Music/Samples/MartinLau/*.wav";
~path.pathMatch;
~b = ~path.pathMatch.collect { |i| Buffer.readChannel(s, i, channels:[0])};
// array of data about the samples
// 0 id of the sample, 1 pitch of the grain (0-1), 2 max vol1, 3 max vol2, 4 max vol3, 5 trigRate1, 6 trigRate2, 7 amtRand max, 8 list of good positions
~samples_data = [
	[0, 1, 0.5, 2, 2, 5, 5, 0.2, [0.03, 0.18,  0.367,  0.46, 0.51,  0.79, 0.86] ],//
	[1, 1, 0.5, 2, 2, 5, 5, 0.2, [0.01, 0.02, 0.04,  0.18, 0.19] ],
	[2, 1, 1, 2.5, 2.5, 5, 5, 0.2, [0.03, 0.08, 0.11,0.13,0.18, 0.26, 0.29, 0.36, 0.361, 0.363, 0.367, 0.38, 0.46, 0.51, 0.52, 0.55, 0.65, 0.68, 0.79, 0.86, 0.88, 0.9, 0.94, 0.95, 1]],
	[3, 1, 0.7, 1.5, 2.5, 5, 5, 0.2, [0, 0.01, 0.1, 0.13,0.17,  0.19, 0.29, 0.37, 0.6]],
	[4, 1, 0.5, 2, 2, 5, 5, 0.2, [0, 0.1, 1]],
	[5, 1, 0.5, 2, 2, 5, 5, 0.2, [0, 0.4, 0.6]],
	[6, 1, 1, 3, 3, 5, 5, 0.2, [0.05, 0.1, 0.3, 0.4, 0.7]]
];

~gran1 = Synth(\gran);
//~gran2 = Synth(\gran);
)

