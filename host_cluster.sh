#!/bin/bash
# Run me with superuser privileges
# If im not runnable write the following command in the prompt "chmod +x host_cluster.sh"
#   Translate dos to unix:
# sudo apt-get install dos2unix -y
# dos2unix test.sh
# sudo chmod u+x test.sh && sudo ./test.sh

clear
echo "---------------------------------------------------------"
echo "      Bienvenido al script de generacion del master      "
echo " Cristhyan De Marchena - Cristhian Lopierre - Luis Parra "
echo "---------------------------------------------------------"
echo ""
echo ""
echo -e "Se asumira que la carpeta de red se llamara [cloud]"
echo -e "se asumira que el usuario que contenga la carpeta de red se llamara: [mpiuser]"
echo ""
echo ""

# Creating mpi user
adduser mpiuser
adduser mpiuser sudo

# Installing ssh
apt-get install -y openssh-server

# Generating rsa key
sudo -i -u mpiuser cd /home/mpiuser
sudo -i -u mpiuser ssh-keygen -t rsa -f "/home/mpiuser/.ssh/id_rsa"

# Installing NFS Kernel Server and setting up cloud folder.
apt-get install -y nfs-kernel-server
sudo -i -u mpiuser mkdir /home/mpiuser/cloud
echo "/home/mpiuser/cloud *(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
exportfs -a
service nfs-kernel-server restart

# Installing MPI Python!
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
echo "            Generacion del master finalizada!            "
echo "---------------------------------------------------------"
echo ""
echo ""
