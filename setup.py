import os

from setuptools import find_packages, setup

__version__ = "0.5"

requirements = [
    'PySide6',
]

scripts = [
    'i8kgui/i8kgui',
    'i8kgui/i8kgui_thermal_control',
]


def get_data_files():
    return [
            ("/usr/share/applications", ['i8kgui/desktop/i8kgui.desktop']),
            ("/usr/share/icons", ['i8kgui/icons/i8kgui_icon.png']),
        ] if os.geteuid() == 0 else [
            ("{Path.home()}/.local/share/applications",
             ['i8kgui/desktop/i8kgui.desktop']),
            ("{Path.home()}/.local/share/icons",
             ['i8kgui/icons/i8kgui_icon.png']),
        ]


setup(
    name='i8kgui',
    version=__version__,
    packages=find_packages(),
    scripts=scripts,
    install_requires=requirements,
    url='https://github.com/razman786/i8kgui',
    license='GPL',
    author='Dr Rahim Lakhoo',
    author_email='razman786@gmail.com',
    description='A system tray GUI for i8kutils and smbios.',
    data_files=get_data_files(),
)
