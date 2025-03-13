(

var w, amp, freq, csAmp, csFreq, sender;
sender = NetAddr("127.0.0.1", 57120);
sender.sendMsg("/start", 1);
w=FlowView.new(windowTitle:"Send OSC", bounds:Rect(400,500,400, 500));


i = EZListView.new(w,
    300@150,
    "Sample1:",
    [
        "szene 0" ->{ |a| sender.sendMsg("/szene", 0); },
        "szene 1" ->{ |a| sender.sendMsg("/szene", 1); },
        "szene 2" ->{ |a| sender.sendMsg("/szene", 2); },
        "szene 0" ->{ |a| sender.sendMsg("/szene", 0); },
        "szene 3" ->{ |a| sender.sendMsg("/szene", 3); },
        "szene 4" ->{ |a| sender.sendMsg("/szene", 4); },
        "szene 5" ->{ |a| sender.sendMsg("/szene", 5); },
        "szene 0" ->{ |a| sender.sendMsg("/szene", 0); },


    ],
   // globalAction: { |a| ("this is a global action of "++a.asString ).postln },
    initVal: 2,
    initAction: true,
    labelWidth: 100,
    labelHeight: 30,
    layout: \vert,
    gap: 2@2
    );


w.front;

)

