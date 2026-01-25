import os
from logger import Logger, LoggerStatus


class GRUB:
    @staticmethod
    def build():
        os.system("git -C /tmp clone https://github.com/catppuccin/grub.git && cd grub")
        os.system("cp -r src/* /usr/share/grub/themes/")
        os.system('echo \'GRUB_THEME="/usr/share/grub/themes/catppuccin-mocha-grub-theme/theme.txt"\' | sudo tee -a /etc/default/grub')

        os.system("grub-mkconfig -o /boot/grub/grub.cfg")



class AurBuilder:
    @staticmethod
    def build():
        os.system("git -C /tmp clone https://aur.archlinux.org/yay.git")
        os.system("cd /tmp/yay && makepkg -si")

class FirefoxCustomize:
    @staticmethod
    def build():
        os.system("timeout 10 firefox --headless")
        os.system("sh firefox/install.sh")
        Logger.add_record(f"[+] Firefox styles installed", status=LoggerStatus.SUCCESS)
