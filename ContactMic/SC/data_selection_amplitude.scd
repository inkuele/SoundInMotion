(
~data_sel_amp = { arg val, rawval, which;
	var res,  time, now;

	time = Main.elapsedTime.asInt;
	now = (time.asInt)-0.1;

	res = case
	{ which == 0} {

	}
	{ which == 1} {
		~stranga.set(\volume, val.linlin(0, 0.05, 0, 1.5 * ~v[1]));
		~stranga.set(\volume2, val.linexp(0.1, 1, 1, 7 *~v[1]));

		~stranga.set(\speed, val.linlin(0, 0.8, 0, 5));
		~stranga.set(\pitch_dev, val.linlin(0.5, 1, 0.1, 2));
		~stranga.set(\decay_time, val.linlin(0.1, 1, 6, 1));
		~stranga.set(\pitch_fine, val.linlin(0.8, 1, 0.25, 0.3));
		~stranga.set(\pan, 0);

		if((~sensitive2 == 0) && (val > 0.1), {
			~sensitive2 = 1;

			Synth(\strangaS, [\volume, rrand(0.5, 1) * val * 1.5, \pitch, rrand(0.2, 0.5), \pitch_fine, rrand(0.1, 0.5), \pitch_dev, rrand(0.3, 0.7), \decay_time, rrand(2.5, 7.0).postln, \roomsize, rrand(80, 150), \revtime , rrand(2.0,6.0), \pan, 0  ]);
		});
		if((val < 0.1), { ~sensitive2 = 0;			 });

		if((~sensitive1 == 0) && (val > 0.8), {
			~sensitive1 = 1;

			Synth(\strangaS,  [\volume, rrand(0.1, 0.5) * val, \pitch, rrand(1.0, 2.0), \pitch_fine, rrand(0.8, 1.5), \pitch_dev, rrand(0.5, 0.8), \decay_time, rrand(2, 7.0), \roomsize, rrand(80, 150),\revtime , rrand(2.0,6.0), \pan, 0 ]);
		});
		if((val < 0.8), { ~sensitive1 = 0;			 });
	}
	{ which == 2 } {
		~trigDrones.set(\volume, val.linlin(0, 0.2, 0, 1.2 *~v[2]));
		~trigDrones.set(\volume2, val.linlin(0.3, 1, 1, 3 *~v[2]));
		~trigDrones.set(\speed, (val.linlin(0.15, 1, 0, 35) ));
		~trigDrones.set(\rate, (val.linlin(0.9, 0.95, 1, 1.25) ));
		~trigDrones.set(\lpfFreq, (val.linlin(0.2, 0.8, 3000, 8000) ));

		~trigDrones.set(\sensitive, (val.linlin(0.02, 0.04, 0, 1) ));

	}
	{ which == 3 } {
		var set = 1, x;
		//granulator


		// ~sample_id1 = 10;// 10 stone

		~gran1.set(\bufNum, ~b[~sample_id1].bufnum);
		~gran1.set(\pan, 0);


		~gran1.set( \volume2, 1 * ~v[3]);
				~gran1.set( \volumeLag, 1);

		x = case
		{ set == 1} {
//			~gran1.set( \volume, 1);
			~gran1.set( \volume, val.linlin(0.3, 1 , 0, 1 *~v[3]));
		~gran1.set( \trigRate1, val.linlin(0.3, 1, 2, 10)); // mean or val?
		//~gran1.set( \pv_amt, val.linlin(0.4, 1, 0, 0.5));
		//~gran1.set( \stretch_bins, val.linlin(0.5, 1, 0.2, 0.5));
		}
		{ set == 2} {
			~gran1.set( \volume, val.linlin(0.1, 1 , 0, val *1 *~v[3]));
		~gran1.set( \trigRate1, val.linexp(0, 1, 8, 50)); // mean or val?
		~gran1.set( \pv_amt, val.linlin(0.5, 1, 0, 0.7));
					//~gran1.set( \rate, val.linlin(0.5, 1.0, 1, 1.5));

		~gran1.set( \stretch_bins, val.linlin(0.4, 0.8, 0.5, 2.5));
		};
		/*
		~gran1.set( \volume2, val.linlin(0.1, 0.7, 1, ~samples_data[~sample_id1][3]));
		~gran1.set( \volume3, val.linlin(0.6, 1, 1, ~samples_data[~sample_id1][4]));
		*/


		//	~gran1.set( \trigRate2, val.linlin(0.5, 1, 0, ~samples_data[~sample_id1][6]));
		~gran1.set( \dur, val.linlin(0.5, 1, 0.2, 0.5));
		~gran1.set( \amtRnd, val.linlin(0.1, 1, 0.1, 0.3));





		//~gran1.set( \amtRnd, val.linlin(0.6, 1, 0.002, ~samples_data[~sample_id1][7]));
		//~gran1.set( \pos, 0.31);
//val.postln;
		if((val > 0.9 && (~changed_3 == 0)) , {
			"rate: ".post;
			~ratef = (Scale.bartok.ratios.choose * 0.4
				* [1,-1].choose
		//		 * -1
			).postln;
			//			0.93438789791794
			~gran1.set(\pan, rrand(-0.5,0.5));
			"pos: ".post;
			~gran1.set(\pos, rrand(0.1,0.9).postln);
			~gran1.set(\rate, ~ratef.postln);
			~changed_3 = 1;
		});
		if((~sensitive3 == 0) && (val > 0.15), {
			~sensitive3 = 1;

			//Synth(\granS, [\bufNum, ~b[~sample_id1].bufnum, \volume, rrand(1, 1.5), \rate, 0.9, \dur, rrand(0.1, 0.2), \pan, -1, \pos, 0.5, \cutoff, ~ratef.linlin(0.7, 1.24, 3000, 500)]);
		});
		if((val < 0.9), { ~sensitive3 = 0;		~changed_3 = 0;	 });

	}
	{ which == 4 } {

		~drC.set(\volume, val.linlin(0.05, 0.15, 0, 2 *~v[4]));

		~drC.set(\lowPassFreq, val.linexp(0.1, 0.8, 300, 8000));
		~drC.set(\lowPassQ, val.linlin(0.1, 1, 2, 1));

		if((~sensitive9 == 0) && (val > 0.06), {
			~sensitive9 = 1;

			Synth(\droneCymbal, [ \lowPassFreq , rrand(100, 8000), \lowPassQ, rrand(1,2), \freq_scale, rrand(0.5, 1.2), \volume, rrand(0.1, 0.3), \pan, rrand(-1, 1)]);		});
		if((val < 0.06), { ~sensitive9 = 0;			 });

	}
	{ which == 5 } {
		// strings
		~string.set( \volume, val.linlin(0, 0.1 , 0, 0.1 *~v[5]));
		~string.set( \volume2, val.linlin(0.4, 1 , 1, 2));

		~string.set( \sustain, val.linlin(0, 1 , 5, 1));
		~string.set( \freq, val.linexp(0.5, 1, 211, 250));
		~string.set( \lpfF, val.linexp(0.2, 1, 1000, 6000));

		//"dev: ".post;
		//		~string.set(\freq_dev, (val.linlin(0.4, 0.9, 0.1, 10) ));
		~string.set( \fdecay, (val.linlin(0.5, 1, 0.01, 3) ));
		~string.set( \freq2, val.linlin(0.8, 1, 0, 20));

		~string.set( \mx, val.linlin(0, 1, 0, 30));
	}
	{ which == 6} {
		var thershold = 0.2, trig, rate = [rrand(1.20,1.00), 0.9];

		case
		{ val < 0.2 } { trig = 0 } //
		{ val < 0.4 } { trig = 1 }
		{ val < 0.7 } { trig = 2 }
		{ val < 0.99 } { trig = 3 }
		{ val < 1.5} { trig = 4};


		if(trig > ~lastVal, {

			Synth(\granS, [\bufNum, ~b[~sample_id1].bufnum, \volume, val  * ~v[6], \rate,
			//	~reverse_sample *
				[1, -1].wchoose([0.5, 0.5]).postln *
				// rrand(0.1, 2.0) *
		//1,
		//		1,
		// [-1,	Scale.chromatic.ratios.linlin(1, 1.8877486253586, 0.9416764004839,  1.0583235995161).choose].wchoose([0.2, 0.8]).postln,

				Scale.chromatic.ratios.linlin(1, 1.8877486253586, 0.875, 1.125).choose,
					//Scale.chromatic.ratios.choose,

//				rate[(trig-1)].postln,
			//	\attack, exprand(0.15, 0.5), \dur, exprand(0.15, 1.0) * 0.5,

				// free position
				\attack, exprand(0.0001, 0.8), \dur, rrand(1.0, 3.0), \pan, rrand(-0.5,0.5), \pos, rrand(0.01, 0.95),//0.1,

				// notehit
			//	\attack, exprand(0.1, 0.8), \dur, rrand(8.0, 10.0), \pan, rrand(-1.0,1.0), \pos, rrand(0.05, 0.15),	\cutoff, rrand(500, 5000),\volumeLag, 6

			//("trigger"++trig).postln;
			//	~lastVal = trig; //update
			]);



		});
						~lastVal = trig; //update

	}
	{ which == 7} {
		Ndef(\comb).set(\volume, val * ~v[7]);
		//val.postln;
};
};
)
/*
~v7
Ndef(\comb).set(\volume,1);
Ndef(\comb).get(\volume);

(
r =Routine {
a = Pseq([ 1, 1.0083727381632, 1.0172433452459, 1.0266414260745, 1.0365983458703, 1.0471473349273, 1.0583235995161, 1.0701644393807, 1.0827093722235, 1.0960002655916, 1.1100814766062, 1.125 ], inf).asStream;
inf.do({
	Synth(\granS, [\bufNum, ~b[~sample_id1].bufnum, \volume, 1, \rate, a.next,				\attack, exprand(0.001, 0.8), \dur, rrand(5.0, 8.0), \pan, rrand(-1.0,1.0), \pos, 0,	\cutoff, 5000,\volumeLag, 6]);
});
};
)
//	Synth(\granS, [\bufNum, ~b[~sample_id1].bufnum, \volume, 1, \rate, 1,				\attack, exprand(0.001, 0.8), \dur, rrand(5.0, 8.0), \pan, rrand(-1.0,1.0), \pos, 0,	\cutoff, 5000,\volumeLag, 6]);
*/
//Synth(\granS, [\bufNum, ~b[~sample_id1].bufnum, \volume, 1, \rate, 1.0583235995161,				\attack, exprand(0.001, 0.8), \dur, rrand(5.0, 8.0), \pan, rrand(-1.0,1.0), \pos, 0,	\cutoff, 5000,\volumeLag, 6]);

