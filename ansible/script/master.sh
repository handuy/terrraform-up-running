#!/bin/bash
amazon-linux-extras install epel -y
yum update -y
yum install ansible -y

su - ec2-user -c "ssh-keygen -t rsa -N '' -f /home/ec2-user/.ssh/id_rsa <<< y"
su - ec2-user -c "sshpass -p 'ansible' ssh-copy-id -i /home/ec2-user/.ssh/id_rsa.pub -o StrictHostKeyChecking=no ansible@${private_ip}"

echo "slave ansible_host=${private_ip} ansible_user=ansible" >> /home/ec2-user/hosts

su - ec2-user -c "wget https://raw.githubusercontent.com/handuy/terrraform-up-running/master/playbook.yml"

# ansible-playbook -i hosts play.yml -K

# ansible-vault create secrets
# echo "ec2" >> vault-pass 
# ansible-playbook -i hosts play.yml -e @secrets --vault-password-file vault-pass 