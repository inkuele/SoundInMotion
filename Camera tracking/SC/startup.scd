
//Server.supernova;
Server.scsynth;
//s.options.threads = 4;
s.recHeaderFormat= "wav";

s.options.memSize = 1024 * 1024 * 2; // 4gb
s.latency = 0.2;
s.options.maxNodes = 1024 * 64;
s.options.maxSynthDefs = 1024 * 16;

Server.default.options.numBuffers_(8192);

s.options.hardwareBufferSize = 256;
s.options.sampleRate = 48000;
s.options.numOutputBusChannels = 4;
s.options.numInputBusChannels = 4;

s.options.numWireBufs = 256;

// s.waitForBoot();