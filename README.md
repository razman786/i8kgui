# i8kgui

## Introduction

A simple system tray GUI to display useful information from [i8kutils](https://github.com/vitorafsr/i8kutils) - created
as a quick hack for my own needs.

<p align="center">
  <img src="https://user-images.githubusercontent.com/7116312/154058543-3d65039e-77d3-4a39-b106-ab3de15925ef.png" alt="i8k" width="150" />
  <img src="https://user-images.githubusercontent.com/7116312/154058627-90e3abe7-258f-4c23-bf88-85d1ae04645f.png" alt="bios"width="150" />
  <img src="https://user-images.githubusercontent.com/7116312/154058677-ee7d8858-6cfa-48a8-8dff-f813439bec64.png" alt="settings" width="250" />
  <img src="https://user-images.githubusercontent.com/7116312/153890711-452b82ff-dc22-437e-b541-a651064d9b23.png" alt="info" width="250" />
</p>

i8kgui uses i8kutils to gather information such as CPU temperature and fan speeds. It attempts to only update GUI values
when visibly active, and also supports thermal management using (SM)BIOS modes.

### Features

* Displays CPU temperature, fan speeds and fan modes from i8kutils
* Displays the current CPU frequency
* Shows the currently active i8kutils configuration being used
* Supports (SM)BIOS thermal management modes
* Displays i8k module information
* Supports the gathering of (SM)BIOS information
* Option to display CPU frequency as either the highest (default) or the average value for all CPU cores
* Only updates the GUI values when visibly active

## Prerequisites

This version has only been tested on Ubuntu 20.04 and with a Dell laptop.

### i8kutils

Please install and configure i8kutils from https://github.com/vitorafsr/i8kutils. On Ubuntu the following can be run:

```
sudo apt install i8kutils
```

### Dell BIOS Fan Control

Please install Dell BIOS Fan Control from https://github.com/TomFreudenberg/dell-bios-fan-control and install it
into `/usr/bin/`.

If you are not sure that you have GCC installed, please run this first `sudo apt install build-essentials`, then:

```
git clone https://github.com/TomFreudenberg/dell-bios-fan-control.git
cd dell-bios-fan-control
make
sudo cp dell-bios-fan-control /usr/bin
```

Please install this service file
from https://github.com/gilbsgilbs/dell-bios-fan-control-git/blob/master/dell-bios-fan-control.service
into `/etc/systemd/system/`

```
curl -O https://raw.githubusercontent.com/gilbsgilbs/dell-bios-fan-control-git/master/dell-bios-fan-control.service
sudo cp dell-bios-fan-control.service /etc/systemd/system/
sudo systemctl enable dell-bios-fan-control.service
```

### libsmbios

On Ubuntu 20.04 please install the following package to interface with (SM)BIOS information:

```
sudo apt install python3-libsmbios
```

## Installation

### Stable

```
git clone https://github.com/razman786/i8kgui
python3 setup.py install --user
```

### Development

```
git clone https://github.com/razman786/i8kgui
git checkout development && git pull
python3 setup.py install --user
```

## Usage

Please ensure that you have configured i8kutils before starting!

Once i8kutils is correctly configured, please run the following to start up the services if they are not already
running.

```
sudo systemctl start dell-bios-fan-control.service && sudo systemctl start i8kmon.service
```

i8kgui can be loaded by searching in Ubuntu's `Show Applications` icon in the application dock. Optionally i8kgui can be
loaded from a terminal and executing `i8kgui`.

By default, i8kgui displays i8kutils information, however it does facilitate thermal management using the (SM)BIOS. If you
enable this feature typically four fan modes will be available. Please note that, using 'Quiet', or 'Cool Bottom' modes
will reduce performance due to CPU power capping. Changing (SM)BIOS thermal modes may require entering a user password.

Disabling (SM)BIOS thermal management will re-enable i8kutils's management and configuration.

## Issues and requests

Please open an issue [here](https://github.com/razman786/i8kgui/issues).

## Credits

[Delapouite](https://delapouite.com/) for the Computer Fan
Icon ([CC BY 3.0](http://creativecommons.org/licenses/by/3.0/))


