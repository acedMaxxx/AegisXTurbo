# Target 100MHz (10.0ns period)
set ::env(CLOCK_PERIOD) "5.0"

# Focus on speed (Delay) over Area
set ::env(SYNTH_STRATEGY) "DELAY 0"

# Don't pack the gates too tightly to allow faster routing
set ::env(PL_TARGET_DENSITY) 0.45
