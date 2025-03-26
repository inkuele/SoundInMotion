#!/bin/bash

# Set the path to your SuperCollider installation (if it's not in the default PATH)
# For most Linux/Mac installations, sclang should be in the PATH already.
# If not, uncomment and set this to the appropriate path:
# export PATH=$PATH:/path/to/supercollider/bin

# Set the path to the patch file
PATCH_PATH="/home/marcello_ink/MEGA/SuperCollider/Inkuele/granular05_gui.scd"  # Adjust to the location of your patch file


# Launch SuperCollider and execute the patch file
sclang "$PATCH_PATH"

