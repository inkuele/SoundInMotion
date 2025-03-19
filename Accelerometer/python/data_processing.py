#%%

from pythonosc import dispatcher, osc_server, udp_client
import numpy as np
import threading
import math

# Configuration
DEBUG = True
SHORT_TERM_WINDOW = 5
LONG_TERM_WINDOW = 50
OSC_INPUT_PORT = 8000
OSC_OUTPUT_IP = "127.0.0.1"
OSC_OUTPUT_PORT = 9000
OSC_ADDRESS = "/accelerometer"

# Buffers for computing statistics
short_term_buffer = []
long_term_buffer = []
last_peak = 0  # SuperCollider's `lastPeak` equivalent

# OSC Client for sending processed data
client = udp_client.SimpleUDPClient(OSC_OUTPUT_IP, OSC_OUTPUT_PORT)

def compute_magnitude(x, y, z):
    """ Compute acceleration magnitude like SuperCollider """
    return np.sqrt(x**2 + y**2 + z**2)

def explin(value, in_min, in_max, out_min, out_max):
    """ Matches SuperCollider's explin: exponential scaling of values """
    if value <= in_min:
        return out_min
    elif value >= in_max:
        return out_max
    else:
        return (np.log(value / in_min)) / (np.log(in_max / in_min)) * (out_max - out_min) + out_min
        #return (np.log(value / in_min)) / (np.log(in_max / out_min)) * (out_max - out_min)
        #return out_min * ((out_max / out_min) ** (math.log(value / in_min) / math.log(in_max / in_min)))

def sensor_handler(address, *args):
    """ Handles incoming OSC messages and processes sensor data """
    global short_term_buffer, long_term_buffer, last_peak
    
    x, y, z = args[0], args[1], args[2]
    magnitude = compute_magnitude(x, y, z)

    # Store raw magnitude values in buffers
    short_term_buffer.append(magnitude)
    long_term_buffer.append(magnitude)

    if len(short_term_buffer) > SHORT_TERM_WINDOW:
        short_term_buffer.pop(0)
    if len(long_term_buffer) > LONG_TERM_WINDOW:
        long_term_buffer.pop(0)

    # Compute standard deviations
    short_std = np.std(short_term_buffer) if len(short_term_buffer) > 1 else 0
    long_std = np.std(long_term_buffer) if len(long_term_buffer) > 1 else 0

    # Apply scaling after computing standard deviation (matches SuperCollider)
    val = explin(short_std, 0.01, 0.7, 0, 1)
    longval = np.interp(long_std, [0.001, 0.7], [0, 1])

    # Update lastPeak logic
    if long_term_buffer:
        last_peak = max(long_term_buffer)

    # Debug output
    if DEBUG:
        print(f"Value: {val:.5f} | Last Peak: {last_peak:.5f} | LongVal: {longval:.5f}")

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


#%%

from pythonosc import dispatcher, osc_server, udp_client
import numpy as np
import threading

# Configuration
DEBUG = True
SHORT_TERM_WINDOW = 5
LONG_TERM_WINDOW = 50
OSC_INPUT_PORT = 8000
OSC_OUTPUT_IP = "127.0.0.1"
OSC_OUTPUT_PORT = 9000
OSC_ADDRESS = "/accelerometer"

# Buffers for computing statistics
short_term_buffer = []
long_term_buffer = []
last_peak = 0  # SuperCollider's `lastPeak` equivalent

# OSC Client for sending processed data
client = udp_client.SimpleUDPClient(OSC_OUTPUT_IP, OSC_OUTPUT_PORT)

def compute_magnitude(x, y, z):
    """ Compute acceleration magnitude like SuperCollider """
    return np.sqrt(x**2 + y**2 + z**2)

def explin(value, in_min, in_max, out_min, out_max):
    """ Matches SuperCollider's explin: exponential scaling of values """
    if value <= in_min:
        return out_min
    elif value >= in_max:
        return out_max
    else:
        return out_min + (out_max - out_min) * ((value - in_min) / (in_max - in_min))

def sensor_handler(address, *args):
    """ Handles incoming OSC messages and processes sensor data """
    global short_term_buffer, long_term_buffer, last_peak
    
    x, y, z = args[0], args[1], args[2]
    magnitude = compute_magnitude(x, y, z)

    # Store raw magnitude values in buffers
    short_term_buffer.append(magnitude)
    long_term_buffer.append(magnitude)

    if len(short_term_buffer) > SHORT_TERM_WINDOW:
        short_term_buffer.pop(0)
    if len(long_term_buffer) > LONG_TERM_WINDOW:
        long_term_buffer.pop(0)

    # Compute standard deviations
    short_std = np.std(short_term_buffer) if len(short_term_buffer) > 1 else 0
    long_std = np.std(long_term_buffer) if len(long_term_buffer) > 1 else 0

    # Apply scaling after computing standard deviation (matches SuperCollider)
    val = explin(short_std, 0.01, 0.7, 0, 1)
    longval = np.interp(long_std, [0.001, 0.7], [0, 1])

    # Update lastPeak logic
    if long_term_buffer:
        last_peak = max(long_term_buffer)

    # Debug output
    if DEBUG:
        print(f"Value: {val:.5f} | Last Peak: {last_peak:.5f} | LongVal: {longval:.5f}")

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


#%%

from pythonosc import dispatcher, osc_server, udp_client
import numpy as np
import threading

# Configuration
DEBUG = True
SHORT_TERM_WINDOW = 5
LONG_TERM_WINDOW = 50
OSC_INPUT_PORT = 8000
OSC_OUTPUT_IP = "127.0.0.1"
OSC_OUTPUT_PORT = 9000
OSC_ADDRESS = "/accelerometer"

# Buffers for computing statistics
short_term_buffer = []
long_term_buffer = []
last_peak = 0  # SuperCollider's `lastPeak` equivalent

# OSC Client for sending processed data
client = udp_client.SimpleUDPClient(OSC_OUTPUT_IP, OSC_OUTPUT_PORT)

def compute_magnitude(x, y, z):
    """ Compute acceleration magnitude like SuperCollider """
    return np.sqrt(x**2 + y**2 + z**2)

def explin(value, in_min, in_max, out_min, out_max):
    """ Matches SuperCollider's explin: exponential scaling of values """
    if value <= in_min:
        return out_min
    elif value >= in_max:
        return out_max
    else:
        return out_min + (out_max - out_min) * ((value - in_min) / (in_max - in_min))

def compute_statistics():
    """ Compute standard deviations and scale them like SuperCollider """
    global last_peak
    
    # Compute standard deviations
    short_std = np.std(short_term_buffer) if len(short_term_buffer) > 1 else 0
    long_std = np.std(long_term_buffer) if len(long_term_buffer) > 1 else 0
    
    # Match SuperCollider's `explin` for `val`
    val = explin(short_std, 0.01, 0.7, 0, 1)
    
    # Match SuperCollider's `linlin` for `longval`
    longval = np.interp(long_std, [0.001, 0.7], [0, 1])  # linlin is just linear mapping

    # Update lastPeak logic
    if long_term_buffer:
        last_peak = max(last_peak, max(long_term_buffer))

    return val, longval, last_peak

def sensor_handler(address, *args):
    """ Handles incoming OSC messages and processes sensor data """
    global short_term_buffer, long_term_buffer
    
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
        print(f"Value: {val:.5f} | Last Peak: {last_peak:.5f} | LongVal: {longval:.5f}")

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
