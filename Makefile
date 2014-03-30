test: testled.hex
	avrdude  -c buspirate -P /dev/ttyUSB0 -p t2313 -U flash:w:testled.hex:i
	avrdude  -c buspirate -P /dev/ttyUSB0 -p t2313 -U lfuse:w:0xed:m

testled.o: test_led_2313.c
	avr-gcc -mmcu=attiny2313 -g -Os test_led_2313.c -o testled.o

testled.hex: testled.o
	avr-objcopy -j .text -j .data -O ihex testled.o testled.hex

upload:
	avrdude  -c buspirate -P /dev/ttyUSB0 -p t2313 -U flash:w:pong2313.hex:i
	avrdude  -c buspirate -P /dev/ttyUSB0 -p t2313 -U lfuse:w:0xed:m