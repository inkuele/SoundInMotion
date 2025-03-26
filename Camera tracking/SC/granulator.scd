
(
// Server.default.options.device = "ASIO : Focusrite USB ASIO"; //set the soundcard to use the asio driver
Server.default.options.device = "UMC204HD 192k";

s.waitForBoot{
	// Create global variables
	var createGUI, loadBufferAndSynths, window, toggleButton, volumeSlider, slider, posSlider, loadFileButton, bufferFile;
	var sliderBus, volumeBus, grainControlBus, posBus, bus1, bus2, b;

	// Add the closeAction here

	// Function to load buffer and initialize synths with enhanced file path validation and debugging
	loadBufferAndSynths = { |filePath|
		"Attempting to load buffer from file: ".post; filePath.postln;

		// Ensure the filePath is a valid string or PathName before proceeding
		if (filePath.isKindOf(String).not and: { filePath.isKindOf(PathName).not }) {
			"Invalid file path! Please provide a valid string or PathName.".postln;
			^nil;  // Exit the function
		};

		// Directly work with the provided path without using unsupported methods
		filePath.postln;  // Print the path to verify its format

		// Debug: Check if the file actually exists before loading
		if (File.exists(filePath).not) {
			"File does not exist at path: ".post; filePath.postln;
			^nil;  // Exit if file doesn't exist
		};

		// Read the buffer and handle any errors during loading using a completion function
		b = Buffer.readChannel(s, filePath.asString, channels: [0], action: { |buffer|
			// Buffer has been loaded; print its properties for confirmation
			"Buffer Loaded Successfully!".postln;
			"Buffer Duration: ".post; buffer.duration.postln;
			"Buffer Number of Channels: ".post; buffer.numChannels.postln;
			"Buffer Path: ".post; buffer.path.postln;

			// Create control buses for sliders, master volume, and position control
			sliderBus = Bus.control(s, 1);  // Create a control bus with 1 channel for the grain control slider
			volumeBus = Bus.control(s, 1);  // Create a control bus with 1 channel for volume
			posBus = Bus.control(s, 1);  // Create a control bus with 1 channel for position control
			// Create audio buses for routing each granulator’s output
			bus1 = Bus.audio(s, 2);  // Bus for \granularSynth1 (stereo)
			bus2 = Bus.audio(s, 2);  // Bus for \granularSynth2 (stereo)

			// Post Bus indices for debugging
			("Slider Bus Index: " + sliderBus.index).postln;
			("Volume Bus Index: " + volumeBus.index).postln;
			("Position Bus Index: " + posBus.index).postln;
			("Audio Bus 1 Index: " + bus1.index).postln;
			("Audio Bus 2 Index: " + bus2.index).postln;

			// Granular Synth 1
			Ndef(\granularSynth1, {
				|pos = 0.5, grainLength = 0.1, randAmount = 0|
				var grainTrig, grainPos, grainPitch, grains, changeDetector, posControl;

				// Detect changes in the slider value to trigger grains
				changeDetector = In.kr(sliderBus.index, 1);  // Read the slider value from the control bus
				grainTrig = Changed.kr(changeDetector);  // Create a trigger whenever slider value changes

				// Map slider value to grain length using exponential mapping for more control
				// grainLength = changeDetector.linexp(0.0, 1.0, 0.005, 2);  // More exponential control over grain length
				grainLength = changeDetector.lincurve(0, 1.0, 0.005, 2, 4);
				// Read position control value from posBus
				posControl = In.kr(posBus.index, 1);
				grainPos = posControl * b.duration;  // Use posControl value to set position in buffer

				// Randomized grain parameters controlled by the slider
				grainPitch = 1 + (LFNoise1.kr(1) * randAmount * 0.5 * changeDetector.lincurve(0, 1.0, -0.8, 1.2, 4));  // Random pitch shift controlled by randAmount

				// Granular synthesis using GrainBuf, triggered by slider movement
				grains = GrainBuf.ar(2, grainTrig, grainLength, b.bufnum, 1, grainPos, 1, grainPitch, pan: -0.3) * 0.1 * 0.5;  // Pan slightly left

				// Route grains to bus1
				Out.ar(bus1, grains);
			}).play;

			// Granular Synth 2
			Ndef(\granularSynth2, {
				|pos = 0.2, grainLength = 0.1, randAmount = 0|
				var grainTrig, grainPos, grainPitch, grains, changeDetector, posControl;

				// Detect changes in the slider value to trigger grains
				changeDetector = In.kr(sliderBus.index, 1);  // Read the slider value from the control bus
				grainTrig = Changed.kr(changeDetector);  // Create a trigger whenever slider value changes

				// Use a slightly different mapping for grain length
				// grainLength = changeDetector.linexp(0.0, 1.0, 0.1, 5);  // More exponential control for finer granularity
				grainLength = changeDetector.lincurve(0, 1.0, 0.1, 5, 4);


				// Read position control value from posBus
				posControl = In.kr(posBus.index, 1);
				grainPos = posControl * b.duration;  // Use posControl value to set position in buffer

				// Randomized grain parameters with slightly different mappings
				grainPitch = 1 + (LFNoise1.kr(1) * (randAmount * 0.3)* changeDetector.lincurve(0, 1.0, -0.85, 1.15, 4));  // Less pitch randomness

				// Granular synthesis using GrainBuf, triggered by slider movement
				grains = GrainBuf.ar(2, grainTrig, grainLength, b.bufnum, 1, grainPos, 1, grainPitch, pan: 0.3) * 0.1 * 0.5;  // Pan slightly right

				// Route grains to bus2
				Out.ar(bus2, grains);
			}).play;

			// Combined output
			Ndef(\combined, {
				var synth1, synth2, mixedAudio, reverb;

				// Read audio signals from the dedicated buses
				synth1 = In.ar(bus1, 2);  // Read from bus1 (granularSynth1)
				synth2 = In.ar(bus2, 2);  // Read from bus2 (granularSynth2)

				// Mix the two signals together
				mixedAudio = synth1 + synth2;

				// Apply reverb to the combined signal and control volume exponentially
				reverb = GVerb.ar(mixedAudio, 50, 8) * volumeBus.kr.exp * 0.1;  // Use exponential volume control

				Out.ar(0, reverb);  // Output the combined signal
			}).play;
		});
	};

	// Create the GUI for controlling the patch
	createGUI = {
		window = Window("Granular Synthesis Controller", Rect(100, 100, 400, 300)).front;

		// Use `0.exit;` to forcefully quit everything when the window is closed
		window.onClose_({
			CmdPeriod.run;  // Stops all running synths and clears the node tree
			s.quit;  // Gracefully quits the SuperCollider server
			0.exit;  // Exits SuperCollider entirely, closing sclang
		});

		// Toggle Button to start/stop the patch
		toggleButton = Button(window, Rect(20, 20, 120, 20)).states_([
			["Start", Color.white, Color.black],
			["Stop", Color.red, Color.black]
		]).action_({ |btn|
			if (btn.value == 0) {
				Ndef(\combined).play;
			}{
				Ndef(\combined).stop;
			};
		});

		// Volume Slider
		volumeSlider = Slider(window, Rect(160, 20, 200, 20));
		volumeSlider.action_({ |sl|
			volumeBus.set(sl.value.exp);  // Set the volume using the volumeBus with exponential scaling
		});
		StaticText(window, Rect(160, 0, 200, 20)).string_("Master Volume");

		// Grain Control Slider
		slider = Slider(window, Rect(20, 60, 360, 20));
		slider.action_({ |sl|
			sliderBus.set(sl.value);  // Set the slider value using the sliderBus
		});
		StaticText(window, Rect(20, 40, 200, 20)).string_("Grain Control");

		// Position Control Slider
		posSlider = Slider(window, Rect(20, 120, 360, 20));
		posSlider.action_({ |sl|
			posBus.set(sl.value);  // Set the position value using the posBus
		});
		StaticText(window, Rect(20, 100, 200, 20)).string_("Position Control");

		// Load File Button for manual file selection
		loadFileButton = Button(window, Rect(20, 160, 360, 20)).states_([["Load File", Color.white, Color.black]]);

		// Use the correct implementation of Dialog.openPanel with completion and cancel actions
		loadFileButton.action_({
			Dialog.openPanel({ |path|  // Completion action for when a file is selected
				if (path.notNil) {
					// Use the path as a string directly
					bufferFile = path.asString;
					"Manually selected file: ".post; bufferFile.postln;

					// Ensure the file exists before attempting to load
					if (File.exists(bufferFile)) {
						"File exists: ".post; bufferFile.postln;
						loadBufferAndSynths.(bufferFile);
					}{
						"File does not exist at the given path.".postln;
					};
				}
			}, {
				"File selection was cancelled.".postln;  // Cancel action if no file is selected
			});
		});
	};

	s.meter;
	// Run everything inside a Routine to ensure proper execution order
	Routine({
		// Create the GUI
		loadBufferAndSynths.("C:/Users/ziw-i/Desktop/Workshop/7_framedifference_sound/AudioFIles/09 - Mutual Core_slice.wav");
		createGUI.();
		// 1. OSC Listener for /r (Grain Control)
		OSCdef(\grainControl, { |msg|
			var grainValue = msg[1].clip(0.0, 1.0);  // Clip the OSC value between 0 and 1

			// Update slider on the GUI using AppClock for thread safety
			AppClock.sched(0, {
				slider.value = grainValue;  // Set the slider value
				nil;
			});

			// Set the grain control bus value
			sliderBus.set(grainValue);

			// Post the received OSC value to check for correctness
			("Received OSC /r value: " + grainValue);
		}, '/r', recvPort:10000);

		// 2. OSC Listener for /pos (Position Control)
		OSCdef(\posControl, { |msg|
			var posValue = msg[1].clip(0.0, 1.0);  // Clip the value between 0 and 1

			// Schedule the position slider update on the AppClock (GUI thread)
			AppClock.sched(0, {
				posSlider.value = posValue;  // Update the position control slider's value on the GUI thread
				nil;
			});

			posBus.set(posValue);  // Send the value to the posBus
		}, '/pos', recvPort:10000);

	}).play(AppClock);
};
)

