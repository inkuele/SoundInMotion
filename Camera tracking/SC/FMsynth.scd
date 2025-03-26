(
Server.default.options.device = "ASIO : Focusrite USB ASIO"; //set the soundcard to use the asio driver

s.waitForBoot {
    var freqAmpSlider, modIndexSlider, lpfSlider, modIndexBus, freqBus, ampBus, lpfBus, carPartialBus, modPartialBus, window, volumeSlider, volumeBus;

    // Create control buses for modulation index, frequency, amplitude, carPartial, modPartial, volume, and LPF
    modIndexBus = Bus.control(s, 1);  // Control bus for modulation index
    freqBus = Bus.control(s, 1);      // Control bus for frequency
    ampBus = Bus.control(s, 1);       // Control bus for amplitude (from /r OSC)
    carPartialBus = Bus.control(s, 1); // Control bus for carrier partial
    modPartialBus = Bus.control(s, 1); // Control bus for modulator partial
    lpfBus = Bus.control(s, 1);       // Control bus for LPF cutoff frequency
    volumeBus = Bus.control(s, 1);    // Control bus for master volume

    // Define the FM Synth using the structure of `fm1` SynthDef
    Ndef(\fmSynth, { |freq = 440, amp = 0.5, carPartial = 1, modPartial = 1, index = 3, lpfFreq = 12000, mul = 0.05|
        var mod, car, finalSignal;

        // Read values from control buses within the Ndef
        freq = In.kr(freqBus.index, 1);             // Read frequency from freqBus
        index = In.kr(modIndexBus.index, 1);        // Read modulation index from modIndexBus
        amp = In.kr(ampBus.index, 1);               // Read amplitude from ampBus
        carPartial = In.kr(carPartialBus.index, 1); // Read carrier partial from carPartialBus
        modPartial = In.kr(modPartialBus.index, 1); // Read modulator partial from modPartialBus
        lpfFreq = In.kr(lpfBus.index, 1);           // Read LPF cutoff frequency from lpfBus

        // Generate the modulator signal
        mod = SinOsc.ar(
            freq * modPartial,  // Modulation frequency
            0,                  // No initial phase
            freq * index * LFNoise1.kr(0.2).abs  // Frequency modulation depth modulated by noise
        );

        // Generate the carrier signal, frequency modulated by the modSignal
        car = SinOsc.ar(
            (freq * carPartial) + mod,  // Modulate the carrier frequency using the modulator signal
            0,
            amp * mul                   // Output amplitude of the carrier signal
        );

        // Apply a low-pass filter to control any high-frequency components if needed
        finalSignal = LPF.ar(car, lpfFreq);  // LPF frequency controlled by lpfFreq parameter

        // Apply LeakDC to remove DC offset and low-frequency peaks
        finalSignal = LeakDC.ar(finalSignal);

        // Apply master volume control
        finalSignal = finalSignal * In.kr(volumeBus.index, 1) * 4;

		finalSignal = GVerb.ar(finalSignal * In.kr(volumeBus.index, 1), 20);

        // Output the signal directly without flattening or nesting
        finalSignal;
    }).play;

	s.meter;
    // Set up initial values for control buses
    freqBus.set(150);         // Set initial frequency
    modIndexBus.set(3.0);     // Set initial modulation index
    ampBus.set(0.5);          // Set initial amplitude
    carPartialBus.set(1.0);   // Set initial carrier partial ratio
    modPartialBus.set(1.0);   // Set initial modulator partial ratio
    lpfBus.set(12000);        // Set initial LPF cutoff frequency
    volumeBus.set(0.5);       // Set initial master volume

    // Create a simple GUI window to control frequency, modulation index, LPF cutoff, and master volume
    window = Window("FM Synth Controller", Rect(100, 100, 400, 400)).front;

    // Frequency & Amplitude Control Slider (replaces Main Frequency slider)
    freqAmpSlider = Slider(window, Rect(20, 20, 360, 20));
    freqAmpSlider.action_({ |sl|
        var rValue = sl.value;  // Slider value ranges from 0 to 1
        var freqValue = rValue.linexp(0.0, 1.0, 150, 500);  // Map to frequency range (100 to 300 Hz)
        var ampValue = rValue.linlin(0.0, 1.0, 0.0, 1.0);   // Map to amplitude range (0 to 1)

        freqBus.set(freqValue);  // Set the frequency value using the bus
        ampBus.set(ampValue);    // Set the amplitude value using the bus

		// ("Frequency & Amplitude Slider Value: " + rValue + " | Frequency: " + freqValue + " | Amplitude: " + ampValue).postln;  // Debug print
    });
    StaticText(window, Rect(20, 0, 200, 20)).string_("Frequency & Amplitude");

    // Modulation Index Slider
    modIndexSlider = Slider(window, Rect(20, 60, 360, 20));
    modIndexSlider.action_({ |sl|
        var modValue = sl.value.linlin(0.0, 1.0, 0.1, 80.0);  // Map the slider range to a suitable modulation index range
        modIndexBus.set(modValue);  // Set the modulation index value using the slider
		// ("Modulation Index Slider Value: " + modValue).postln;  // Debug print
    });
    StaticText(window, Rect(20, 40, 200, 20)).string_("Modulation Index");

    // LPF Cutoff Frequency Slider
    lpfSlider = Slider(window, Rect(20, 100, 360, 20));
    lpfSlider.action_({ |sl|
        var lpfValue = sl.value.linexp(0.0, 1.0, 200, 18000);  // Map the slider range to a suitable LPF cutoff frequency range
		lpfBus.set(lpfValue);  // Set the LPF cutoff frequency value using the slider
		// ("LPF Cutoff Slider Value: " + lpfValue).postln;  // Debug print
    });
    StaticText(window, Rect(20, 80, 200, 20)).string_("Low-Pass Filter Cutoff");

    // Master Volume Slider
    volumeSlider = Slider(window, Rect(20, 140, 360, 20));
    volumeSlider.action_({ |sl|
        var volumeValue = sl.value.linexp(0.0, 1.0, 0.01, 1.0);  // Use exponential mapping for volume control
        volumeBus.set(volumeValue);  // Set the master volume using the volumeBus
		// ("Master Volume Slider Value: " + volumeValue).postln;  // Debug print
    });
    StaticText(window, Rect(20, 120, 200, 20)).string_("Master Volume");

    // Set initial values for GUI sliders
    freqAmpSlider.value = 0.5;    // Set initial slider value for frequency & amplitude control
    modIndexSlider.value = 0.5;   // Set initial slider value for modulation index
    lpfSlider.value = 0.5;        // Set initial slider value for LPF cutoff
    volumeSlider.value = 0.5;     // Set initial slider value for master volume

    // Ensure the window and sclang process shut down properly when the window is closed
    window.onClose_({
        CmdPeriod.run;  // Stops all running synths and clears the node tree
        s.quit;  // Gracefully quits the SuperCollider server
        0.exit;  // Exits SuperCollider entirely, closing sclang
    });

    // Handle OSC for /r to control both frequency (100-300 Hz) and amplitude (0-1) using a single value
    OSCdef(\rControl, { |msg|
        var rValue = msg[1].clip(0.0, 1.0);  // Clip the incoming value between 0 and 1
        var freqValue = rValue.linlin(0.0, 1.0, 200, 500);  // Map the OSC value to frequency range (100 to 300 Hz)
        var ampValue = rValue.linlin(0.0, 1.0, 0.0, 1.0);   // Map the OSC value to amplitude range (0 to 1)

        // Schedule the changes on the GUI thread
        AppClock.sched(0, {
            freqAmpSlider.value = rValue;  // Set the frequency & amplitude slider value (normalized to 0-1)
            nil;
        });

        freqBus.set(freqValue);  // Set the frequency value using the bus
        ampBus.set(ampValue);    // Set the amplitude value using the bus
		// ("Received OSC /r Value: " + rValue + " | Frequency: " + freqValue + " | Amplitude: " + ampValue).postln;  // Debug print
    }, '/r', recvPort:10000);

    // Handle OSC for /pos to control modulation index using a single value
    OSCdef(\posControl, { |msg|
        var posValue = msg[1].clip(0.0, 1.0);  // Clip the incoming value between 0 and 1
        var modValue = posValue.linlin(0.0, 1.0, 0.1, 24.0);  // Map the OSC value to modulation index range (0.1 to 24.0)

        // Schedule the changes on the GUI thread
        AppClock.sched(0, {
            modIndexSlider.value = posValue;  // Set the modulation index slider value (normalized to 0-1)
            nil;
        });

        modIndexBus.set(modValue);  // Set the modulation index bus value
		// ("Received OSC /pos Value: " + posValue + " | Modulation Index: " + modValue).postln;  // Debug print
    }, '/pos', recvPort:10000);
};
)
