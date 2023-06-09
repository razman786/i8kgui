# I8KGUI

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/razman786/i8kgui/installation.yml?branch=master)  ![GitHub release (latest by date)](https://img.shields.io/github/v/release/razman786/i8kgui)

## Introduction

A Dell thermal management GUI to control fan speeds and monitor temperatures.
Information is taken from
[dell-smm-hwmon](https://www.kernel.org/doc/html/latest/hwmon/dell-smm-hwmon.html),
[i8kutils](https://github.com/vitorafsr/i8kutils), Sysfs and
[(SM)BIOS](https://github.com/dell/libsmbios) - created as a quick hack for my
own needs (screenshots may be of an older version).

<p align="center">
  <img src="https://user-images.githubusercontent.com/7116312/230130936-98105ddc-edcb-4499-b1a0-7c0b9337c1f4.png" alt="i8k" width="150" />
  <img src="https://user-images.githubusercontent.com/7116312/230131129-eb4dbe21-31f9-45b0-8e72-9fa2e2d2ba03.png" alt="bios"width="150" />
  <img src="https://user-images.githubusercontent.com/7116312/230131272-964d33ef-0058-4e74-ba82-f09b60d41fdb.png" alt="cores"width="150" />
  <img src="https://user-images.githubusercontent.com/7116312/230131580-7ae857d1-8754-45c9-92d4-e070c9e6c9f0.png" alt="turbo"width="150" />
  <img src="https://user-images.githubusercontent.com/7116312/154058677-ee7d8858-6cfa-48a8-8dff-f813439bec64.png" alt="settings" width="250" />
  <img src="https://user-images.githubusercontent.com/7116312/202192004-1bc59976-edd5-4d81-a46c-b9450d677ca8.png" alt="info" width="250" />
</p>

i8kgui uses `dell-smm-hwmon`, `i8kutils` and Sysfs to gather information such as
CPU temperature and fan speeds. It also supports thermal management using
(SM)BIOS modes.

### Features

* Displays CPU temperature, fan speed(s) and fan mode(s)
* Displays the current CPU frequency
* Displays CPU load
* Displays individual CPU core frequencies and temperatures
* Displays CPU Turbo information
* Gathers metrics from the `dell_smm_hwmon` kernel module via Sysfs, instead of
  using `/proc/i8k`
* Shows the currently active i8kutils configuration being used
* Supports (SM)BIOS thermal management modes via libsmbios
* Loads [cpupower-gui](https://github.com/vagnum08/cpupower-gui) (if installed)
  when `CPU Governor` is clicked
* Option to display CPU frequency as either the highest (default) or the average
  value for all CPU cores
* Adds polkit action configurations to allow users to change fan modes without a
  password

## Installation

### Automated Installation (Recommended)

This version has only been tested on Ubuntu 20.04 (it should also work on 22.04)
and with a Dell laptop (XPS 7590). The installation script undertakes a
system-wide installation with all optional components (i.e. `cpupower-gui` and
`undervolt`). Please see below for other install options.

```
git clone https://github.com/razman786/i8kgui
cd i8kgui
./install_i8kgui_ubuntu.sh
```

#### Automated Installation Options

Install option | i8kutils | Dell BIOS fan control | libsmbios | cpupower-gui | undervolt
:---|:---:|:---:|:---:|:---:|:---:
`-all` | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark:
`-norm` | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |
`-min` | :white_check_mark: | | |  |
`-fix` | :white_check_mark: | :white_check_mark: | |  |
`-smbios` | :white_check_mark: | | :white_check_mark: |  |
`-power` | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |

See `./install_i8kgui_ubuntu.sh -h` for usage information.

### Manual Installation

#### Prerequisites

This guide has only been tested on Ubuntu 20.04 and with a Dell XPS laptop.

The [dell-smm-hwmon](https://www.kernel.org/doc/html/latest/hwmon/dell-smm-hwmon.html)
kernel module is required for basic functionality.

##### i8kutils

Please install and configure i8kutils from
https://github.com/vitorafsr/i8kutils. On Ubuntu the following can be run:

```
sudo apt install i8kutils
```

##### Dell BIOS Fan Control (optional)

Some systems require this step, while others do not. For example, a Dell XPS
7590 needs the BIOS fan control installed, but a Dell Inspiron 5575 does not.

Please install Dell BIOS Fan Control from
https://github.com/TomFreudenberg/dell-bios-fan-control and install it into
`/usr/bin/`.

If you are not sure that you have GCC installed, please run this first `sudo apt
install build-essentials`, then:

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

##### libsmbios (optional)

If supported by your system, libsmbios will allow BIOS thermal modes to be changed, amongst other
features. On Ubuntu 20.04, please install the following package to interface with (SM)BIOS
information:

```
sudo apt install python3-libsmbios
```

##### cpupower-gui (optional)

On Ubuntu 20.04, install the following optional package to change the CPU
Governor:

```
sudo apt install cpupower-gui
```

#### i8kgui Installation

##### System-wide with polkit actions (Recommended)

###### Using PyPI

```
sudo pip3 install i8kgui --prefix=/usr
```

###### Using Git

```
git clone https://github.com/razman786/i8kgui
sudo pip3 install . --prefix=/usr
```

Please note that the default installation will use the polkit action files for
Ubuntu. Polkit action files for Manjaro Linux (tested with version 22.1.3) are
located in `i8kgui/polkit_actions/manjaro`. For example, to manually install the
polkit action files, do the following `sudo cp i8kgui/polkit_actions/ubuntu/* /usr/share/polkit-1/actions`

##### Stable

```
git clone https://github.com/razman786/i8kgui
pip3 install . --user
```

##### Development

```
git clone https://github.com/razman786/i8kgui
git checkout development && git pull
pip3 install . --user
```

#### Uninstall i8kgui

##### System-wide with polkit actions

```
sudo PYTHONUSERBASE=/usr pip3 uninstall i8kgui
```

##### Stable or Development

```
pip3 uninstall i8kgui
```

## Usage

Please ensure that you have configured i8kutils *before* starting!

Once i8kutils is correctly configured using the `/etc/i8kmon.conf` file, please
run the following to enable the services if they are not already running.

```
sudo systemctl enable dell-bios-fan-control.service; sudo systemctl enable i8kmon.service
```

i8kgui can be loaded by searching in Ubuntu's `Show Applications` icon in the
application dock. Optionally, i8kgui can be loaded from a terminal by executing
`i8kgui`.

By default, i8kgui displays i8kutils information, however it does facilitate
thermal management using the (SM)BIOS. If you enable this feature typically four
fan modes will be available. Please note that, using 'Quiet', or 'Cool Bottom'
modes will reduce performance due to CPU power capping. Changing (SM)BIOS
thermal modes may require entering a user password, if polkit actions have not
been configured.

Disabling (SM)BIOS thermal management in the settings will re-enable i8kutils's
management and configuration.

## Personal configuration

The `i8kmon_sample_conf` directory contains my personal `i8kmon.conf`
configuration file, used on a Dell XPS 7590 (Intel i7, BIOS version 1.14.1).

[Undervolt](https://github.com/georgewhewell/undervolt) is installed using the
following settings to avoid thermal throttling:
```
undervolt -v --gpu -0 --core -121 --cache -121 --uncore -121 --analogio 0 --temp 100
```

## Known Working Systems

Systems that have been reported to be working:

* Dell XPS 7590, Intel i7
* Dell Inspiron 5575, AMD Ryzen 5 - thank you [@yochananmarqos](https://github.com/yochananmarqos)

## Disclaimer

Please note the author takes *no responsibility for any damage* that occurs from
using this software and/or configurations.

## Issues and requests

Please open an issue [here](https://github.com/razman786/i8kgui/issues).

## Credits

[Delapouite](https://delapouite.com/) for the Computer Fan
Icon ([CC BY 3.0](http://creativecommons.org/licenses/by/3.0/))


