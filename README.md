# i8kgui

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/razman786/i8kgui/installation.yml?branch=master)  ![GitHub release (latest by date)](https://img.shields.io/github/v/release/razman786/i8kgui)

## Introduction

A simple system tray GUI to display useful information from [i8kutils](https://github.com/vitorafsr/i8kutils) - created
as a quick hack for my own needs.

<p align="center">
  <img src="https://user-images.githubusercontent.com/7116312/202189994-63857806-d2bc-4ba5-81eb-74f6f9fc5e49.png" alt="i8k" width="150" />
  <img src="https://user-images.githubusercontent.com/7116312/202190335-30de2c06-a3f2-4912-a9e7-3f28e4585633.png" alt="bios"width="150" />
  <img src="https://user-images.githubusercontent.com/7116312/202192230-873dcc5a-91e3-401b-9c91-6c074e5cba04.png" alt="cores"width="150" />
  <img src="https://user-images.githubusercontent.com/7116312/154058677-ee7d8858-6cfa-48a8-8dff-f813439bec64.png" alt="settings" width="250" />
  <img src="https://user-images.githubusercontent.com/7116312/202192004-1bc59976-edd5-4d81-a46c-b9450d677ca8.png" alt="info" width="250" />
</p>

i8kgui uses i8kutils to gather information such as CPU temperature and fan speeds. It also supports thermal management using (SM)BIOS modes.

### Features

* Displays CPU temperature, fan speeds and fan modes from i8kutils
* Displays the current CPU frequency
* Displays CPU load
* Displays individual CPU core frequencies and temperatures
* Shows the currently active i8kutils configuration being used
* Supports (SM)BIOS thermal management modes
* Displays i8k module information
* Supports the gathering of (SM)BIOS information
* Loads [cpupower-gui](https://github.com/vagnum08/cpupower-gui) (if installed) when `CPU Governor` is clicked
* Option to display CPU frequency as either the highest (default) or the average value for all CPU cores
* Graceful degradation when i8kutils and/or (SM)BIOS are not available

## Installation

### Automated Installation (Recommended)

This version has only been tested on Ubuntu 20.04 and with a Dell laptop.

```
git clone https://github.com/razman786/i8kgui
./install_i8kgui_ubuntu.sh
```

### Manual Installation

#### Prerequisites

This version has only been tested on Ubuntu 20.04 and with a Dell laptop.

##### i8kutils

Please install and configure i8kutils from https://github.com/vitorafsr/i8kutils. On Ubuntu the following can be run:

```
sudo apt install i8kutils
```

##### Dell BIOS Fan Control

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

##### libsmbios

On Ubuntu 20.04 please install the following package to interface with (SM)BIOS information:

```
sudo apt install python3-libsmbios
```

##### cpupower-gui (optional)

On Ubuntu 20.04 install the following optional package to change the CPU Governor:

```
sudo apt install cpupower-gui
```

#### i8kgui Installation

##### Stable

```
git clone https://github.com/razman786/i8kgui
python3 setup.py install --user
```

##### Development

```
git clone https://github.com/razman786/i8kgui
git checkout development && git pull
python3 setup.py install --user
```

##### System-wide with polkit actions (Recommended)

```
git clone https://github.com/razman786/i8kgui
sudo python3 setup.py install
```

## Usage

Please ensure that you have configured i8kutils before starting!

Once i8kutils is correctly configured using the `/etc/i8kmon.conf` file, please run the following to start up the services if they are not already
running.

```
sudo systemctl start dell-bios-fan-control.service && sudo systemctl start i8kmon.service
```

i8kgui can be loaded by searching in Ubuntu's `Show Applications` icon in the application dock. Optionally, i8kgui can be
loaded from a terminal by executing `i8kgui`.

By default, i8kgui displays i8kutils information, however it does facilitate thermal management using the (SM)BIOS. If you
enable this feature typically four fan modes will be available. Please note that, using 'Quiet', or 'Cool Bottom' modes
will reduce performance due to CPU power capping. Changing (SM)BIOS thermal modes may require entering a user password.

Disabling (SM)BIOS thermal management will re-enable i8kutils's management and configuration.

## Personal configuration

The `i8kmon_sample_conf` directory contains my personal `i8kmon.conf` configuration file, used on a Dell XPS 7590 (Intel i7). 

[Undervolt](https://github.com/georgewhewell/undervolt) is installed using the following settings to avoid thermal throttling: 
```
undervolt -v --gpu -0 --core -121 --cache -121 --uncore -121 --analogio 0 --temp 100
```

## Disclaimer

Please note the author takes *no responsibility for any damage* that occurs from using this software and/or configurations.

## Issues and requests

Please open an issue [here](https://github.com/razman786/i8kgui/issues).

## Credits

[Delapouite](https://delapouite.com/) for the Computer Fan
Icon ([CC BY 3.0](http://creativecommons.org/licenses/by/3.0/))


