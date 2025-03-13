(
//
/*
Szene1  5 ligeti with preset 3 oscar (granular like)
Szene2a oder übergang 3-4 7 pad with wind oscar, preset 3, side 2
Szene2b 1 ibeat with?
Szene3 6 beat, 9 drC
Szene4 solo 8
übergang? 3 granular with bass oscar, preset 1
Szene5 solo 12
*/
OSCdef( \controlSzene, { |msg|
	var res;
		//msg.postln;

	res = case
	{msg[1] == 0}{
		~minibee1 = 0;
		~minibee2 = 0;
		~minibee3 = 0;
		~minibee4 = 0;
		~oscar.sendMsg("/sound", 0);
		~oscar.sendMsg("/minibee", 0);

("/Users/marcello/Music/Supercollider/pdw/minibees/zeroVol.scd").load;
	}
	{msg[1] == 1}{
	~minibee1 = 0;
		~minibee2 = 5;
		~minibee3 = 0;
		~minibee4 = 0;
		~oscar.sendMsg("/sound", 2);
		~oscar.sendMsg("/minibee", 3);

("/Users/marcello/Music/Supercollider/pdw/minibees/zeroVol.scd").load;
	}

	{msg[1] == 2}{
	~minibee1 = 0;
		~minibee2 = 9;
		~minibee3 = 0;
		~minibee4 = 0;

		~oscar.sendMsg("/sound", 1);
		~oscar.sendMsg("/minibee", 3);

("/Users/marcello/Music/Supercollider/pdw/minibees/zeroVol.scd").load;
	}


	{msg[1] == 3}{
	~minibee1 = 0;
		~minibee2 = 7;
		~minibee3 = 0;
		~minibee4 = 0;

		~oscar.sendMsg("/sound", 4);
		~oscar.sendMsg("/minibee", 3);

("/Users/marcello/Music/Supercollider/pdw/minibees/zeroVol.scd").load;
	}
	{msg[1] == 4}{
	~minibee1 = 11;
		~minibee2 = 0;
		~minibee3 = 10;
		~minibee4 = 8;

		~oscar.sendMsg("/sound", 3);
		~oscar.sendMsg("/minibee", 3);

("/Users/marcello/Music/Supercollider/pdw/minibees/zeroVol.scd").load;
	}
		{msg[1] == 5}{
	~minibee1 = 0;
		~minibee2 = 0;
		~minibee3 = 6;
		~minibee4 = 0;

		~oscar.sendMsg("/sound", 3);
		~oscar.sendMsg("/minibee", 4);

("/Users/marcello/Music/Supercollider/pdw/minibees/zeroVol.scd").load;
	}

	{msg[1] == 6}{
	~minibee1 = 0;
		~minibee2 = 0;
		~minibee3 = 0;
		~minibee4 = 3;

		~oscar.sendMsg("/sound", 1);
		~oscar.sendMsg("/minibee", 3);

("/Users/marcello/Music/Supercollider/pdw/minibees/zeroVol.scd").load;


	}
	{msg[1] == 4}{ // ibeat

	~minibee1 = 0;
		~minibee2 = 0;
		~minibee3 = 1;
		~minibee4 = 0;

		~oscar.sendMsg("/sound", 3);
~oscar.sendMsg("/minibee", 4);

("/Users/marcello/Music/Supercollider/pdw/minibees/zeroVol.scd").load;
	}


	{msg[1] == 8}{
	~minibee1 = 0;
		~minibee2 = 0;
		~minibee3 = 0;
		~minibee4 = 12;

		~oscar.sendMsg("/sound", 0);
		~oscar.sendMsg("/minibee", 0);

("/Users/marcello/Music/Supercollider/pdw/minibees/zeroVol.scd").load;
	};
}, "/szene", nil, 57120 );

);
/*
n = NetAddr("127.0.0.1", 57120);
n.sendMsg("/szene", 0);

n.sendMsg("/szene", 1);
~fw.set(\scale_val, (Scale.bartok.ratios.choose * 0.8 * 1).postln)

// first body contact
n.sendMsg("/szene", 2);
~drC.set(\freq_scale, (Scale.bartok.ratios.choose * 0.7 * 2).postln);
// hands together on top of each other.
n.sendMsg("/szene", 0);
// dreamy
n.sendMsg("/szene", 3);
~pad.set(\scale_freq, 0.5);

~pad.set(\scale_freq, (Scale.bartok.ratios.choose * 0.7).postln);

// 2 beat scenes
n.sendMsg("/szene", 4);
n.sendMsg("/szene", 5);

n.sendMsg("/szene", 6);
~gran1.set( \pos, ~samples_data[~sample_id][8].choose);
~gran1.set( \rate, (Scale.bartok.ratios.choose * 0.5).postln);

//2 solos
n.sendMsg("/szene", 7);
~stranga.set(\pitch, (Scale.bartok.ratios.choose * 0.4).postln);
~stranga.set(\pitch, 0.5993228307497); // tief
~stranga.set(\pitch, 0.67347722898531); // mitte
~stranga.set(\pitch, 0.84534797668457); // hoch
~stranga.set(\pitch, 1.048814953812); // sehr hoch
Scale.bartok.ratios * 0.7
	~stranga.get(\pitch)
	~oscar.sendMsg("/sound", 4);
n.sendMsg("/szene", 8);
		~oscar.sendMsg("/sound", 0);



1. ligeti louder
3. pad has to move more dynamically

4. both sounds quieter, especially at the beginning

5. complexB, quick movement generates clicks

2.
*/
