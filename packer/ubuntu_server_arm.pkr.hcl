packer {
  required_plugins {
    arm = {
      version = ">= 1.0.9"
      source  = "github.com/mkaczanowski/arm"
    }
  }
}

source "arm" "ubuntu_server_arm64" {
  file_urls             = var.file_urls
  file_checksum_url     = var.file_checksum_url
  file_checksum_type    = "sha256"
  file_target_extension = "xz"
  file_unarchive_cmd    = ["xz", "--decompress", "$ARCHIVE_PATH"]
  image_build_method    = "reuse"
  image_path            = var.image_path
  image_size            = "4G"
  image_type            = "dos"
  image_partitions {
    name         = "boot"
    type         = "c"
    start_sector = "2048"
    filesystem   = "fat"
    size         = "256M"
    mountpoint   = "/boot/firmware"
  }
  image_partitions {
    name         = "root"
    type         = "83"
    start_sector = "526336"
    filesystem   = "ext4"
    size         = "2.8G"
    mountpoint   = "/"
  }
  image_chroot_env             = ["PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"]
  qemu_binary_source_path      = "/usr/bin/qemu-aarch64-static"
  qemu_binary_destination_path = "/usr/bin/qemu-aarch64-static"
}

build {
  sources = ["source.arm.ubuntu_server_arm64"]

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive"
    ]
    inline = [
      "rm -f /etc/resolv.conf",
      "echo 'nameserver 1.1.1.1' > /etc/resolv.conf",
      "apt-get update",
      "apt-get full-upgrade -y",
      "apt-get autoremove -y",
      "apt-get clean",
      "useradd --create-home --shell /bin/bash --groups sudo ansible",
      "echo 'ansible ALL=(ALL) NOPASS:ALL' > /etc/sudoers.d/ansible",
      "chmod 0440 /etc/sudoers.d/ansible",
      "visudo -cf /etc/sudoers.d/ansible",
      "mkdir -p /home/ansible/.ssh",
      "echo '${var.ssh_public_key}' > /home/ansible/.ssh/authorized_keys",
      "chown -R ansible:ansible /home/ansible/.ssh",
      "chmod 700 /home/ansible/.ssh",
      "chmod 600 /home/ansible/.ssh/authorized_keys",
      "rm -f /etc/resolv.conf",
      "ln -s ../run/systemd/resolve/stub-resolv.conf /etc/resolv.conf"
    ]
  }
}
