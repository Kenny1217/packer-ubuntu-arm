variable "file_urls" {
  type        = list(string)
  description = "Ubuntu Server preinstalled arm64+raspi image."
  default     = ["https://cdimage.ubuntu.com/releases/26.04/release/ubuntu-26.04.1-preinstalled-server-arm64+raspi.img.xz"]
}

variable "file_checksum_url" {
  type        = string
  description = "SHA256SUMS file published with the image."
  default     = "https://cdimage.ubuntu.com/releases/26.04/release/SHA256SUMS"
}

variable "image_path" {
  type        = string
  description = "Where the built image is written."
  default     = "../output/ubuntu_server_arm64.img"
}

variable "ssh_public_key" {
  type        = string
  description = "Public key installed for the ansible user."
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHAgQz8pncTKfkUgAvTlQJ+zoPFWHmq7DMrkRxV7XuB1 ansible"
}
