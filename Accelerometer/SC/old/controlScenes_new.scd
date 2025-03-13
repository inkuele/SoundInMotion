(
var sender;
sender = NetAddr("127.0.0.1", 57120);
// vertical
w=FlowView.new(windowTitle:"Send OSC", bounds:Rect(400,500,400, 500));
a = SelectButtonSet(
    w,
        ["Szene 0", "Szene 1", "Szene 2", "Szene 0", "Szene 3", "Szene 4", "Szene 5", "Szene 0"],
        {arg selectedIndex,selectButtonSet;
		sender.sendMsg("/szene", selectButtonSet.labelArray[selectedIndex][6..].asInt.postln);},
        width: 100, height: 40
    );

)
