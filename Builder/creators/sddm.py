import os
import shutil
import subprocess
from pathlib import Path

class SddmTheme:
    THEME_REPO = "https://github.com/keyitdev/sddm-astronaut-theme.git"
    THEME_DIR = Path("/usr/share/sddm/themes/sddm-astronaut-theme")
    CONF_DIR = Path("/etc/sddm.conf.d")

    @staticmethod
    def run(cmd):
        print(f"[+] {cmd}")
        subprocess.run(cmd, shell=True, check=True)

    @staticmethod
    def build():
        if os.geteuid() != 0:
            raise SystemExit("❌ Run installer as root")

        # 1. Dependencies
        SddmTheme.run(
            "pacman -S --noconfirm "
            "sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg"
        )

        # 2. Theme
        if SddmTheme.THEME_DIR.exists():
            shutil.rmtree(SddmTheme.THEME_DIR)

        SddmTheme.run(
            f"git clone --depth 1 {SddmTheme.THEME_REPO} {SddmTheme.THEME_DIR}"
        )

        # 3. Fonts
        fonts = SddmTheme.THEME_DIR / "Fonts"
        if fonts.exists():
            SddmTheme.run(f"cp -r {fonts}/* /usr/share/fonts/")
            SddmTheme.run("fc-cache -fv")

        # 4. Configs
        SddmTheme.CONF_DIR.mkdir(parents=True, exist_ok=True)

        (SddmTheme.CONF_DIR / "theme.conf").write_text(
            "[Theme]\n"
            "Current=sddm-astronaut-theme\n"
        )

        (SddmTheme.CONF_DIR / "virtualkbd.conf").write_text(
            "[General]\n"
            "InputMethod=qtvirtualkeyboard\n"
        )

