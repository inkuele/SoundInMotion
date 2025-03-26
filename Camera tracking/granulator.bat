@echo off
rem Set the path to your SuperCollider installation (update this if necessary)
set SC_PATH="C:\Program Files\SuperCollider-3.13.0"  rem Adjust to match your SC path

rem Set the path to the patch file
set PATCH_PATH="C:\Users\ziw-i\Desktop\Workshop\7_framedifference_sound\SC\granulator.scd"  rem Adjust to the location of your patch file

rem Change to the SuperCollider directory
cd "C:\Program Files\SuperCollider-3.13.0"

rem Launch SuperCollider with the patch file
"C:\Program Files\SuperCollider-3.13.0\sclang.exe" %PATCH_PATH%

