MCU=atmega8 # Select your MCU here.
CPU=8000000L # 8 MHz (internal clock of atmega8)
SOURCES_PROJECT=main.cpp # Add project source files here
PROJECT_NAME=main # result will be main.hex, then
PROGRAMMER=stk500 # set your programmer here, I use the stk500. On the standard arduino isp it's "arduino"
PORT=/dev/ttyUSB0 # set the port for the connection to your programmer here. Mine is the virtual serial port /dev/ttyUSB0 (adapter)
BAUDRATE=115200

CC=./tools/avr/bin/avr-gcc
CCP=./tools/avr/bin/avr-g++
AR=./tools/avr/bin/avr-ar rcs
OBJ=./tools/avr/bin/avr-objcopy
AVRDUDE=./tools/avrdude
AVRDUDEFLAGS=-c$(PROGRAMMER) -p$(MCU) -P$(PORT) -C./tools/avrdude.conf -b$(BAUDRATE)
EEPFLAGS=-O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0
HEXFLAGS=-O ihex -R .eeprom
CFLAGS=-c -g -Os -Wall -fno-exceptions -ffunction-sections -fdata-sections -mmcu=$(MCU) -DF_CPU=$(CPU) -MMD -DUSB_VID=null -DUSB_PID=null -DARDUINO=101 -I./arduino -I./arduino/variants/standard
LDFLAGS=-Os -Wl,--gc-sections -mmcu=$(MCU) -L./arduino -L./ -lm
ARFILE=arduino/core.a
OBJECTS_PROJECT=$(SOURCES_PROJECT:.cpp=.o)
SOURCES_ARDUINO_C=arduino/wiring_digital.c arduino/WInterrupts.c arduino/wiring_pulse.c arduino/wiring_analog.c arduino/wiring.c arduino/wiring_shift.c
OBJECTS_ARDUINO_C=$(SOURCES_ARDUINO_C:.c=.o)
SOURCES_ARDUINO_CPP=arduino/CDC.cpp arduino/Stream.cpp arduino/HID.cpp arduino/Tone.cpp arduino/WMath.cpp arduino/WString.cpp arduino/new.cpp arduino/main.cpp arduino/HardwareSerial.cpp arduino/IPAddress.cpp arduino/Print.cpp arduino/USBCore.cpp
OBJECTS_ARDUINO_CPP=$(SOURCES_ARDUINO_CPP:.cpp=.o)
OBJECTS=$(OBJECTS_PROJECT) $(OBJECTS_ARDUINO_C) $(OBJECTS_ARDUINO_CPP)
OBJECTS_CORE=$(OBJECTS_ARDUINO_C) $(OBJECTS_ARDUINO_CPP)
ELFCODE=$(join $(PROJECT_NAME),.elf)
EEPCODE=$(join $(PROJECT_NAME),.eep)
HEXCODE=$(join $(PROJECT_NAME),.hex)

$(ARFILE): $(OBJECTS)
	$(AR) $(ARFILE) $(OBJECTS)

.cpp.o:
	$(CC) $(CFLAGS) $< -o $@

$(ELFCODE): 
	$(CC) $(LDFLAGS) $(OBJECTS_PROJECT) $(ARFILE) -o $@

$(EEPCODE):
	$(OBJ) $(EEPFLAGS) $(ELFCODE) $@

$(HEXCODE):
	$(OBJ) $(HEXFLAGS) $(ELFCODE) $@

all: $(SOURCES) $(ARFILE) $(ELFCODE) $(EEPCODE) $(HEXCODE)

clean_obj:
	rm -rf $(OBJECTS) $(ARFILE)

clean_results:
	rm -rf $(ELFCODE) $(EEPCODE) $(HEXCODE)

clean: clean_obj clean_results

upload:
	$(AVRDUDE) $(AVRDUDEFLAGS) -Uflash:w:$(HEXCODE):i
