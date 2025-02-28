#%%

from pythonosc import dispatcher, osc_server, udp_client
import numpy as np
import threading

# Configuration
DEBUG = True
SHORT_TERM_WINDOW = 5
LONG_TERM_WINDOW = 50
OSC_INPUT_PORT = 9000
OSC_OUTPUT_IP = "127.0.0.1"
OSC_OUTPUT_PORT = 8000
OSC_ADDRESS = "/accelerometer"

# Buffers for computing statistics
short_term_buffer = []
long_term_buffer = []

# OSC Client for sending processed data
client = udp_client.SimpleUDPClient(OSC_OUTPUT_IP, OSC_OUTPUT_PORT)

def compute_magnitude(x, y, z):
    return np.sqrt(x**2 + y**2 + z**2)

def compute_statistics():
    short_std = np.std(short_term_buffer) if len(short_term_buffer) > 1 else 0
    long_std = np.std(long_term_buffer) if len(long_term_buffer) > 1 else 0
    
    # Scale values (adjusted to fit the SuperCollider mapping)
    val = np.interp(short_std, [0.01, 0.7], [0, 1])
    longval = np.interp(long_std, [0.001, 0.7], [0, 1])
    
    last_peak = max(long_term_buffer) if long_term_buffer else 0
    return val, longval, last_peak

def sensor_handler(address, *args):
    global short_term_buffer, long_term_buffer
    
    # Extract XYZ acceleration values from OSC message
    x, y, z = args[0], args[1], args[2]
    magnitude = compute_magnitude(x, y, z)
    
    # Update buffers
    short_term_buffer.append(magnitude)
    long_term_buffer.append(magnitude)
    
    if len(short_term_buffer) > SHORT_TERM_WINDOW:
        short_term_buffer.pop(0)
    if len(long_term_buffer) > LONG_TERM_WINDOW:
        long_term_buffer.pop(0)
    
    # Compute statistics
    val, longval, last_peak = compute_statistics()
    
    # Debug output
    if DEBUG:
        print(f"Value: {val} | Last Peak: {last_peak} | LongVal: {longval}")
    
    # Send processed data via OSC
    client.send_message("/processed_data", [val, longval, last_peak])

def start_osc_server():
    disp = dispatcher.Dispatcher()
    disp.map(OSC_ADDRESS, sensor_handler)
    server = osc_server.ThreadingOSCUDPServer(("0.0.0.0", OSC_INPUT_PORT), disp)
    print(f"Listening for OSC messages on port {OSC_INPUT_PORT}...")
    server.serve_forever()

# Run the OSC server in a separate thread
t = threading.Thread(target=start_osc_server, daemon=True)
t.start()

print("OSC processing script is running...")

# %%
