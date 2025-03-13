(

// ✅ Properly initialize IdentityDictionary
~activeNdefs = IdentityDictionary.new;
~activeNdefs.put(\trigDrones, false);
~activeNdefs.put(\fw, false);
~activeNdefs.put(\stranga, false);

// ✅ Function to toggle Ndefs based on a threshold
~toggleNdefByValue = { |ndefName, val, threshold|
    if (val > threshold) {
        if (~activeNdefs.at(ndefName) == false) {
            Ndef(ndefName).play;
            ~activeNdefs.put(ndefName, true);
        }
    } {
        if (~activeNdefs.at(ndefName) == true) {
            Ndef(ndefName).end;
            ~activeNdefs.put(ndefName, false);
        }
    };
};

// ✅ Function to map sensor values to Ndef parameters
~mapSensorToParam = { |ndefName, param, val, inMin, inMax, outMin, outMax, curve|
    if (val >= inMin && val <= inMax) {
        case
        { curve == \lin } { Ndef(ndefName).set(param, val.linlin(inMin, inMax, outMin, outMax)) }
        { curve == \exp } { Ndef(ndefName).set(param, val.linexp(inMin, inMax, outMin, outMax)) };
    };
};

// ✅ Create GUI
~win = Window("Ndef Control", Rect(100, 100, 400, 300)).front;
~layout = VLayout();

// ✅ GUI: Ndef Toggle Buttons & Indicators
~ndefNames = [\trigDrones, \fw, \stranga];
~toggleButtons = Dictionary.new;
~indicatorBoxes = Dictionary.new;

~ndefNames.do { |ndef|
    var h = HLayout();

    var button = Button()
        .states_([["Start " ++ ndef.asString], ["Stop " ++ ndef.asString]])
        .action_({ |b|
            if (b.value == 0) {
                Ndef(ndef).play;
                ~activeNdefs.put(ndef, true);
                ~indicatorBoxes.at(ndef).background_(Color.green);
            } {
                Ndef(ndef).end;
                ~activeNdefs.put(ndef, false);
                ~indicatorBoxes.at(ndef).background_(Color.red);
            }
        });

    var indicator = StaticText()
        .string_("●")
        .align_(\center)
        .font_(Font("Helvetica", 20))
        .background_(Color.red); // Default to off

    ~toggleButtons.put(ndef, button);
    ~indicatorBoxes.put(ndef, indicator);

    h.add(button);
    h.add(indicator);
    ~layout.add(h);
};

// ✅ GUI: Parameter Sliders (Fixed with Nested Dictionary)
~paramSliders = Dictionary.new;
~paramMappings = IdentityDictionary.new;
~paramMappings.put(\trigDrones, IdentityDictionary.new.put(\volume, [0, 1.2, \lin]).put(\speed, [0, 35, \lin]));
~paramMappings.put(\fw, IdentityDictionary.new.put(\volume, [0, 0.65, \lin]).put(\deviation, [5, 150, \lin]));
~paramMappings.put(\stranga, IdentityDictionary.new.put(\volume, [0, 1.5, \lin]).put(\speed, [0, 5, \lin]));

~paramMappings.keysValuesDo { |ndef, params|
    params.keysValuesDo { |param, range|
        var slider = Slider()
            .action_({ |s|
                Ndef(ndef).set(param, s.value.linlin(0, 1, range[0], range[1]));
            });

        // ✅ FIX: Ensure `~paramSliders[ndef]` exists before assigning a sub-key
        if (~paramSliders.at(ndef).isNil) {
            ~paramSliders.put(ndef, Dictionary.new);
        };
        ~paramSliders.at(ndef).put(param, slider);

        ~layout.add(HLayout(StaticText().string_(ndef.asString ++ "." ++ param.asString), slider));
    };
};

// ✅ Attach GUI layout
~win.layout_(~layout);

// ✅ OSC: Receive sensor data and update GUI indicators
OSCdef(\sensorData, { |msg|
    var val = msg[1];
    var which = msg[2];

    case
    { which == 1 } {  // Drones
        ~toggleNdefByValue.(\trigDrones, val, 0.05);
        ~mapSensorToParam.(\trigDrones, \volume, val, 0, 0.2, 0, 1.2, \lin);
        ~mapSensorToParam.(\trigDrones, \speed, val, 0.15, 1, 0, 35, \lin);
    }
    { which == 2 } {  // Strings
        ~toggleNdefByValue.(\fw, val, 0.02);
        ~mapSensorToParam.(\fw, \volume, val, 0, 0.1, 0, 0.65, \lin);
        ~mapSensorToParam.(\fw, \deviation, val, 0.4, 0.8, 5, 150, \lin);
    }
    { which == 3 } {  // Stranga
        ~toggleNdefByValue.(\stranga, val, 0.05);
        ~mapSensorToParam.(\stranga, \volume, val, 0, 0.05, 0, 1.5, \lin);
        ~mapSensorToParam.(\stranga, \speed, val, 0, 0.8, 0, 5, \lin);
    };

    // ✅ Update GUI indicators
    ~ndefNames.do { |ndef|
        if (~activeNdefs.at(ndef), {
            ~indicatorBoxes.at(ndef).background_(Color.green);
        }, {
            ~indicatorBoxes.at(ndef).background_(Color.red);
        });
    };
}, "/sensor/data");

)
