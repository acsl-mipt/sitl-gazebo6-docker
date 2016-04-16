set -e

cp /vagrant/sources.list /etc/apt/sources.list

#gazebo

apt-get update || true
apt-get install wget -y

echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list
wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -

apt-get update || true
apt-get install gazebo6 libgazebo6-dev gazebo6-plugin-base libgazebo6 -y

#sitl_gazebo

apt-get install libopencv-dev libeigen3-dev protobuf-compiler libprotobuf-dev libprotoc-dev software-properties-common -y

#px4

add-apt-repository ppa:george-edison55/cmake-3.x -y
apt-get update
apt-get install python-argparse git-core wget zip python-empy cmake build-essential genromfs -y

#clean
apt-get clean
