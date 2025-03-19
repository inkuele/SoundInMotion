(

var w, amp, freq, csAmp, csFreq, sender, soundSel, granSel, sensitivity, sensitivityNB, looper, spec;
sender = NetAddr("127.0.0.1", 57120);
sender.sendMsg("/start", 1);
w=FlowView.new(windowTitle:"Korpus GUI", bounds:Rect(400,500,400, 800));
spec = ControlSpec(3.0, 0.05, \linear, 0.01, 1.3);
sensitivityNB = NumberBox(w, Rect(20, 20, 150, 20));
sensitivity = EZSlider(w, Rect(20, 60, 30, 200), "Sensitivity", spec,
	{ |ez| ~sensitivity = ez.value.asString; sensitivityNB.value_(ez.value); },
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

granSel = EZListView.new(w,
	300@300,
	"gran sample:",
	initVal: 2,  initAction: true, labelWidth: 100, labelHeight: 30, layout: \vert,gap: 2@2
);


(~b.size-1).do{|i| granSel.addItem(~b[i].path.basename, {|a| ~sample_id1 = i;})};
granSel.addItem("Live Looping", {~sample_id1 = ~b[~b.size-1].bufnum});

looper = EZListView.new(w,
	300@300,
	"Looper:",
		[
		"Play" ->{ |a| ~looper.set(\loop_play,1, \loop_rec, 0, \reclevel, 0,\prelevel, 1); },
		"Overdub" ->{ |a| ~looper.set(\loop_play,1, \loop_rec, 1, \reclevel, 0.5,\prelevel, 0.5);  },
		"Rec" ->{ |a| ~looper.set(\loop_play,1, \loop_rec, 1, \reclevel, 1,\prelevel, 0); },

	],
	initVal: 2,  initAction: true, labelWidth: 100, labelHeight: 30, layout: \vert,gap: 2@2
);


w.front;

)
