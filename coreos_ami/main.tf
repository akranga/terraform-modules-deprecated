data "aws_ami" "coreos" {
    filter {
        name = "virtualization-type"
        values = [ "${var.virtualization_type}" ]
    }
    filter {
        name = "state"
        values = [ "available" ]
    }
    filter {
        name = "architecture"
        values = [ "x86_64" ]
    }
    filter {
        name = "image-type"
        values = [ "machine" ]
    }
    filter {
        name = "name"
        values = [ "CoreOS-${var.release_channel}-*" ]
    }

    owners = [ "595879546273" ]
    most_recent = true
}