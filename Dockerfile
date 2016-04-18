FROM ubuntu:trusty

COPY root /root/
COPY sources.list /root/sources.list
COPY install_deps.sh /root/install_deps.sh

RUN cd /root/ && chmod +x *.sh && sleep 1 && ./install_deps.sh

RUN git clone --depth 1 -b stable_multiple_sitl https://github.com/acsl-mipt/Firmware \
  && cd Firmware && make posix_sitl_default

RUN cd /root && git clone --depth 1 -b multiple_sitl https://github.com/acsl-mipt/sitl_gazebo sitl_gazebo_src \
  && cp -r sitl_gazebo_src/models client/ \
  && mkdir -p sitl_gazebo \
  && cd sitl_gazebo && cmake ../sitl_gazebo_src \
  && make rotors_gazebo_imu_plugin rotors_gazebo_mavlink_interface rotors_gazebo_motor_model rotors_gazebo_multirotor_base_plugin \
  && rm -rf ../sitl_gazebo_src

RUN cd /root \
  && cp -r irisN client/models && tar -czf client.tar.gz client/

EXPOSE 15010 15011 15015 15016

WORKDIR /root

CMD ./start-multiple-px4-gzserver.sh
