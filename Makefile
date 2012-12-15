MCU=atmega8
CPU=8000000L # 8 MHz (internal clock of atmega8)

CC=./tools/avr/bin/avr-gcc
CCP=./tools/avr/bin/avr-g++
AR=./tools/avr/bin/avr-ar rcs
OBJ=./tools/avr/bin/avr-objcopy
EEPFLAGS=-O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0
HEXFLAGS=-O ihex -R .eeprom
CFLAGS=-c -g -Os -Wall -fno-exceptions -ffunction-sections -fdata-sections -mmcu=$(MCU) -DF_CPU=$(CPU) -MMD -DUSB_VID=null -DUSB_PID=null -DARDUINO=101 -I./arduino -I./arduino/variants/standard
LDFLAGS=-Os -Wl,--gc-sections -mmcu=$(MCU) -L./arduino -L./ -lm
ARFILE=arduino/core.a
SOURCES_PROJECT=main.cpp
OBJECTS_PROJECT=$(SOURCES_PROJECT:.cpp=.o)
SOURCES_ARDUINO_C=arduino/wiring_digital.c arduino/WInterrupts.c arduino/wiring_pulse.c arduino/wiring_analog.c arduino/wiring.c arduino/wiring_shift.c
OBJECTS_ARDUINO_C=$(SOURCES_ARDUINO_C:.c=.o)
SOURCES_ARDUINO_CPP=arduino/CDC.cpp arduino/Stream.cpp arduino/HID.cpp arduino/Tone.cpp arduino/WMath.cpp arduino/WString.cpp arduino/new.cpp arduino/main.cpp arduino/HardwareSerial.cpp arduino/IPAddress.cpp arduino/Print.cpp arduino/USBCore.cpp
OBJECTS_ARDUINO_CPP=$(SOURCES_ARDUINO_CPP:.cpp=.o)
OBJECTS=$(OBJECTS_PROJECT) $(OBJECTS_ARDUINO_C) $(OBJECTS_ARDUINO_CPP)
OBJECTS_CORE=$(OBJECTS_ARDUINO_C) $(OBJECTS_ARDUINO_CPP)
ELFCODE=main.elf
EEPCODE=main.eep
HEXCODE=main.hex

all: $(SOURCES) $(ARFILE) $(ELFCODE) $(EEPCODE) $(HEXCODE)

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
