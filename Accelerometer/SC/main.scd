(
s.waitForBoot{
	(thisProcess.nowExecutingPath.dirname ++ "/ndefs_noreverb.scd").load;
	(thisProcess.nowExecutingPath.dirname ++ "/synths_noreverb.scd").load;

	(thisProcess.nowExecutingPath.dirname ++ "/reverb.scd").load;

	(thisProcess.nowExecutingPath.dirname ++ "/data_processing.scd").load;

	(thisProcess.nowExecutingPath.dirname ++ "/data_selection.scd").load;
};
)

(thisProcess.nowExecutingPath.dirname ++ "/plot.scd").load;

NdefMixer(s);

~sound = 0

~sound = 1
~sound = 0
~sound = 2
~sound = 0;
~sound = 3;

s.freeAll