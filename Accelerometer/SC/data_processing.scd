(
/////////////////////////////////////////////////////
// Initialize Variables and Sensor Data Processing //
/////////////////////////////////////////////////////

var debug = 1,                 // Debug flag: Set to 1 to print values, 0 to disable.
    stlen = 5,                 // Short-term window length (used for quick variations).
    ltlen = 50,                // Long-term window length (used for more stable trends).
    speedxyz = SensorData.new;  // Create a new SensorDataExt object to track movement data.

speedxyz.stlen_(stlen);        // Set the short-term window size.
speedxyz.ltlen_(ltlen);        // Set the long-term window size.

~sound = 0;  // Placeholder variable, likely used later for sound mapping.

/////////////////////////////////////////////////////////////
// Function to Process Incoming Accelerometer Data (XYZ)  //
/////////////////////////////////////////////////////////////

~processSensorData = { |msg|
    var xyz, val, longval, lastPeak;

    // Compute the magnitude of acceleration (Pythagorean theorem)
    // This combines the x, y, and z components into a single movement intensity value.
    xyz = (pow(msg[1], 2) + pow(msg[2], 2) + pow(msg[3], 2)).sqrt;

    // Add the computed movement value to our sensor tracking object.
    speedxyz.addValue(xyz);

    // Compute the short-term standard deviation (measures quick fluctuations).
    // The `explin` function scales values exponentially from [0.001, 0.7] → [0, 1].
    val = speedxyz.shortStdDev.explin(0.01, 10, 0, 1);

    // Compute the long-term standard deviation (measures gradual changes).
    // The `linlin` function scales values linearly from [0.001, 0.7] → [0, 1].
    longval = speedxyz.longStdDev.linlin(0.02, 8, 0.0, 1);

    // Get the last detected peak movement.
    lastPeak = speedxyz.lastPeak;

    // Debugging: Print the computed values.
    if (debug == 1) {
        ("Value: " ++ val ++ " | Last Peak: " ++ lastPeak[0] ++ " | LongVal: " ++ longval).postln;
    };

    // Return computed values as an array.
	// [val, longval, lastPeak[0]];
	[val];
};

///////////////////////////////////////////////////////////
// Load Additional Processing Logic (Data Selection)    //
///////////////////////////////////////////////////////////

// Load an external script that likely defines how sound mappings work.
(thisProcess.nowExecutingPath.dirname ++ "/data_selection.scd").load;

//////////////////////////////////////////////////////////
// Define OSC Listener for Incoming Sensor Data        //
//////////////////////////////////////////////////////////

OSCdef(\minibeeRouter, { |msg|
    var sensorID = msg[1]; // Extract the sensor ID from the message.
    var data;

    // Process the incoming sensor data.
    data = ~processSensorData.(msg);
	~data = data;

    // Debugging: Print raw sensor message and processed data.
    if (debug == 1) {
        ("msg: " ++ msg).postln;
        ("data: " ++ data).postln;
    };

    // Call a function (likely from `data_selection.scd`) to map sensor data to sound.
    ~data_sel.value(data[0], data[1], ~sound);

}, "/accelerometer", nil, 9000 ).permanent_(false); // Listens to messages from Sensors2OSC app.
)

~sound = 5
//////////////////////////////////////////////
// Cleanup: Free Unused OSC Definitions    //
//////////////////////////////////////////////

// Free the existing OSC handler for "/accelerometer" if it exists.
OSCdef(\minibeeRouter).free;

// Define a simple test OSC handler to print incoming values from "/accelerometer".
OSCdef(\test).free;
OSCdef(\test, { |msg| msg.postln }, '/accelerometer', nil, 8000);

s.freeAll