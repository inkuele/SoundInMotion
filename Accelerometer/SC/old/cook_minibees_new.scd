


~cook_minibees = { arg msg, speedxyz, oscar = 0, oscar_there = 0 , debug = 0,  stlen = 3, ltlen = 50;

	var time, now, xyz,  val, longval, lastPeak;

	speedxyz.stlen_( stlen );
	speedxyz.ltlen_( ltlen );


			//xyz = (pow(msg[3],2)+pow(msg[4],2)+pow(msg[5],2)).sqrt;
	xyz = (pow((msg[2]-0.5),2)+pow((msg[3]-0.5),2)+pow((msg[4]-0.5),2)).sqrt;

			speedxyz.addValue(xyz);
			val = speedxyz.shortStdDev.explin(0.0003, 0.16, 0, 1);//.explin(0.0003, 0.2, 0, 1);
			longval = speedxyz.longStdDev.linlin(0.001, 0.1, 0.0, 1);
			lastPeak = speedxyz.lastPeak;

		if(debug ==1, {
	("~val"++msg[1]++": "++val).postln
	("~lastPeak"++msg[1]++": "++lastPeak[0]).postln;
	("longval"++msg[1]++": "++longval).postln;

	});

		if(oscar_there > 0, {
		/*
		oscar.sendMsg("/x1", speedx1.shortStdDev);
		oscar.sendMsg("/y1", speedy1.shortStdDev);
		oscar.sendMsg("/z1", speedz1.shortStdDev);
		*/
		oscar.sendMsg("/xyz"++msg[1], val);
		oscar.sendMsg("/xyzLong"++msg[1], val);

		oscar.sendMsg("/lastPeakxyz"++msg[1], lastPeak[0]);

		});

	[val, longval, lastPeak[0]];
};




