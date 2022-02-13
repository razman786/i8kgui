from setuptools import setup, find_packages
from pathlib import Path

__version__ = "0.3.2"

requirements = [
    'PySide6',
]

scripts = [
    'i8kgui',
]

package_data = {'i8kgui': ['icons/*.png']}

setup(
    name='i8kgui',
    version=__version__,
    packages=find_packages(),
    scripts=scripts,
    package_data=package_data,
    install_requires=requirements,
    url='https://github.com/razman786/i8kgui',
    license='GPL',
    author='Dr Rahim Lakhoo',
    author_email='razman786@gmail.com',
    description='A system tray GUI for i8kutils.',
    data_files=[
        (f"{Path.home()}/.local/share/applications", ['desktop/i8kgui.desktop']),
        (f"{Path.home()}/.local/share/icons", ['icons/i8kgui_icon.png']),
        (f"{Path.home()}/.local/bin", ['DellSmbios']),
        (f"{Path.home()}/.local/bin", ['i8kgui_thermal_control']),
    ],
)
