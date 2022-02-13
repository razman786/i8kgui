from setuptools import setup, find_packages
from pathlib import Path

__version__ = "0.4"

requirements = [
    'PySide6',
]

scripts = [
    'i8kgui/i8kgui',
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
    data_files=[
        (f"{Path.home()}/.local/share/applications", ['i8kgui/desktop/i8kgui.desktop']),
        (f"{Path.home()}/.local/share/icons", ['i8kgui/icons/i8kgui_icon.png']),
    ],
)
