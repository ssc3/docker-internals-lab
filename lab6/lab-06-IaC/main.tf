provider "digitalocean" {
  token = "${var.token}"
}

resource "digitalocean_droplet" "FirstNode" {
  count  = "1"
  image  = "${var.image}"
  name   = "ddcNode-1-${var.name}"
  region = "${var.region}"
  size   = "${var.size}"

  ssh_keys = [
    "${var.ssh_fingerprint}",
  ]

  connection {
    private_key = "${file("${var.pvt_key}")}"
  }

  provisioner "remote-exec" {
    script = "ddc-install.sh"
  }

  provisioner "local-exec" {
    command = "echo UCP URL: https://${digitalocean_droplet.FirstNode.ipv4_address} >> ips.txt"
  }
}

resource "digitalocean_droplet" "DTR" {
  count  = 1
  image  = "${var.image}"
  name   = "ddcNode-2-${var.name}"
  region = "${var.region}"
  size   = "${var.size}"

  ssh_keys = [
    "${var.ssh_fingerprint}",
  ]

  connection {
    private_key = "${file("${var.pvt_key}")}"
  }

  provisioner "file" {
    source      = "./dtr-join.sh"
    destination = "/root/dtr-join.sh"
  }

  provisioner "file" {
    source      = "./client-bundle/"
    destination = "/root/"
  }

  provisioner "remote-exec" {
    inline = [
      "export UCPIP=${digitalocean_droplet.FirstNode.ipv4_address}",
      "chmod +x /root/dtr-join.sh",
      "chmod +x /root/client-bundle.sh",
      "/root/dtr-join.sh",
    ]
  }

  provisioner "local-exec" {
    command = "echo DTR URL: https://${digitalocean_droplet.DTR.ipv4_address} >> ips.txt"
  }
}

resource "digitalocean_droplet" "WorkerNode" {
  count  = 1
  image  = "${var.image}"
  name   = "ddcNode-3-${var.name}"
  region = "${var.region}"
  size   = "${var.size}"

  ssh_keys = [
    "${var.ssh_fingerprint}",
  ]

  connection {
    private_key = "${file("${var.pvt_key}")}"
  }

  provisioner "file" {
    source      = "./training.key"
    destination = "/root/.ssh/id_rsa"
  }

  provisioner "file" {
    source      = "./worker-join.sh"
    destination = "/root/worker-join.sh"
  }

  provisioner "file" {
    source      = "./client-bundle/"
    destination = "/root/"
  }

  provisioner "remote-exec" {
    inline = [
      "export UCPIP=${digitalocean_droplet.FirstNode.ipv4_address}",
      "chmod +x /root/worker-join.sh",
      "chmod +x /root/client-bundle.sh",
      "/root/worker-join.sh",
    ]
  }
}
