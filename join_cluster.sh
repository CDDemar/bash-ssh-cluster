#!/bin/bash
# Run me with superuser privileges
# If im not runnable write the following command in the prompt "chmod +x join_cluster.sh"
#   Translate dos to unix:
# sudo apt-get install dos2unix -y
# dos2unix test.sh
# sudo chmod u+x test.sh && sudo ./test.sh

clear
echo "---------------------------------------------------------"
echo "    Bienvenido al script de sincronizacion de cluster    "
echo " Cristhyan De Marchena - Cristhian Lopierre - Luis Parra "
echo "---------------------------------------------------------"
echo ""
echo ""
echo -e "Se asumira que la carpeta de red se llama [cloud]"
echo -e "se asumira que el usuario del master es [mpiuser]"
read -p "ip master: " MASTER
read -p "Nombre del slave: " SLAVENAME
read -p "ip de $SLAVENAME: " IPSLAVE
read -p "Nombre del usuario MPI del slave: " NEWMPIUSER
echo -e "$MASTER	Master" >> /etc/hosts
echo ""
echo ""

# Creating mpi user
adduser $NEWMPIUSER
adduser $NEWMPIUSER sudo
cd /home/mpiuser

# Installing ssh
apt-get install -y openssh-server

# Saving slave key into master
sudo -i -u $NEWMPIUSER cd /home/$NEWMPIUSER
sudo -i -u $NEWMPIUSER ssh-keygen -t rsa -f "/home/$NEWMPIUSER/.ssh/id_rsa"
sudo -i -u $NEWMPIUSER ssh-copy-id mpiuser@$MASTER

# Editing master hosts file
printf -v CONCAT "$IPSLAVE\t$SLAVENAME"
sudo -i -u $NEWMPIUSER ssh mpiuser@master "echo 1234 | sudo -S -- sh -c 'echo $CONCAT >> /etc/hosts'"
echo ""

# Installing NFS
sudo apt-get install -y nfs-common
cd /home/$NEWMPIUSER

# Sharing the cloud folder
mkdir cloud
sudo mount -t nfs master:/home/mpiuser/cloud /home/mpiuser/cloud
echo "master:/home/mpiuser/cloud /home/mpiuser/cloud nfs" >> /etc/fstab

# Installing MPI Py
apt-get install -y build-essentials
apt autoremove -y python
apt-get install -y python-setuptools
apt-get install -y python-dev python-pip
pip install mpi4py

wget http://www.mpich.org/static/downloads/3.2.1/mpich-3.2.1.tar.gz
tar -xzf mpich-3.2.1.tar.gz
cd mpich-3.2.1
./configure --disable-fortran
make; sudo make install

wget https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-2.0.0.tar.gz
tar xfz mpi4py-2.0.0.tar.gz
cd  mpi4py-2.0.0
apt-get install python-dev
python setup.py build
python setup.py install
export PYTHONPATH=/home/mpiuser/mpi4py-2.0.0

echo ""
echo ""
echo "---------------------------------------------------------"
echo "                 Se ha creado un mpiuser                 "
echo "       Se ha sincronizado la SSH Key con el master       "
echo "            Se ha sincronizado la carpeta NFS            "
echo "                Se ha instalado MPI python               "
echo "               ¡Sincronización completada!               "
echo " **No se olvide de hacer ssh-copy-id desde el master!**  "
echo "---------------------------------------------------------"
echo ""
echo ""
