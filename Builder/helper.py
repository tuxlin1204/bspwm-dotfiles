import subprocess

class DiskUtils:

    @staticmethod
    def get_extra_disks():
        """
        Возвращает список дисков, которые не используются системой
        (не системные и не swap)
        """
        # Получаем все устройства и их монтирования
        result = subprocess.check_output(
            "lsblk -lpno NAME,TYPE,MOUNTPOINT",
            shell=True
        ).decode().strip().split("\n")

        # Словарь: диск → его разделы с монтированием
        disks = {}
        for line in result:
            parts = line.split()
            if len(parts) < 2:
                continue
            name = parts[0]
            type_ = parts[1]
            mount = parts[2] if len(parts) > 2 else ""

            # Игнорируем swap
            if type_.lower() == "swap":
                continue

            if type_ == "disk":
                disks[name] = []
            elif type_ == "part":
                # Определяем родительский диск
                parent_disk = ''.join([c for c in name if not c.isdigit()]).rstrip('/')
                if parent_disk in disks:
                    disks[parent_disk].append(mount)

        extra = []
        for disk, mounts in disks.items():
            # Если на диске есть системные монтирования → пропускаем
            if any(m in ["/", "/boot", "/home"] for m in mounts):
                continue
            # Если это zram (swap) → пропускаем
            if "zram" in disk.lower():
                continue
            # иначе диск дополнительный
            extra.append(disk)

        return extra
