FROM ubuntu:trusty

COPY home /vagrant/home/
COPY sources.list /vagrant/sources.list
COPY install_deps.sh /vagrant/home/install_deps.sh

WORKDIR /vagrant/home/

RUN chmod +x install_deps.sh
RUN ./install_deps.sh

RUN cp -r /vagrant/home/* ~ \
  && chmod +x ~/*.sh \
  && cd /vagrant/home \
  && git clone --depth 1 -b stable_multiple_sitl https://github.com/acsl-mipt/Firmware

RUN cd Firmware && make posix_sitl_default

RUN cd /vagrant/home && git clone --depth 1 -b multiple_sitl https://github.com/acsl-mipt/sitl_gazebo

RUN cd sitl_gazebo && mkdir -p Build && cd Build && cmake .. \
  && make rotors_gazebo_imu_plugin rotors_gazebo_mavlink_interface rotors_gazebo_motor_model rotors_gazebo_multirotor_base_plugin

RUN cd /vagrant/home && cp -r sitl_gazebo/models client/ \
  && cp -r irisN client/models && tar -czf client.tar.gz client/

RUN chmod +x /vagrant/home/start-multiple-px4-gzserver.sh

RUN cat /vagrant/home/start-multiple-px4-gzserver.sh

WORKDIR /vagrant/home/

EXPOSE 15010 15011 15015 15016

CMD /vagrant/home/start-multiple-px4-gzserver.sh
