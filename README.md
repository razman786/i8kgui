# i8kgui

## Introduction

A simple system tray GUI to display useful information from [i8kutils](https://github.com/vitorafsr/i8kutils) - created
as a quick hack for my own needs.

<p align="center">
  <img src="https://user-images.githubusercontent.com/7116312/153890437-a2bae919-5778-4364-83e8-c9c620b8f9f3.png" width="150" />
  <img src="https://user-images.githubusercontent.com/7116312/153890588-f127a839-38bd-488c-bf2f-d6b1b30443c6.png" width="150" />
  <img src="https://user-images.githubusercontent.com/7116312/153890843-be0c61eb-7a95-4584-b723-66e6fc279e68.png" width="250" />
  <img src="https://user-images.githubusercontent.com/7116312/153890711-452b82ff-dc22-437e-b541-a651064d9b23.png" width="250" />
</p>

i8kgui uses i8kutils to gather information such as CPU temperature and fan speeds. It attempts to only update GUI values
when visibly active. i8kgui also supports thermal management using BIOS modes.

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
```

### libsmbios

On Ubuntu 20.04 please install the following package to interface with SMBIOS information:

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

Please ensure that you have configured i8kutils before starting.

By default, i8kgui displays i8kutils information, however it does facilitate thermal management using the BIOS.
If you enable this feature typically four fan modes will be available. Please note that, using 'Quiet', or 'Cool Bottom'
modes will reduce performance due to CPU power capping. Changing BIOS thermal modes may require entering a user password.

Disabling BIOS thermal management will re-enable i8kutils's management and configuration.

## Issues and requests

Please open an issue [here](https://github.com/razman786/i8kgui/issues).

## Credits

[Delapouite](https://delapouite.com/) for the Computer Fan
Icon ([CC BY 3.0](http://creativecommons.org/licenses/by/3.0/))


