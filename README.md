# i8kgui

## Introduction

A simple system tray GUI to display useful information from [i8kutils](https://github.com/vitorafsr/i8kutils) - created
as a quick hack for my own needs.

<p align="center">
  <img src="https://user-images.githubusercontent.com/7116312/153513946-7eca1bf7-ab22-4dda-a43b-a4c450da728d.png" width="150" />
  <img src="https://user-images.githubusercontent.com/7116312/153514164-887ff23e-04cd-4ce5-a864-149521fb2878.png" width="150" />
  <img src="https://user-images.githubusercontent.com/7116312/153514232-26ee3aea-5cc0-4df4-af27-370d7c7251b8.png" width="250" />
</p>

i8kgui uses i8kutils to gather information such as CPU temperature and fan speeds. It attempts to only
update GUI values when active, but does have an option to collect information continuously.

## Prerequisites 

This version has only been tested on Ubuntu 20.04 and with a Dell laptop.

### i8kutils

Please install and configure i8kutils from https://github.com/vitorafsr/i8kutils.  

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

## Issues and requests

Please open an issue [here](https://github.com/razman786/i8kgui/issues).

## Credits

[Delapouite](https://delapouite.com/) for the Computer Fan Icon ([CC BY 3.0](http://creativecommons.org/licenses/by/3.0/))


