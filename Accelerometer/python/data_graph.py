#%%

import pyqtgraph as pg
from pyqtgraph.Qt import QtWidgets
import numpy as np
import collections
import threading
import signal
import sys
from pythonosc import dispatcher, osc_server

# Configuration
OSC_INPUT_PORT = 9000
OSC_ADDRESS = "/processed_data"

# Data storage
BUFFER_SIZE = 100
val_buffer = collections.deque([0] * BUFFER_SIZE, maxlen=BUFFER_SIZE)
longval_buffer = collections.deque([0] * BUFFER_SIZE, maxlen=BUFFER_SIZE)
last_peak_buffer = collections.deque([0] * BUFFER_SIZE, maxlen=BUFFER_SIZE)

# Global variable for the OSC server
server = None

def osc_handler(address, *args):
    """Handles incoming OSC messages and updates buffers."""
    val, longval, last_peak = args[0], args[1], args[2]
    val_buffer.append(val)
    longval_buffer.append(longval)
    last_peak_buffer.append(last_peak)

def start_osc_server():
    """Starts the OSC server to listen for incoming messages."""
    global server
    disp = dispatcher.Dispatcher()
    disp.map(OSC_ADDRESS, osc_handler)
    server = osc_server.ThreadingOSCUDPServer(("0.0.0.0", OSC_INPUT_PORT), disp)
    print(f"Listening for OSC messages on port {OSC_INPUT_PORT}...")
    server.serve_forever()

# Start OSC server in a separate thread
t = threading.Thread(target=start_osc_server, daemon=True)
t.start()

# Set up PyQtGraph
app = QtWidgets.QApplication([])
win = pg.GraphicsLayoutWidget(show=True, title="Real-time OSC Data")
plot = win.addPlot(title="OSC Data")
curve1 = plot.plot(pen='r', name="val")
curve2 = plot.plot(pen='g', name="longval")
curve3 = plot.plot(pen='b', name="last_peak")

def update():
    """Update the plot with new data."""
    x = np.arange(BUFFER_SIZE)
    curve1.setData(x, list(val_buffer))
    curve2.setData(x, list(longval_buffer))
    curve3.setData(x, list(last_peak_buffer))

timer = pg.QtCore.QTimer()
timer.timeout.connect(update)
timer.start(50)  # Refresh every 50ms

def graceful_exit(signum, frame):
    """Handles Ctrl+C to close the application properly."""
    print("\nShutting down OSC server and closing application...")
    
    # Stop the OSC server
    if server:
        server.shutdown()
    
    # Close the Qt application
    app.quit()
    sys.exit(0)

# Capture Ctrl+C to exit cleanly
signal.signal(signal.SIGINT, graceful_exit)

# Start the Qt application loop
try:
    QtWidgets.QApplication.instance().exec_()
except KeyboardInterrupt:
    graceful_exit(None, None)



# %%
