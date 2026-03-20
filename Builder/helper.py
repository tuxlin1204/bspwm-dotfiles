import subprocess

class DiskUtils:

    @staticmethod
    def get_extra_disks():
        """
        Возвращает список дополнительных дисков, которые не используются системой.
        Системные диски (с /, /boot, /home) и zram/swap исключаются.
        """
        result = subprocess.check_output(
            "lsblk -lpno NAME,TYPE,MOUNTPOINT",
            shell=True
        ).decode().strip().split("\n")

        disks = {}
        partitions = []

        for line in result:
            cols = line.split()
            if len(cols) < 2:
                continue
            name, type_ = cols[0], cols[1]
            mount = cols[2] if len(cols) > 2 else ""

            # пропускаем swap сразу
            if type_ == "swap":
                continue

            if type_ == "disk":
                disks[name] = []
            elif type_ == "part":
                partitions.append((name, mount))

        # сопоставляем разделы с дисками
        for part_name, mount in partitions:
            # получаем родительский диск через lsblk PATH
            disk_path = subprocess.check_output(
                f"lsblk -no PKNAME {part_name}",
                shell=True
            ).decode().strip()
            disk_name = "/dev/" + disk_path
            if disk_name in disks:
                disks[disk_name].append(mount)

        extra = []
        for disk, mounts in disks.items():
            # пропускаем системные диски
            if any(m in ["/", "/boot", "/home"] for m in mounts):
                continue
            # пропускаем zram
            if "zram" in disk.lower():
                continue
            extra.append(disk)

        return extra
