
//Null resource which triggers to recreate Chat App Instance when Bastion Host is changed.
resource "null_resource" "bastion_trigger" {
  triggers = {
    chatbastpubip = var.chatbastpubip
  }
}



resource "aws_instance" "chatapp3"{
    ami=var.amiid
    instance_type=var.instancetype
    subnet_id=var.prisub["aid"]
    vpc_security_group_ids=[var.sgs["app"]]
    key_name=var.keyname
    tags={
        Name="chatapp3"
    }

    lifecycle {
    replace_triggered_by = [
      null_resource.bastion_trigger
    ]
  }



    connection {
        type="ssh"
        host=self.private_ip
        user="ubuntu"
        private_key=file(var.path_to_prikey)
        timeout="4m"
        bastion_host=var.chatbastpubip
        bastion_user="ubuntu"
        bastion_private_key=file(var.path_to_prikey)
    }

    provisioner "remote-exec" {
        inline = [
            "mkdir shane"
        ]
    }

}
