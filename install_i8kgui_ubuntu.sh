#!/bin/bash
# Copyright (c) 2022-2023, Dr Rahim Lakhoo, razman786@gmail.com.
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License 
# for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see <https://www.gnu.org/licenses/>.
#
# Installation script only tested with Ubuntu 20.04 and partially with 22.04

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
echo "==== i8kgui v0.8.4 - Ubuntu install script ===="
echo "==== Log file: $log_file ===="
echo "==== Error log: $error_file ===="
echo ""
printf "==== i8kgui v0.8.4 - Ubuntu install script ====\n"

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

# finished message
finished() {
  echo ""
  echo "********************************************** FINISHED \o/ ***************************************************"
	echo "**** i8kgui installation complete! \o/"
  echo "****"
	echo "**** Please configure i8kutils:"
	echo "**** Example i8kutils config can be found at i8kmon_sample_conf/i8kmon.conf"
	echo "****"
  echo "**** Then enable the Dell BIOS fan control (Optional) and then i8kutil services with the following:"
	echo "**** sudo systemctl enable dell-bios-fan-control.service; sudo systemctl enable i8kmon.service"
  echo "****"
  echo "**** (Optional) Please configure undervolt. An example for a XPS 7590 (i7 CPU):"
	echo "**** sudo /usr/local/bin/undervolt -v --gpu -0 --core -121 --cache -121 --uncore -121 --analogio 0 --temp 100"
  echo "***************************************************************************************************************"
  echo ""
	exit 0
	}

# display help
display_usage() {
	echo -e "\nUsage: $0 [OPTION]\n"
	echo -e "-ns,     --no-sudo               install without sudo. You should be su"
	echo -e "-all,    --all-install           install with i8kutils, dell-bios-fan-control, libsmbios, cpu_power_gui and undervolt (default)"
	echo -e "-norm,   --normal-install        install with i8kutils, dell-bios-fan-control and libsmbios"
	echo -e "-min,    --minimum-install       install with i8kutils"
	echo -e "-fix,    --bios-fix-install      install with i8kutils and dell-bios-fan-control"
	echo -e "-smbios, --libsmbios-install     install with i8kutils and libsmbios"
	echo -e "-power,  --power-install         install with i8kutils, dell-bios-fan-control, libsmbios and cpu_power_gui"
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

# default installation
if [[ ( $1 == "--all-install") ||  $1 == "-all" ]]
then
	install_type="all"
fi

if [[ ( $1 == "--norm-install") ||  $1 == "-norm" ]]
then
	install_type="normal"
fi

if [[ ( $1 == "--min-install") ||  $1 == "-min" ]]
then
	install_type="mininum"
fi

if [[ ( $1 == "--fix-install") ||  $1 == "-fix" ]]
then
	install_type="bios-fix"
fi

if [[ ( $1 == "--smbios-install") ||  $1 == "-smbios" ]]
then
	install_type="smbios"
fi

if [[ ( $1 == "--power-install") ||  $1 == "-power" ]]
then
	install_type="power"
fi

# display installer mode
echo "==== Installer mode detected as '$install_type' installation ===="
printf "==== Installer mode detected as '$install_type' installation ====\n"

check_ubuntu_version () {
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

  # check if Ubuntu 20.04 or 22.04, add versions as needed
  if [[ $distro_version == 2004 ]] || [[ $distro_version == 2204 ]] || [[ $distro_version == 2304 ]]
  then
    echo "==== Installer has detected Linux distribution as $distro_name $distro_version ===="
    printf "==== Installer has detected Linux distribution as $distro_name $distro_version ====\n"
  else
    echo "==== Error Installer has detected incorrect Ubuntu version $distro_version ===="
    printf "==== Error Installer has detected incorrect Ubuntu version $distro_version ====\n"
    exception
  fi
}

install_pip_depends () {
  # check for pip3 and install if need be
  if command -v pip3 > /dev/null 
  then
    echo "==== Installer found pip3..."
    printf "==== Installer found pip3...\n"
  else
    echo "==== Installer did not find pip3, installing..."
    printf "==== Installer did not find pip3 installing...\n"
    $sudo_runner $apt_runner python3-setuptools python3-pip 2>>$error_file || exception
    if [[ $distro_version == 2304 ]]
    then
      pip3 install -U pip setuptools wheel --user --break-system-packages
    else
      pip3 install -U pip setuptools wheel --user
    fi
  fi
}

install_dell_bios_fix () {
  # install Dell BIOS fan control
  fan_control_service="/etc/systemd/system/multi-user.target.wants/dell-bios-fan-control.service"
  if [[ ! -f $fan_control_service ]]
  then
    echo "==== Installing i8kgui BIOS fan control dependency..."
    printf "==== Installing i8kgui BIOS fan control dependency...\n"
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
  else
    echo "==== Installer found i8kgui BIOS fan control dependency..."
    printf "==== Installer found i8kgui BIOS fan control dependency...\n"
  fi
}

install_i8kutils () {
  # install dependencies via packages by default
  if [[ $build_type == "package" ]]
  then
    # install i8kgui deps
    echo "==== Installing i8kgui dependencies i8kutils..."
    printf "==== Installing i8kgui dependencies i8kutils...\n"
    $sudo_runner $apt_runner i8kutils 2>>$error_file || exception
  else
    # source build not implemented
    echo "Error $build_type is not implemented"
    printf "Error $build_type is not implemented"
    exception
  fi
}

install_libsmbios () {
  # install dependencies via packages by default
  if [[ $build_type == "package" ]]
  then
    # install i8kgui deps
    echo "==== Installing i8kgui dependencies libsmbios..."
    printf "==== Installing i8kgui dependencies libsmbios...\n"
    $sudo_runner $apt_runner python3-libsmbios 2>>$error_file || exception
  else
    # source build not implemented
    echo "Error $build_type is not implemented"
    printf "Error $build_type is not implemented"
    exception
  fi
}

install_cpu_power_gui () {
  # install optional dependencies
  echo "==== Installing optional dependencies cpupower-gui..."
  printf "==== Installing optional dependencies cpupower-gui...\n"
  $sudo_runner $apt_runner cpupower-gui 2>>$error_file || exception
}

install_undervolt () {
  # install optional dependencies
  echo "==== Installing optional dependencies undervolt..."
  printf "==== Installing optional dependencies undervolt...\n"
  if [[ $distro_version == 2304 ]]
  then
    $sudo_runner pip3 install undervolt --break-system-packages 2>>$error_file || exception
  else
    $sudo_runner pip3 install undervolt 2>>$error_file || exception
  fi
}

install_polkit_actions () {
  # install polkit files
  echo "==== Installing polkit actions..."
  printf "==== Installing polkit actions...\n"
  sed -i "s@I8KGUI_THERMAL_PATH@$HOME@" i8kgui/polkit_actions/ubuntu/com.ubuntu.pkexec.i8kgui_thermal_control.policy
  $sudo_runner cp i8kgui/polkit_actions/ubuntu/* /usr/share/polkit-1/actions/ 2>>$error_file || exception
}

install_i8kgui () {
  # install i8kgui
  echo "==== Installing i8kgui..."
  printf "==== Installing i8kgui...\n"
  if [[ $distro_version == 2304 ]]
  then
    pip3 install . --user --break-system-packages 1>>$log_file 2>>$error_file && finished && printf "==== i8kgui installation complete! \o/ ====\n" || exception
  else
    pip3 install . --user 1>>$log_file 2>>$error_file && finished && printf "==== i8kgui installation complete! \o/ ====\n" || exception
  fi
}

# install i8kgui and dependencies
check_ubuntu_version
install_pip_depends
# install dependencies
if [[ $install_type == "all" ]]
then
  install_dell_bios_fix
  install_i8kutils
  install_libsmbios
  install_cpu_power_gui
  install_undervolt
  install_polkit_actions
elif [[ $install_type == "normal" ]]
then
  install_dell_bios_fix
  install_i8kutils
  install_libsmbios
  install_polkit_actions
elif [[ $install_type == "mininum" ]]
then
  install_i8kutils
elif [[ $install_type == "bios-fix" ]]
then
  install_dell_bios_fix
  install_i8kutils
  install_polkit_actions
elif [[ $install_type == "smbios" ]]
then
  install_i8kutils
  install_libsmbios
  install_polkit_actions
elif [[ $install_type == "power" ]]
then
  install_dell_bios_fix
  install_i8kutils
  install_libsmbios
  install_cpu_power_gui
  install_polkit_actions
fi
# install i8kgui
install_i8kgui


# EOF
