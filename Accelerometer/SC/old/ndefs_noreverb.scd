(
var wave, buf;
wave = Wavetable.chebyFill(512, [1]);
buf = Buffer.alloc(s, 1024, 1);
buf.sendCollection(wave.asWavetableNoWrap);

~fw = Ndef(\freq_wander, { arg lo=70, hi=80, step=1, rate=10, volume=0, volume2 = 1, pan=0, lgate = 1, scale_val = 0.5339359416674, scale_tones = 1, deviation = 1, freq_scale = 1, bwr = 0.2, lowPass_scale = 1;
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
	// output = Mix.new(output);
	// output = Limiter.ar(Pan2.ar(output, pan, 1));

}).play;

~trigDrones = Ndef(\trigDrones, {|  speed = 0, select = 0, decaytime = 0.5, volume = 0, volume2 = 1, sensitive = 0, rate = 1, octave = 0.5, lpfFreq = 4000, decay_scale =1 |

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


});


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

}).play;

)