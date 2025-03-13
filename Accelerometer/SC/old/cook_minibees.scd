


~cook_minibees = { arg msg, speedxyz,
	//speedx, speedy,
	debug = 0,  stlen = 3, ltlen = 50;

	var time, now, xyz,  val, longval, lastPeak,  dirx, diry;


	speedxyz.stlen_( stlen );
	speedxyz.ltlen_( ltlen );
	speedx.stlen_( stlen );
	speedy.ltlen_( ltlen );

	//msg.postln;
	//xyz = (pow(msg[3],2)+pow(msg[4],2)+pow(msg[5],2)).sqrt;
	xyz = (pow(msg[2],2)+pow(msg[3],2)+pow(msg[4],2)).sqrt;

	speedxyz.addValue(xyz);
	/*
	trying to calculate direction
	speedx.addValue(msg[3]);
	speedy.addValue(msg[4]);
	dirx =  (speedx.shortStdDev + speedy.shortStdDev)/2.sqrt;
	*/
	val = speedxyz.shortStdDev.explin(0.0003, 0.2, 0, 1);//.explin(0.0003, 0.2, 0, 1);
	longval = speedxyz.longStdDev.linlin(0.001, 0.1, 0.0, 1);
	lastPeak = speedxyz.lastPeak;

	if(debug ==1, {
		("~val"++msg[1]++": "++val).postln
		("~lastPeak"++msg[1]++": "++lastPeak[0]).postln;
		("longval"++msg[1]++": "++longval).postln;

	});


	[val, longval, lastPeak[0]];
};




