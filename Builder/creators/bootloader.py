import os
from logger import Logger, LoggerStatus

class GrubTheme:
    @staticmethod
    def install():
        Logger.add_record("[+] Installing GRUB theme", LoggerStatus.SUCCESS)
        os.system("git clone https://github.com/catppuccin/grub.git /tmp/grub")
        os.system("cp -r /tmp/grub/src/* /usr/share/grub/themes/")
        os.system(
            'grep -q "^GRUB_THEME=" /etc/default/grub || '
            'echo \'GRUB_THEME="/usr/share/grub/themes/catppuccin-mocha-grub-theme/theme.txt"\' | sudo tee -a /etc/default/grub'
        )
        os.system("sudo grub-mkconfig -o /boot/grub/grub.cfg")

