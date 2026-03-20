import subprocess

class DiskUtils:

    @staticmethod
    def get_extra_partitions():
        # все разделы
        result = subprocess.check_output(
            "lsblk -lpno NAME,TYPE,MOUNTPOINT",
            shell=True
        ).decode().strip().split("\n")

        extra = []

        for line in result:
            parts = line.split()

            if len(parts) < 2:
                continue

            name = parts[0]
            type_ = parts[1]
            mount = parts[2] if len(parts) > 2 else ""

            # интересуют только partitions
            if type_ != "part":
                continue

            # пропускаем уже смонтированные системные
            if mount == "/" or mount.startswith("/boot"):
                continue

            # если не смонтирован или смонтирован не в /mnt → считаем доп
            if not mount or mount.startswith("/mnt"):
                extra.append(name)

        return extra
