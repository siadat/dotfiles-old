ssh root@linode 'adduser sina && adduser sina sudo'
cat ~/.ssh/id_rsa.pub | ssh sina@linode 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys'
ssh sina@linode "sudo sed -i '/^PermitRootLogin yes$/s/yes/no/' /etc/ssh/sshd_config && sudo service ssh reload"
ssh sina@linode "sudo sed -i '/^#?PasswordAuthentication yes$/s/#?PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && sudo service ssh reload"

echo 'export LC_ALL="en_US.utf-8"' | ssh sina@linode 'cat >> ~/.bashrc'
ssh sina@linode 'sudo apt-get update && sudo apt-get install tmux git vim silversearcher-ag mosh'

cat | ssh sina@linode 'cat >> ~/.vimrc' <<- EOF
syntax on
set nowrapscan
set hlsearch
set nowrap
EOF

cat | ssh sina@linode 'cat >> ~/.gitconfig' <<- EOF
[user]
        email = ******@gmail.com
        name = Sina Siadat
EOF

