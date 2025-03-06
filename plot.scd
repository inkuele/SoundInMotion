/*
(
OSCdef( \minibeeRouter, { |msg|
	x = msg[2];
	y = msg[3];
	z = msg[4];

	}, "/minibee/data" ).permanent_(false);
)
*/
(
	m = SWPlotterMonitor.new( {
    //data to plot
    [
//		[ x,y,z], // view the two streams superimposed

    ~data, // view the two streams superimposed

 //   [ ~val3, ~val4, ~medVal1, ~expVal1], // view the two streams superimposed
//    [e, f], // view the two streams superimposed

    //[~e - ~f], // view their differene
    //[(~e- ~f).sign] // view sign of difference
    ]},
    200, //nr of points to plot
    4, // channels
    0.25, // plot dtime
    1 // write every n data points
    ).start;
)
//m.stop