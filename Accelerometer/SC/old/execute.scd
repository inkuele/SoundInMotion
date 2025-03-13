/*
- glissando mit granular synthese? => rate with line change, like a glissando
*/
(
s.waitForBoot{
	(thisProcess.nowExecutingPath.dirname ++ "/synths_noreverb.scd").load;
//(thisProcess.nowExecutingPath.dirname ++ "/ndefs_noreverb.scd").load;
//(thisProcess.nowExecutingPath.dirname ++ "/reverb.scd").load;
	};
~sensitive3 = 0;
)
(thisProcess.nowExecutingPath.dirname ++ "/zeroVol.scd").load;

("/usr/bin/python2.7 /Users/marcello/Music/Supercollider/external_git/miniBee/ssdn_python/pydon/scripts/pydoncli.py  -s /dev/tty.usbmodem1411 -c /Users/marcello/Music/Supercollider/external_git/miniBee/ssdn_python/pydon/4minibees_new.xml").runInTerminal;

(
(thisProcess.nowExecutingPath.dirname ++ "/minibees_data.scd").load;
(thisProcess.nowExecutingPath.dirname ++ "/plot_minibee.scd").load;

//(thisProcess.nowExecutingPath.dirname ++ "/controlPatch.scd").load;
//(thisProcess.nowExecutingPath.dirname ++ "/controlScenes_new.scd").load;
//s.meter
)
	(thisProcess.nowExecutingPath.dirname ++ "/synths_noreverb.scd").openDocument;
(thisProcess.nowExecutingPath.dirname ++ "/ndefs_noreverb.scd").openDocument;

~val1
(thisProcess.nowExecutingPath.dirname ++ "/plot_minibee.scd").openDocument;
(thisProcess.nowExecutingPath.dirname ++ "/minibees_data.scd").openDocument;
thisProcess.nowExecutingPath.dirname
(thisProcess.nowExecutingPath.dirname ++ "/zeroVol.scd").load;
~minibee1 = 0; ~minibee2 = 0; ~minibee3 = 3; ~minibee4 = 0;
~val2
~gran1.get(\pos).postln;
			~gran1.set(\pos, rrand(0.01, 0.99).postln);
			~gran1.set(\rate, 0.25/1);
			~gran1.set(\rate, 0.25);

~gran1.set(\rate, (1.5 * Scale.bartok.ratios.choose).postln);
~
~sample_id1 = 9;~minibee3 = 0;
~sample_id1 = 2;
~b[3]
~gran2.free
~fw.clear
// kind of bell
~sample_id1= 3;
// piano ?
~sample_id1= 10;
// subtle for the head
~sample_id1= 12;
// scream
~sample_id1= 16;

// trommel 2
~sample_id1= 18;
~sample_id1= 19;

// voice
~sample_id1= 20;

// metallophone
	~sample_id1= 1;


~minibee2 = 0; ~minibee4 = 0; ~minibee3 = 3;
~minibee4 = 0; ~minibee2 = 0;~minibee3 = 0;
// after breathing
~minibee3 = 5;
~fw.set(\scale_val,  [0.30238105197449, 0.42763138470637, 0.5339359416674, 0.71271897451062].choose.postln)

~fw.set(\scale_val, (Scale.bartok.ratios.choose * 0.8 * [0.95891652919953, 1.140350359217, 1.4254379490212, 2.0158736798299].choose).postln)

~minibee3 = 0;

//master
~minibee4 = 3; ~minibee3 = 0; (thisProcess.nowExecutingPath.dirname ++ "/zeroVol.scd").load;	~sample_id1= 4;

~minibee4 = 0;(thisProcess.nowExecutingPath.dirname ++ "/zeroVol.scd").load;	~sample_id1= 4;
// master
	~sample_id1= 4;


~b[~sample_id1]
~b
		~sample_id1 = 20;
		~sample_id1= 15;
// master
	~sample_id1= 4;
// kind of bell
~sample_id1= 3;
// piano ?
~sample_id1= 10;
// subtle for the head
~sample_id1= 12;
// scream
~sample_id1= 16;

// trommel 2
~sample_id1= 18;
~sample_id1= 19;

// voice
~sample_id1= 20;

// metallophone
	~sample_id1= 1;
// bells ?
	~sample_id1= 0;
	~sample_id1= 3;


// trommel
	~sample_id1= 5;
// low one
 ~sample_id1=9;

~samples_data[~sample_id1][2]
~b[20]
~sensitive3 = 0;
~b.size
~b[19]
(thisProcess.nowExecutingPath.dirname ++ "/zeroVol.scd").load;
~minibee1 = 0; ~minibee2 = 0;~minibee3 = 0; ~minibee4 = 0;

~minibee4 = 0;

~minibee4 = 2;
~trigDrones.set(\octave, rrand(0.25, 1.5).postln);
~trigDrones.set(\freq_scale, [0.7857234338162, 0.8819447349256, 0.93438789791794, 1.1111807363757].choose.postln);
~trigDrones.set(\freq_scale, [1.3334168836508, 1.4445349572884,  1.573222430718, 1.8708873080904].choose.postln);

~minibee4 = 3;
			~ratef = (Scale.bartok.ratios.choose * 0.5);
			~gran1.set(\pos, ~samples_data[~sample_id1][8].choose);
			~gran1.set(\rate, ~ratef.postln);

~minibee4 = 5;
~fw.set(\scale_val,  [0.30238105197449, 0.42763138470637, 0.5339359416674, 0.71271897451062].choose.postln)

~fw.set(\scale_val, (Scale.bartok.ratios.choose * 0.8 * [0.95891652919953, 1.140350359217, 1.4254379490212, 2.0158736798299].choose).postln)

~minibee4 = 0;
~stranga.set(\pitch, (Scale.bartok.ratios.choose * 0.5).postln);
~stranga.set(\pitch, 0.5993228307497); // tief
~stranga.set(\pitch, 0.67347722898531); // mitte
~stranga.set(\pitch, 0.84534797668457); // hoch
~stranga.set(\pitch, 1.048814953812); // sehr hoch

~minibee4 = 9;
~drC.set(\freq_scale, (Scale.bartok.ratios.choose * 0.7 * 1.3).postln);
~drC.set(\freq_scale, [0.7857234338162, 0.8819447349256, 0.93438789791794, 1.1111807363757].choose.postln);
~drC.set(\freq_scale, [1.3334168836508, 1.4445349572884,  1.573222430718, 1.8708873080904].choose.postln);


(thisProcess.nowExecutingPath.dirname ++ "/zeroVol.scd").load;
(thisProcess.nowExecutingPath.dirname ++ "/minibees_data.scd").openTextFile;

~minibee1





~pad.set(\scale_freq, 0.5);
~pad.set(\scale_freq, 0.7857234338162);
~pad.set(\scale_freq, 1.1111807363757);
~pad.set(\scale_freq, 1.2472582053936);

~pad.set(\scale_freq, (Scale.bartok.ratios.choose * 1.5).postln);
~drC.stop
~minibee2 = 3;
~minibee2 = 8;
~minibee2

~minibee4 = 0;
~minibee2 = 0;
~minibee1 = 0;

~minibee2 = 9;
~drC.set(\freq_scale, (Scale.bartok.ratios.choose * 0.7 * 2).postln);
~minibee2 = 3;
~gran1.set(\rate, Scale.bartok.ratios.choose * 0.7)
~gran2.free

~minibee2 = 12;
		~string.set(\freq_dev, 3);
~string.set(\freq_scale, Scale.bartok.ratios.choose * 1);

