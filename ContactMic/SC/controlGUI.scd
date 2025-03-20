(

var w, amp, freq, csAmp, csFreq, sender, soundSel, granSel, sensitivity, sensitivityNB, looper, spec;
sender = NetAddr("127.0.0.1", 57120);
sender.sendMsg("/start", 1);
w=FlowView.new(windowTitle:"Korpus GUI", bounds:Rect(400,500,400, 400));
spec = ControlSpec(1.5, 0.05, \linear, 0.01, 1.0);
sensitivityNB = NumberBox(w, Rect(20, 20, 150, 20));
sensitivity = EZSlider(w, Rect(20, 60, 30, 200), "Sensitivity", spec,
	{ |ez| ~sensitivity = ez.value.asInteger; sensitivityNB.value_(ez.value); },
	layout: \vert,);

soundSel = EZListView.new(w,
	300@150,
	"Sample1:",
	[
		"sound 0, no sound" ->{  ~sound = 0; },
		"sound 1, ~fw" ->{  ~sound = 1; },
		"sound 2, ~trigDrones" ->{  ~sound = 2; },
		"sound 3, ~stranga" ->{  ~sound = 3; },


	],
	// globalAction: { |a| ("this is a global action of "++a.asString ).postln },
	initVal: ~sound,  initAction: true, labelWidth: 100, labelHeight: 30, layout: \vert,gap: 2@2
);


w.front;

)
