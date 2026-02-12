import os


class PatchSystemBugs:
    @staticmethod
    def enable_all_patches():
        PatchSystemBugs.__fix_xterm_error_in_thunar()
        PatchSystemBugs.__make_fish_the_default()
        PatchSystemBugs.__assign_permissions_to_configs()
        PatchSystemBugs.__assign_permissions_to_backlight()

        
    @staticmethod
    def __fix_xterm_error_in_thunar():
        os.system("sudo ln -sf /usr/bin/alacritty /usr/bin/xterm")

    @staticmethod
    def __make_fish_the_default():
        os.system("sudo chsh -s /usr/bin/fish")

    @staticmethod
    def __assign_permissions_to_configs():
        os.system("sudo chmod -R 700 ~/.config/*")
    @staticmethod
    def __assign_permissions_to_backlight():
        os.system("sudo usermod -aG video $USER")
