===========
ArduinoPure
===========

Copyright (c) 2012-2013, Daniel Bugl. All rights reserved.
BSD open-source licensed, see LICENSE for further information.

Folder structure (new)
----------------------

- preconf/ - Preconfigured Makefiles for specific Arduino boards (eg, Arduino Uno) and programmer/chip combinations (eg, stk500 and atmega8)
- templates/ - Makefile templates: Makefile.arduino for Arduino projects and Makefile.general for other projects.


Trying out ArduinoPure on an Arduino Uno
----------------------------------------

Note: All the Makefiles in the current repository have been tested and should work (besides the Makefile.general and Makefile.arduino file, those are templates). If something doesn't work for you, please open an issue report and I'll try to resolve this with you.

0. Download ArduinoPure and cd into the directory.
1. Run "make -o preconf/Makefile.arduino_uno" (for other setups, specify the right Makefile in the -o option)
2. Run "make -o preconf/Makefile.arduino_uno upload" (again, specify the right Makefile in the -o option if you have a different setup than the Arduino Uno connected via USB)


Creating a new project with ArduinoPure
---------------------------------------

0. Copy ArduinoPure into your project directory
1. Copy the right makefile to "Makefile". Example: cp ./Makefile.stk500_atmega ./Makefile
2. (Optional) To keep your project directory clean, delete the other Makefiles. You can also remove the main.cpp test file.
3. Open up the Makefile file with an editor and change the project name (main) and source files (main.cpp)
4. Run "make" to compile the project
5. Run "make upload" to upload the compiled hex code to your microcontroller.


Hacking ArduinoPure
-------------------

If you want to do more with ArduinoPure, you need to modify the Makefile.
For Arduino projects, please edit the first few lines of the Makefile.arduino file
For other projects (especially those that use the STK500, because its default configuration is to use the stk500 programmer), please edit the first few lines of the Makefile.general file.
