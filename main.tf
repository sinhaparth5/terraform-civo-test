terraform {
 required_providers {
    civo = {
      source = "civo/civo"
      version = "~> 1.0"
    }
 }
}

provider "civo" {
 token = "AAXNsRk1WChEPQIJYmQ3L99l3OGfrjsq5iAYDFX6i1UWhMSRbc"
}

resource "civo_instance" "test_instance" {
 hostname     = "test-instance"
 size         = "g3.xsmall"
 disk_image   = "ubuntu-jammy"
 region       = "LON1"
}

resource "null_resource" "install_nginx" {
 depends_on = [civo_instance.test_instance]

 connection {
    type        = "ssh"
    user        = "root"
    private_key = file("~/.ssh/id_rsa.pub")
    host        = civo_instance.test_instance.public_ip
 }

 provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get install -y nginx",
      "systemctl start nginx",
      "systemctl enable nginx"
    ]
 }
}
