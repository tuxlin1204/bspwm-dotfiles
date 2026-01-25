import os

class GrubTheme:
    @staticmethod
    def build():
      os.system("git -C /tmp clone https://github.com/catppuccin/grub.git")
      os.system("sudo cp -r /tmp/grub/src/* /usr/share/grub/themes/")
      os.system('echo \'GRUB_THEME="/usr/share/grub/themes/catppuccin-mocha-grub-theme/theme.txt"\' | sudo tee -a /etc/default/grub')

      os.system("sudo grub-mkconfig -o /boot/grub/grub.cfg")
