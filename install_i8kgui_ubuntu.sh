#!/bin/bash

# Installation script only tested with Ubuntu 20.04

# add .local to $PATH 
export PATH=$PATH:~/.local/bin

log_file=i8kgui_installer.log
error_file=i8kgui_installer.err

# custom redirection
exec 3>&1

# redirect stdout/stderr to a file
exec >$log_file 2> $error_file

# function echo to show echo output on terminal
echo() {
   # call actual echo command and redirect output to custom redirect
   command echo "$@" >&3
}

echo ""
echo "==== i8kgui v0.8.1 - Ubuntu install script ===="
echo "==== Log file: $log_file ===="
echo "==== Error log: $error_file ===="
echo ""
printf "==== i8kgui v0.8.1 - Ubuntu install script ====\n"

# sudo runner by default
sudo_runner="sudo"

# sudo runner by default
apt_runner="apt -y install"

# install via packages by default
build_type="package"

# install optional i8kgui components by default
install_type="all"

# store the location of this dir
i8kgui_pwd="${PWD}"

# exception handling
exception() {
  echo ""
  echo "********************************* ERROR ****************************************"
	echo "**** i8kgui installation script encountered an error"
	echo "**** Please check the log files $log_file and $error_file"
	echo "**** Ending i8kgui installation script ¯\_(ツ)_/¯"
  echo "********************************************************************************"
  echo ""
	exit 1
	}

# exception handling
finished() {
  echo ""
  echo "********************************************** FINISHED \o/ ***************************************************"
	echo "**** i8kgui installation complete! \o/"
  echo "****"
	echo "**** Please configure i8kutils:"
	echo "**** Example i8kutils config can be found at i8kmon_sample_conf/i8kmon.conf"
	echo "****"
	echo "**** Then start the Dell BIOS fan control and i8kutil services with the following:"
	echo "**** sudo systemctl start dell-bios-fan-control.service && sudo systemctl start i8kmon.service"
  echo "****"
  echo "**** (Optional) Please configure undervolt. An example for a XPS 7590 (i7 CPU):"
	echo "**** sudo /root/.local/bin/undervolt -v --gpu -0 --core -121 --cache -121 --uncore -121 --analogio 0 --temp 100"
  echo "***************************************************************************************************************"
  echo ""
	exit 1
	}

# display help
display_usage() {
	echo -e "\nUsage: $0 [OPTION]\n"
	echo -e "-ns, --no-sudo     install without sudo. You should be su\n"
	}

# check whether user had supplied -h or --help.
if [[ ( $1 == "--help") ||  $1 == "-h" ]]
then
	display_usage
	exit 0
fi

# if no-sudo is specified then remove sudo - assume user is su
if [[ ( $1 == "--no-sudo") ||  $1 == "-ns" ]]
then
	sudo_runner=""
fi

# identify if running on Ubuntu and which version
if [[ -n "$(command -v lsb_release)" ]]
then
	distro_name=$(lsb_release -s -d|awk '{print $1}')

	if [[ $distro_name == "Ubuntu" ]]
	then
		distro_version=$(lsb_release -rs|sed -e 's/\.//g')
	else
		echo "==== Error: Ubuntu Linux not detected, stopping installation ===="
		printf "==== Error: Ubuntu Linux not detected, stopping installation ====\n"
		exception
	fi
else
	echo "==== Error: Unable to detect Linux distribution, stopping installation ===="
	printf "==== Error: Unable to detect Linux distribution, stopping installation ====\n"
	exception
fi

echo "==== Installer has detected Linux distribution as $distro_name $distro_version ===="
printf "==== Installer has detected Linux distribution as $distro_name $distro_version ====\n"

# check for pip3 and install if need be
if command -v pip3 > /dev/null 
then
  if [[ $VIRTUAL_ENV == "" ]]
  then
    echo "==== Installer found pip3 (no VENV)... ===="
    printf "==== Installer found pip3 (no VENV)... ====\n"
  else
    if command -v $VIRTUAL_ENV/bin/pip3 > /dev/null
    then
      echo "==== Installer found pip3 (VENV)... ===="
      printf "==== Installer found pip3 (VENV)... ====\n"
      $VIRTUAL_ENV/bin/pip3 install -U pip setuptools wheel
    else
      echo "==== Installer did not find pip3 (VENV)... ===="
      printf "==== Installer did not find pip3 (VENV)... ====\n"
      $sudo_runner $apt_runner python3-setuptools python3-pip 2>>$error_file || exception
      pip3 install -U pip setuptools wheel --user
    fi
  fi
else
  echo "==== Installer did not find pip3 (no VENV)... ===="
  printf "==== Installer did not find pip3 (no VENV)... ====\n"
	install_type="fullstack"
	$sudo_runner $apt_runner python3-setuptools python3-pip 2>>$error_file || exception
  pip3 install -U pip setuptools wheel --user
fi

# check for Dell BIOS fan control
fan_control=`command -v dell-bios-fan-control`
fan_control_service="/etc/systemd/system/dell-bios-fan-control.service"
if [[ -n "$fan_control" ]]
then
	echo "==== Installer found i8kgui BIOS fan control dependency... ===="
	printf "==== Installer found i8kgui BIOS fan control dependency... ====\n"
	
	if [[ ! -f $fan_control_service ]]
	then
		echo "==== Installer fullstack mode - i8kgui BIOS fan control service not found... ===="
		printf "==== Installer fullstack mode - i8kgui BIOS fan control service not found...... ====\n"
		install_type="fullstack"
	fi
else
	install_type="fullstack"
	echo "==== Installer fullstack mode - i8kgui BIOS fan control not found... ===="
	printf "==== Installer fullstack mode - i8kgui BIOS fan control not found... ====\n"
fi	

# install Dell BIOS fan control
if [[ $install_type == "fullstack" ]]
then
  echo "==== Installing i8kgui BIOS fan control dependency... ===="
  printf "==== Installing i8kgui BIOS fan control dependency... ====\n"
  $sudo_runner $apt_runner git 2>>$error_file || exception
  $sudo_runner $apt_runner build-essential 2>>$error_file || exception
  cd /tmp || exception
  # install fan control binary
  rm -rf dell-bios-fan-control
  git clone https://github.com/TomFreudenberg/dell-bios-fan-control.git 1>>$log_file 2>>$error_file || exception
  cd dell-bios-fan-control || exception
  make 1>>$log_file 2>>$error_file || exception
  $sudo_runner cp dell-bios-fan-control /usr/bin 1>>$log_file 2>>$error_file || exception
  # install fan control service
  cd /tmp || exception
  rm -f dell-bios-fan-control.service
  curl -O https://raw.githubusercontent.com/gilbsgilbs/dell-bios-fan-control-git/master/dell-bios-fan-control.service 1>>$log_file 2>>$error_file || exception
  $sudo_runner cp dell-bios-fan-control.service /etc/systemd/system/ 1>>$log_file 2>>$error_file || exception
  cd "${i8kgui_pwd}" || exception
fi

if [[ $install_type == "all" ]]
then
  echo "==== Installing i8kgui optional dependencies... ===="
  printf "==== Installing i8kgui optional dependencies... ====\n"
  if [[ $VIRTUAL_ENV == "" ]]
  then
    echo "==== Installing optional dependencies undervolt and cpupower-gui... ===="
    printf "==== Installing optional dependencies undervolt and cpupower-gui... ====\n"
    $sudo_runner $apt_runner cpupower-gui 1>>$log_file 2>>$error_file || exception
    $sudo_runner pip3 install undervolt 1>>$log_file 2>>$error_file || exception
  else
    echo "==== Installing optional dependencies undervolt and cpupower-gui... ===="
    printf "==== Installing optional dependencies undervolt and cpupower-gui... ====\n"
    $sudo_runner $apt_runner cpupower-gui 1>>$log_file 2>>$error_file || exception
    $sudo_runner pip3 install undervolt 1>>$log_file 2>>$error_file || exception
  fi
fi

echo "==== Installing i8kgui dependencies i8kutils and libsmbios... ===="
printf "==== Installing i8kgui dependencies i8kutils and libsmbios... ====\n"

if [[ $build_type == "package" ]]
then
  # install i8kgui deps
  $sudo_runner $apt_runner i8kutils python3-libsmbios 1>>$log_file 2>>$error_file || exception
fi

# install i8kgui
if [[ $VIRTUAL_ENV == "" ]]
then
  echo "==== Installing i8kgui... ===="
  printf "==== Installing i8kgui... ====\n"
  $sudo_runner python3 setup.py install 1>>$log_file 2>>$error_file && finished && printf "==== i8kgui installation complete! \o/ ====\n" || exception
else
  echo "currently not supported"
  exception
fi
