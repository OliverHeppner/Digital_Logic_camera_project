This is code to use for the project. If you just want to test the display, 
it's in the "simpler_code.tar" file.
Change to *.sv types
1. HDMI_info.sv
2. stripe_writer.sv  --> *********Replace with your code*********
3. HDMout.sv
4. hdmi_top.sv

>> From GitHub:
5. rgb2dvi — HDMI encoder and supporting modules

>> IP
6. clk_wiz_0 — Clocking Wizard IP (100 MHz → 25 MHz)
7. HDMI_data — Block Memory Generator IP (8-bit × 2304, simple dual-port)

>> XDC file (Please check)
8. hdmi_top.xdc — Pin and timing constraints

Top module: hdmi_top