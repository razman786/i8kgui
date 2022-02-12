#  Copyright (c) 2022, Dr Rahim Lakhoo, razman786@gmail.com.
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not,
# see <https://www.gnu.org/licenses/>.
#

class DellSmbios:
    def __init__(self):
        super(DellSmbios, self).__init__()
        self.info = dict()

    def get_info(self):
        try:
            from libsmbios_c import system_info
        except ImportError:
            print("Error importing libsmbios_c")
            return None
        else:
            self.info['Libsmbios'] = system_info.get_library_version_string()
            try:
                sysid = "0x%04X" % system_info.get_dell_system_id()
            except Exception as e:
                print("Error getting the", end=' ')
                sysid = str(e)
            self.info['System ID'] = sysid
            self.info['Service Tag'] = system_info.get_service_tag()
            self.info['Asset Tag'] = system_info.get_asset_tag()
            try:
                esc = int(system_info.get_service_tag(), 36)
            except Exception as e:
                esc = str(e)
                print("Error getting the", end=' ')

            self.info['Express Service Code'] = esc
            self.info['Product Name'] = system_info.get_system_name()
            self.info['BIOS Version'] = system_info.get_bios_version()
            self.info['Vendor'] = system_info.get_vendor_name()
            self.info['Property Ownership Tag'] = system_info.get_property_ownership_tag()

            if self.info:
                for key, value in self.info.items():
                    print(f"{key}: {value}")

        return self.info


if __name__ == '__main__':
    smbios_info = DellSmbios()
    smbios_info.get_info()
