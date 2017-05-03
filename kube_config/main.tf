data "template_file" "kubeconfig" {
  template = <<END
#!/bin/sh

kubectl config set-cluster ${cluster} \
  --server=${server} \
  --certificate-authority=${ca_pem}

kubectl config set-credentials admin@${cluster} \
  --certificate-authority=${ca_pem} \
  --client-key=${client_key} \
  --client-certificate=${client_pem}

kubectl config set-context ${cluster}  \
  --cluster=${cluster} \
  --user=admin@${cluster}

kubectl config use-context ${cluster}
END

  vars {
    cluster    = "${element(split(":", element(split("://", "${var.server}"), 1)), 0)}"
    server     = "${var.server}"
    ca_pem     = "${local_file.ca_pem.filename}"
    client_key = "${local_file.client_key.filename}"
    client_pem = "${local_file.client_pem.filename}"
  }
}

data "template_file" "kubeconfig_delete" {
  template = <<END
#!/bin/sh
kubectl config delete-context ${cluster}
kubectl config delete-context ${cluster}
END

  vars {
    cluster    = "${element(split(":", element(split("://", "${var.server}"), 1)), 0)}"
  }
}

resource "local_file" "client_pem" {
  content  = "${var.client_pem}"
  filename = "${path.module}/.terrraform/client.pem"
}

resource "local_file" "client_key" {
  content  = "${var.client_key}"
  filename = "${path.module}/.terrraform/client-key.pem"
}

resource "local_file" "ca_pem" {
  content  = "${var.ca_pem}"
  filename = "${path.module}/.terrraform/ca.pem"
}

resource "local_file" "configure" {
  content  = "${data.template_file.kubeconfig.rendered}"
  filename = "${path.module}/.terrraform/kubeconfig.sh"
  provisioner "local-exec" {
    command = "${chmod +x this.filename}"
  }
}

resource "local_file" "unconfigure" {
  content  = "${data.template_file.kubeconfig_delete.rendered}"
  filename = "${path.module}/.terrraform/kubeconfig-delete.sh"
  provisioner "local-exec" {
    command = "${chmod +x this.filename}"
  }
}

resource "null_resource" "configure" {
  depends_on = ["local_file.configure",
                "local_file.unconfigure"]

  provisioner "local-exec" {
    command = "[ ${var.apply} -eq "true" ] && sh ${local_file.configure.filename}"
  }

  provisioner "local-exec" {
    on_failure = "continue"
    when = "destroy"
    command = "[ ${var.apply} -eq "true" ] && sh ${local_file.unconfigure.filename}"
  }
}


