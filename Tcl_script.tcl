# Setup pin setting for EP4C6_ board 
set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED" 

set_location_assignment PIN_23 -to clk

#set_location_assignment PIN_38 -to LED_OUT[3]
#set_location_assignment PIN_33 -to LED_OUT[2]
#set_location_assignment PIN_31 -to LED_OUT[1]
#set_location_assignment PIN_28 -to LED_OUT[0]

set_location_assignment PIN_135 -to SEG_LED[6]
set_location_assignment PIN_136 -to SEG_LED[5]
set_location_assignment PIN_137 -to SEG_LED[4]
set_location_assignment PIN_138 -to SEG_LED[3]
set_location_assignment PIN_141 -to SEG_LED[2]
set_location_assignment PIN_142 -to SEG_LED[1]
set_location_assignment PIN_143 -to SEG_LED[0]
set_location_assignment PIN_144 -to segdot


set_location_assignment PIN_1 -to SEG_NCS[0]
set_location_assignment PIN_2 -to SEG_NCS[1]
set_location_assignment PIN_3 -to SEG_NCS[2]
set_location_assignment PIN_129 -to SEG_NCS[3]
set_location_assignment PIN_132 -to SEG_NCS[4]
set_location_assignment PIN_133 -to SEG_NCS[5]


set_location_assignment PIN_30 -to key1
set_location_assignment PIN_32 -to key2
set_location_assignment PIN_34 -to key3
set_location_assignment PIN_39 -to key4
set_location_assignment PIN_43 -to key5
set_location_assignment PIN_46 -to key6
set_location_assignment PIN_50 -to key7
set_location_assignment PIN_52 -to key8
