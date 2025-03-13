/*
todo:
4.
- fix the sensitives!
*/
(
~data_sel = { arg val, longval, which;
	var res,  time, now;
	val = val.linlin(0.05, 0.9, 0, 1.0);
	time = Main.elapsedTime.asInteger;
	now = (time.asInteger)-0.1;

	res = case
		{ which == 0} {
		/*
		~ibeat.set(\volume, 0);
		~trigDrones.set(\volume, 0);
		~gran1.set( \volume, 0);
		~gran2.set( \volume, 0);

		~fw.set(\volume, 0);
		Ndef(\complexB).set(\volume, 0);
		~pad.set(\volume, 0);
		~stranga.set(\volume, 0);
*/

	}
	{ which == 1} {
//val.postln;

		~ibeat.set(\volume, val.linlin(0, 0.02, 0, 0.25).poll);

		~ibeat.set(\speed, ((val + val + longval)/3).linlin(0, 0.2, 0, 1));
		~ibeat.set(\speed2, ((val + val + longval)/3).linlin(0.3, 1, 0, 3));

		~ibeat.set(\scale_freq, val.linlin(0.7, 1, 1, 3));
		~ibeat.set(\volume2, val.linlin(0.5, 1, 1, 1.25));

		~ibeat.set(\which, val.linlin(0.6, 1, 0, 0.5));
		~ibeat.set(\pitch, val.linlin(0.4, 0.8, 0, 1));
		~ibeat.set(\pitchDispertion, val.linlin(0.5, 0.8, 0, 0.2));
	~ibeat.set(\timeDispertion, val.linlin(0.6, 1, 0, 0.2));


		if( (val > 0.99) && (now < time),
			{
				//Synth(\ibeat, [\scale_freq, exprand(0.2, 2.0), \which, 0.5, \pitchRatio, 1.0.rand, \pitchDispertion, 3.0.rand, \timeDispertion, 3.0.rand, \volume, 1]);
				} );
	}
	{ which == 2 } {
		~trigDrones.set(\volume, val.linlin(0, 0.2, 0, 1.2));
		~trigDrones.set(\volume2, val.linlin(0.3, 1, 1, 3));
		~trigDrones.set(\speed, (val.linlin(0.15, 1, 0, 35) ));
		~trigDrones.set(\rate, (val.linlin(0.9, 0.95, 1, 1.25) ));
		~trigDrones.set(\lpfFreq, (val.linlin(0.2, 0.8, 3000, 8000) ));

		~trigDrones.set(\sensitive, (val.linlin(0.02, 0.04, 0, 1) ));

	}
	{ which == 3 } {
			var sample_id;
		//granulator



//val.postln;
		~gran1.set(\bufNum, ~b[~sample_id1].bufnum);
		~gran1.set(\pan, 0);

		~gran1.set( \volume, val.linlin(0.2, 0.3, 0, 0.8));
		~gran1.set( \volume2, val.linlin(0.1, 0.7, 1, 2));
		~gran1.set( \volume3, val.linexp(0.6, 1, 1, 1.5));

		~gran1.set( \trigRate1, val.linlin(0.2, 0.5, 3, 10));
			//~samples_data[~sample_id1][5])); // mean or val?
		~gran1.set( \trigRate2, val.linexp(0.4, 1, 0.0001, 15));
		~gran1.set( \dur, val.linlin(0.7, 1, 0.3, 1));

			~gran1.set( \pv_amt, val.linlin(0.5, 1.0, 0, 0.5));
			~gran1.set( \stretch_bins, val.linexp(0.5, 1, 0.5, 4));

		~gran1.set( \amtRnd, val.linlin(0.3, 1, 0, 0.2));

		if((val > 0.95) && (~changed3 !=0), {
			~ratef = (Scale.bartok.ratios.choose * 0.8);
//			0.93438789791794

		//	~gran1.set(\pos, rrand(0.01, 0.99));
			~gran1.set(\rate, ~ratef.postln);

		});
		if((~sensitive3 == 0) && (val > 0.04), {
			~sensitive3 = 1;
		//	Synth(\granS, [\bufNum, ~b[~sample_id1].bufnum, \volume, rrand(1.5, 2.0).postln, \rate, ~ratef, \dur, rrand(0.3, 0.2), \pan, -1, \pos,  rrand(0.01, 0.99), \cutoff, ~ratef.linlin(0.7, 1.24, 3000, 500)]);



		});
		if((~sensitive3 == 1) &&(val < 0.04), {
			~sensitive3 = 0;
					~ratef = (Scale.bartok.ratios.choose * 0.7);
//						~gran1.set(\pos, rrand(0.01, 0.99));
			//~gran1.set(\rate, ~ratef.postln);
		});

	}
	{ which == 4 } {
			var sample_id;

		//granulator


		~sample_id2 = 2;

		~gran2.set(\bufNum, ~b[~sample_id2].bufnum);
		~gran2.set(\pan, 1);



		~gran2.set( \volume, val.linlin(0, 0.1 , 0, ~samples_data[~sample_id2][2]));
		~gran2.set( \volume2, val.linlin(0.1, 0.7, 1, ~samples_data[~sample_id2][3]));
		~gran2.set( \volume3, val.linlin(0.6, 1, 1, ~samples_data[~sample_id2][4]));

		~gran2.set( \trigRate1, val.linexp(0.1, 0.5, 2, ~samples_data[~sample_id2][5])); // mean or val?
		~gran2.set( \trigRate2, val.linlin(0.5, 1, 0, ~samples_data[~sample_id2][6]));
		~gran2.set( \dur, val.linlin(0.4, 1, 0.4, 1));

			~gran2.set( \pv_amt, val.linlin(0.5, 0.9, 0, 0.5));
				~gran2.set( \stretch_bins, val.linexp(0.6, 1, 0.5, 4));

		~gran2.set( \amtRnd, val.linlin(0.2, 1, 0.002, ~samples_data[~sample_id2][7]));

		if((val > 0.95) && (~changed4 !=0), {
			~ratef = (Scale.bartok.ratios.choose * 0.7);
			~gran2.set(\pos, ~samples_data[~sample_id2][8].choose.postln);
			~gran2.set(\rate, ~ratef);

		});
		if((~sensitive4 == 0) && (val > 0.04), {
			~sensitive4 = 1;
			Synth(\granS, [\bufNum, ~b[~sample_id2].bufnum, \volume, rrand(0.5, 1.5), \rate, ~ratef, \dur, rrand(0.1, 0.2), \pan, 1, \pos, ~samples_data[sample_id][8].choose, \cutoff, ~ratef.linlin(0.7, 1.24, 3000, 500)]);



		});
		if((val < 0.04), { ~sensitive4 = 0;			 });

	}
	{ which == 5 } {
			// strings

		~fw.set(\volume,	val.linlin(0, 0.1, 0, 0.65));
		~fw.set(\deviation, val.linlin(0.4, 0.8, 5, 150));
		~fw.set(\step, val.linlin(0.3, 1, 0.01, 10));
		~fw.set(\freq_scale, val.linlin(0.5, 1, 1, 2));

		~fw.set(\volume2, val.linlin(0.2, 1, 1, 4));
		~fw.set(\lowPass_scale, val.linlin(0.3, 0.8, 1, 1));

		if(val > 0.95, {
			//~fw.set(\scale_val, rrand(0.5, 1.5).postln;);
			Synth(\freq_wanderS, [\volume, rrand(1, 2), \lo, rrand(50, 80), \hi, rrand(70, 110), \deviation, exprand(90, 100), \scale_val, rrand(0.5, 1.5), \pan, 1]);

		});
		if((~sensitive5 == 0) && (val > 0.04), {
			~sensitive5 = 1;
			Synth(\freq_wanderS, [\volume, rrand(0.3, 0.6), \lo, rrand(40, 70), \hi, rrand(70, 100), \deviation, exprand(50, 100), \scale_val, rrand(0.5, 1.5), \pan, 0]);
		});
		if((val < 0.04), { ~sensitive5 = 0;			 });
			//deviation = MouseX.kr(1, 150);step = MouseX.kr(0.01, 10);

		/*
		~string.set( \volume, val.linlin(0, 0.0001 , 0, 0.3));
		~string.set( \volume2, val.linlin(0.4, 1 , 1, 2));

		~string.set( \sustain, val.linlin(0, 1 , 5, 0.1));
		~string.set( \freq, val.linexp(0.5, 1, 211, 250));
		~string.set( \lpfF, val.linexp(0.3, 1, 1000, 6000));

			//"dev: ".post;
		~string.set(\freq_dev, (val.linlin(0.4, 0.8, 0.1, 10) ));
		~string.set(\sdecay, (val.linexp(0.5, 1, 1, 0.1) ));
		~string.set( \freq2, val.linexp(0.8, 1, 0, 50));
		~string.set( \mx, val.linlin(0, 0.8, 0, 20));
*/



//		if((sensitive == 0) && (val > 0.04), {   Synth(\stringS, [\freq2, 50.0.rand, \freq_dev, 5.0.rand]);sensitive = 1;}); if((val < 0.04), { sensitive = 0; });


		//sensitive.postln;
		//~string.set(\sensitive, val.linlin(0.02, 0.04, 0, 1 ));
	}

		{ which == 6 } {
		//val = val.linlin(0, 0.9, 0, 1);
			Ndef(\complexB).set(\volume, val.linlin(0, 0.1, 0, 0.5));

			Ndef(\complexB).set(\volume2, val.linlin(0.5, 1, 1, 2));
			Ndef(\complexB).set(\lpfFreq, val.linexp(0.1, 0.8, 50, 20000));

			//Ndef(\complexB).set(\hpfFreq, val.linlin(0.9, 1, 10, 1000));


			Ndef(\complexB).set(\decay_bass, val.linlin(0.6, 0.8, 1, 3));

			Ndef(\complexB).set(\speed, val.linlin(0, 0.2, 3, 1.5));
			Ndef(\complexB).set(\freqBmul, val.linlin(0.5, 1, 1, 1.5));
		//	Ndef(\complexB).set(\mulDelay, val.linlin(0.8, 1, 0, 1));
		//	Ndef(\complexB).set(\decaytime, val.linlin(0.7, 1, 0, 5));

//Ndef(\complexB).set(\speed, 1.5,\volume, 0.4, \mulDelay, 1, \delaytime, 0.1, \decaytime, 1, \decay_bass, 1);

	//		Ndef(\complexB).set(\speed2, val.linlin(0.8, 1, 0, -0.25));
	}
	{ which == 7 } {

		// todo: pops are too loud, too much q? - sensitive must be something different, some kind of short and quiet puff
		//val.postln;
		~pad.set(\volume, val.linlin(0.05, 0.1, 0, 0.5));
			//filter_mod = MouseX.kr(0.1, 4.5, 1); rq_mod = MouseY.kr(0.1, 2.0);
		~pad.set(\volume2, val.linlin(0.3, 1, 1, 3.5));

		~pad.set(\filter_mod, val.linexp(0.2, 1, 0.5, 4.5));
		~pad.set(\rq_mod, val.linexp(0.3, 0.7, 0.25, 1.0));
		//~pad.set(\scale_freq, val.linlin(0.85, 1, 0.5, 0.55));

		if((~sensitive7 == 0) && (val > 0.04), {
			~sensitive7 = 1;
			//~ratef = (Scale.bartok.ratios.choose * 0.7);
			//~gran1.set(\pos, (Scale.bartok.ratios.choose * 0.7).choose.postln);
			Synth(\padS, [\volume, rrand(0.1, 0.2), \scale_freq, rrand(0.3, 0.75), \filter_mod, rrand(0.5, 1) ]);
		});
		if((val < 0.04), { ~sensitive7 = 0;			 });

			}
	{ which == 8 } {
		//val = val.linlin(0,1,0,0.7);
		~stranga.set(\volume, val.linlin(0, 0.05, 0, 1.5));
		~stranga.set(\volume2, val.linexp(0.1, 1, 1, 5));

		~stranga.set(\speed, val.linlin(0, 0.8, 0, 5));
		~stranga.set(\pitch_dev, val.linlin(0.5, 1, 0.1, 2));
		~stranga.set(\decay_time, val.linlin(0.1, 1, 6, 1));
		~stranga.set(\pitch_fine, val.linlin(0.25, 1, 0.25, 1));
		~stranga.set(\pan, 0);
		//if(val > 0.95, {~stranga.set(\pitch, rrand(0.2, 1);) });

		//sensitive.postln;

			//pitch = MouseY.kr;
	//speed = MouseX.kr(0, 10);
	//decay_time = MouseY.kr(6, 1);
	//pitch_dev = GrayNoise.kr(0.01).range(0.001, 0.009).poll;
		if((~sensitive8 == 0) && (val > 0.8), {
			~sensitive8 = 1;

			Synth(\strangaS, [\volume, rrand(0.2, 0.5) * 2.25, \pitch, rrand(0.3, 0.8), \pitch_fine, rrand(0.1, 0.5), \pitch_dev, rrand(0.3, 0.7), \decay_time, rrand(1.0, 7.0), \roomsize, rrand(80, 150), \revtime , rrand(2.0,6.0), \pan, 1  ]);
		});
		if((val < 0.8), { ~sensitive8 = 0;			 });

			}
	{ which == 9 } {

		~drC.set(\volume, val.linlin(0.05, 0.15, 0, 1));

		~drC.set(\lowPassFreq, val.linexp(0.1, 0.8, 300, 8000));
		~drC.set(\lowPassQ, val.linlin(0.1, 1, 2, 1));
		~drC.set(\volume2, val.linlin(0.3, 1, 1, 8));

		if((~sensitive9 == 0) && (val > 0.06), {
			~sensitive9 = 1;

			Synth(\droneCymbal, [ \lowPassFreq , rrand(100, 8000), \lowPassQ, rrand(1,2), \freq_scale, rrand(0.5, 1.2), \volume, rrand(0.2, 0.5), \pan, rrand(-1, 1)]);		});
		if((val < 0.06), { ~sensitive9 = 0;			 });

			}
	{ which == 10} {
		/*
		if(val > 0.9, {
					//Synth(\strangaS, [\volume, rrand(0.7, 1), \pitch, rrand(0.6, 1), \pitch_fine, rrand(0.3, 1), \pitch_dev, rrand(0.5, 1), \decay_time, rrand(1.0, 7.0), \roomsize, rrand(80, 150),\revtime , rrand(2.0,6.0) ]);

		});
		*/

		if((~sensitive10 == 0) && (val > 0.3), {
			~sensitive10 = 1;

			Synth(\strangaS, [\volume, rrand(0.2, 0.5) * 1.25, \pitch, rrand(0.3, 0.8), \pitch_fine, rrand(0.1, 0.5), \pitch_dev, rrand(0.3, 0.7), \decay_time, rrand(1.0, 7.0), \roomsize, rrand(80, 150), \revtime , rrand(2.0,6.0), \pan, 1  ]);
		});
		if((val < 0.3), { ~sensitive10 = 0;			 });
	}
	{ which == 11} {


		if((~sensitive11 == 0) && (val > 0.3), {
			~sensitive11 = 1;

			Synth(\strangaS,  [\volume, rrand(0.1, 0.35)* 0.75, \pitch, rrand(1.0, 2.0), \pitch_fine, rrand(0.8, 1.5), \pitch_dev, rrand(0.5, 0.8), \decay_time, rrand(1.0, 7.0), \roomsize, rrand(80, 150),\revtime , rrand(2.0,6.0), \pan, -1 ]);
		});
		if((val < 0.3), { ~sensitive11 = 0;			 });
	}
	{ which == 12 } {
					// strings
		~string.set( \volume, val.linlin(0, 0.1 , 0, 0.1));
		~string.set( \volume2, val.linlin(0.4, 1 , 1, 2));

		~string.set( \sustain, val.linlin(0, 1 , 5, 1));
	~string.set( \freq, val.linexp(0.5, 1, 211, 250));
		~string.set( \lpfF, val.linexp(0.2, 1, 1000, 6000));

			//"dev: ".post;
//		~string.set(\freq_dev, (val.linlin(0.4, 0.9, 0.1, 10) ));
		~string.set( \fdecay, (val.linlin(0.5, 1, 0.01, 3) ));
		~string.set( \freq2, val.linlin(0.8, 1, 0, 20));

		~string.set( \mx, val.linlin(0, 1, 0, 30));
	};
	res;

};

~hyper_data_sel = { arg val, which;
	var res;
	/*
	~ibeat.stop;
	~sig1.stop;
	~gran1.free;
	~string.stop;
*/
	res = case
		{ which == 0} {

	}
	{ which == 1} {


		//Synth(\kick, [\volume, 0.25]); Synth(\snare, [\volume, 0.01]);
	}
	{ which == 2} {
		~sig1.set(\select, 1.0.rand );
		"octave: ".post;~sig1.set(\octave, ([1, (5/4), 3/2].wchoose([0.4,0.3,0.3]) * [1, 1/4, 1/6, 1/8, 1.5, 2].wchoose([0.1, 0.2, 0.2, 0.2, 0.15, 0.15]) * 0.45) );
	}
		{ which == 3} {
		"pos: ".post;~gran1.set( \pos, ~samples_data[~sample_id][8].choose);
		~gran1.set( \rate, rrand(0.5, 1.2));
	}

		{ which == 4} {

	};

				"lastpeak: ".post;~lastPeak1[0].postln;
				~now = (~t.asInteger)+0.1;
				"now: ".post;~now.postcs;
				"time: ".post;~t.postcs;
		res;

};
)
