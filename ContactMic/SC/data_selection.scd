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


		~fw.end;
		Ndef(\complexB).end;
		~stranga.end;


	}
	{ which == 1} {
		// strings
		~fw.play;

		~fw.set(\volume,	val.linlin(0, 0.1, 0, 0.65));
		~fw.set(\deviation, val.linlin(0.4, 0.8, 5, 150));
		~fw.set(\step, val.linlin(0.3, 1, 0.01, 10));
		~fw.set(\freq_scale, val.linlin(0.5, 1, 1, 2));

		~fw.set(\volume2, val.linlin(0.2, 1, 1, 4));
		~fw.set(\lowPass_scale, val.linlin(0.3, 0.8, 1, 1));


	}

	{ which == 2 } {
		Ndef(\complexB).play;

		Ndef(\complexB).set(\volume, val.linlin(0, 0.1, 0, 0.5));

		Ndef(\complexB).set(\volume2, val.linlin(0.5, 1, 1, 2));
		Ndef(\complexB).set(\lpfFreq, val.linexp(0.1, 0.8, 50, 20000));

		//Ndef(\complexB).set(\hpfFreq, val.linlin(0.9, 1, 10, 1000));


		Ndef(\complexB).set(\decay_bass, val.linlin(0.6, 0.8, 1, 3));

		Ndef(\complexB).set(\speed, val.linlin(0, 0.2, 3, 1.5));
		Ndef(\complexB).set(\freqBmul, val.linlin(0.5, 1, 1, 1.5));

	}
	{ which == 3 } {
		~stranga.play;
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
		if((~sensitive8 == 0) && (val > 0.98), {
			~sensitive8 = 1;

			Synth(\strangaS, [\volume, rrand(0.2, 0.5) * 2.25, \pitch, rrand(0.3, 0.8), \pitch_fine, rrand(0.1, 0.5), \pitch_dev, rrand(0.3, 0.7), \decay_time, rrand(1.0, 7.0), \roomsize, rrand(80, 150), \revtime , rrand(2.0,6.0), \pan, rrand(-0.5, 0.5), \gate, 1 ]);
		});
		if((val < 0.98), { ~sensitive8 = 0;			 });


	};
	res;

};
)