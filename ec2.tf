resource "aws_instance" "db" {
    ami = "ami-090252cbe067a9e58"
    vpc_security_group_ids = ["sg-00fdfc2b0e8a3e6e9"]
    instance_type = "t3.micro"

    provisioner "local-exec" { #It takes private IP and put it in the file (>> Append: Old text will be there))
        command = "echo ${self.private_ip} > private_ips.txt" #Self: is aws_instance.web
    }

    provisioner "local-exec" { #To configure any thing in server this will do
        command = "ansible-playbook -i private_ips.txt web.yaml"   
    }

    connection { # This is remote 
      type = "ssh"
      user = "ec2-user"
      password = "DevOps321"
      host = self.public_ip
    }

    provisioner "remote-exec" { # Here 1st connection will take
        inline = [ # Runs with ec2-user
            "sudo dnf install ansible -y",
            "sudo dnf install ansible -y",
            "sudo systemctl start nginx"

         ]
    }
}
# Provisioner; When our resources are created then only these provisioner's will run
# They will not run once the resource are created

# terraform apply -auto-approve #1st time will be created
# If run again # Error running command 'ansible-playbook -i private_ips.txt web.yaml': exit
#Why because?
# Ansible is not installed in my laptop. If I install ansible in linux server, clone this code then it will run there


#Provisioners are of 2 types
# local-exec and remote-exec 
#Local-exec is used to get any data locally, and to send any mail