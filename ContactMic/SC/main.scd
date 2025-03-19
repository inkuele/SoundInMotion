(
s.waitForBoot{
	~sample_id1 = 0;
	~sound = 0;
	(thisProcess.nowExecutingPath.dirname ++ "/synthdefs_noreverb.scd").load;
	(thisProcess.nowExecutingPath.dirname ++ "/ndefs_noreverb.scd").load;
	(thisProcess.nowExecutingPath.dirname ++ "/controlGUI.scd").load;
	(thisProcess.nowExecutingPath.dirname ++ "/data_selection.scd").load;
	s.meter;
	~data = SensorData.new;
	(thisProcess.nowExecutingPath.dirname ++ "/reverb.scd").load;
	(thisProcess.nowExecutingPath.dirname ++ "/amplitude_processing.scd").load;
	(thisProcess.nowExecutingPath.dirname ++ "/data_processing.scd").load;
};
)

NdefMixer(s);


(
n = SWPlotterMonitor.new( {
	//data to plot
	[
		[~amp, ~sma,  ~ma] // view the two streams superimposed
		//[~~e - ~f], // view their differene
		//[(~e- ~f).sign] // view sign of difference
]},
100, //nr of points to plot
3, // channels
0.125, // plot dtime
2 // write every n data points
).start;
)