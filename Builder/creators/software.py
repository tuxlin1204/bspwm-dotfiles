import os
from logger import Logger, LoggerStatus


class AurBuilder:
    @staticmethod
    def build():
        os.system("git -C /tmp clone https://aur.archlinux.org/yay.git")
        os.system("cd /tmp/yay && sudo -v && makepkg -si --noconfirm")
        

class FirefoxCustomize:
    @staticmethod
    def build():
        os.system("timeout 10 firefox --headless")
        os.system("sh firefox/install.sh")
        Logger.add_record(f"[+] Firefox styles installed", status=LoggerStatus.SUCCESS)

class ThoriumBrowser:
    @staticmethod
    def build():
        os.system("git -C /tmp clone https://aur.archlinux.org/thorium-browser-bin.git")
        os.system("cd /tmp/thorium-browser-bin && sudo -v && makepkg -si --noconfirm")


class SddmTheme:
    @staticmethod
    def build():

        os.system("sudo git clone -b master --depth 1 https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme")
        os.system("sudo cp -r /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/")
        os.system('echo \'[Theme]\nCurrent=sddm-astronaut-theme\' | sudo tee /etc/sddm.conf > /dev/null')

        os.system('echo \'[General]\nInputMethod=qtvirtualkeyboard\' | sudo tee /etc/sddm.conf.d/virtualkbd.conf > /dev/null')
