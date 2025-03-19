#%%

import argparse
import time
from pythonosc import udp_client

# Configuration
OSC_IP = "192.168.2.45"
OSC_PORT = 8000  # Ensure this matches the dynamically assigned port from the main script
OSC_ADDRESS = "/accelerometer"

# Predefined sequence of 10 (x, y, z) values
SEQUENCE = [
    (0.1, -0.2, 0.3),
    (0.4, -0.5, 0.6),
    (0.7, -0.8, 0.9),
    (-0.1, 0.2, -0.3),
    (-0.4, 0.5, -0.6),
    (-0.7, 0.8, -0.9),
    (0.2, -0.1, 0.4),
    (-0.2, 0.3, -0.5),
    (0.5, -0.4, 0.6),
    (-0.6, 0.7, -0.8)
]

# Create the OSC client
client = udp_client.SimpleUDPClient(OSC_IP, OSC_PORT)

def send_osc_sequence():
    """Sends the predefined sequence of 10 accelerometer values once, then stops."""
    for x, y, z in SEQUENCE:
        client.send_message(OSC_ADDRESS, [x, y, z])
        print(f"Sent OSC Data: X={x:.3f}, Y={y:.3f}, Z={z:.3f}")
        time.sleep(0.5)  # Slower pulse (0.5 seconds)

    print("Sequence completed. Exiting.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="OSC Data Sender (Single Sequence)")
    parser.add_argument("--port", type=int, default=OSC_PORT, help="OSC Input Port")
    args = parser.parse_args()
    
    OSC_PORT = args.port  # Allow user to specify port dynamically

    print(f"Sending predefined OSC sequence to {OSC_IP}:{OSC_PORT} every 0.5 seconds...")
    send_osc_sequence()

# %%
