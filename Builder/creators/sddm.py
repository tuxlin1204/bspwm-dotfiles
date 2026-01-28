import os

class SddmTheme:
    @staticmethod
    def build():
      os.system("sudo pacman -S --noconfirm sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg") # зависимости для sddm
      os.system("sudo git clone -b master --depth 1 https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme")
      os.system("sudo cp -r /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/")
      os.system('echo \'[Theme]\nCurrent=sddm-astronaut-theme\' | sudo tee /etc/sddm.conf > /dev/null')

      os.system('echo \'[General]\nInputMethod=qtvirtualkeyboard\' | sudo tee /etc/sddm.conf.d/virtualkbd.conf > /dev/null') 
