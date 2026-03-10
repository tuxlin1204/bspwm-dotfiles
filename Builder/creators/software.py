import os
from logger import Logger, LoggerStatus


class AurBuilder:
    @staticmethod
    def build():
        os.system("git -C /tmp clone https://aur.archlinux.org/yay.git")
        os.system("cd /tmp/yay && makepkg -s --noconfirm")
        os.system("sudo pacman -U /tmp/yay/*.pkg.tar.zst --noconfirm")
class FirefoxCustomize:
    @staticmethod
    def build():
        os.system("timeout 10 firefox --headless")
        os.system("sh firefox/install.sh")
        os.system("sudo mkdir -p /etc/firefox/")
        os.system("sudo cp -r firefox/tartarus-startpage/ /etc/")
        os.system("sudo cp -r firefox/service/* /etc/systemd/system/")
        os.system("sudo systemctl daemon-reload")
        os.system("sudo systemctl enable startpage.service")
        os.system("sudo systemctl status startpage.service")
        Logger.add_record(f"[+] Firefox styles installed", status=LoggerStatus.SUCCESS)

class ThoriumBrowser:
    @staticmethod
    def build():
        os.system("git -C /tmp clone https://aur.archlinux.org/thorium-browser-bin.git")
        os.system("cd /tmp/thorium-browser-bin && makepkg -s --noconfirm")
        os.system("sudo pacman -U /tmp/thorium-browser-bin/*.pkg.tar.zst --noconfirm")

class SddmTheme:
    @staticmethod
    def build():

        os.system("sudo git clone -b master --depth 1 https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme")
        os.system("sudo cp -r /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/")
        os.system('echo \'[Theme]\nCurrent=sddm-astronaut-theme\' | sudo tee /etc/sddm.conf > /dev/null')

        os.system('echo \'[General]\nInputMethod=qtvirtualkeyboard\' | sudo tee /etc/sddm.conf.d/virtualkbd.conf > /dev/null')

class NeoVim:
    @staticmethod
    def build():
        os.system("sudo luarocks install dkjson --lua-version=5.1")


