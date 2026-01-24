import os
from logger import Logger, LoggerStatus


class AurBuilder:
    @staticmethod
    def build():
        if os.geteuid() == 0:
            raise RuntimeError("AUR packages must not be built as root")

        subprocess.run(
            ["git", "clone", "https://aur.archlinux.org/yay.git", "/tmp/yay"],
            check=True,
        )

        subprocess.run(
            ["makepkg", "-si", "--noconfirm"],
            cwd="/tmp/yay",
            check=True,
        )

class FirefoxCustomize:
    @staticmethod
    def build():
        os.system("timeout 10 firefox --headless")
        os.system("sh firefox/install.sh")
        Logger.add_record(f"[+] Firefox styles installed", status=LoggerStatus.SUCCESS)
