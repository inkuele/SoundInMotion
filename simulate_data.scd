
(
~oscTarget = NetAddr("127.0.0.1", 8000); // Send to local machine

~accelRoutine = Routine({
    var x = 0, y = 0, z = 0, debug = 0, movementChance = 0.5;
    loop {
        if (movementChance.coin, {  // 20% chance of movement
            x = 0.000001.exprand(1.0)
;  // Random movement in full range
            y = 0.000001.exprand(1.0)
;
            z = 0.000001.exprand(1.0)
;
        }, {
            // Stay steady with slight natural noise
            x = 0.001.rand;
            y = 0.001.rand;
            z = 0.001.rand;
		});

		if (debug == 1) {
            ("x | y | z : " ++ x ++ " | " ++ y ++ " | " ++ z).postln;
        };

        // Send OSC message
        ~oscTarget.sendMsg("/accelerometer", x, y, z);

        // Schedule next execution
        0.05.wait; // Adjust timing as needed (e.g., 50ms for ~20Hz)
    }
}).play;
)

// To stop the routine
~accelRoutine.stop;
