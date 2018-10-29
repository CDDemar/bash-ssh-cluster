#!/bin/bash

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

wget https://bitbucket.org/mpi4py/mpi4py/donwloads/mpi4py-2.0.0.tar.gz
tar -xzf mpi4py-2.0.0.tar.gz
cd mpi4py-2.0.0
python setup.py build
python setup.py install
export PYTHONPATH=/home/mpiuser/mpi4py-2.0.0
