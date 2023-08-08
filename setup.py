from setuptools import setup
from pathlib import Path

__version__ = "0.8.4"

requirements = [
    'PySide6',
    'psutil',
    'py-cpuinfo',
]

scripts = [
    'i8kgui/i8kgui',
    'i8kgui/i8kgui_thermal_control',
]


def get_data_files():
    return [
        ("share/applications", ['i8kgui/desktop/i8kgui.desktop']),
        ("share/icons", ['i8kgui/icons/i8kgui_icon.png']),
        ("share/polkit-1/actions", ['i8kgui/polkit_actions/ubuntu/com.ubuntu.pkexec.i8kgui_thermal_control.policy']),
        ("share/polkit-1/actions", ['i8kgui/polkit_actions/ubuntu/com.ubuntu.pkexec.smbios-thermal-ctl.policy']),
    ]


this_directory = Path(__file__).parent
long_description = (this_directory / "README.md").read_text()


setup(
    name='i8kgui',
    version=__version__,
    packages=['i8kgui'],
    scripts=scripts,
    install_requires=requirements,
    url='https://github.com/razman786/i8kgui',
    license='GPL',
    author='Raz',
    author_email='razman786@users.noreply.github.com',
    description='A Dell thermal management GUI to control fan speeds and monitor temperatures.',
    long_description=long_description,
    long_description_content_type='text/markdown',
    data_files=get_data_files(),
)
