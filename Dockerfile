
# FROM ubuntu:focal
FROM mxzinke/opencv-cmake
# FROM tensorflow/tensorflow:latest

WORKDIR /dependencies/

# # Install OpenCV dependencies
# ARG DEBIAN_FRONTEND=noninteractive
# RUN apt-get update -y && \
#   apt-get install -y build-essential curl wget git pkg-config libgtk-3-dev \
#   libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
#   libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev \
#   gfortran openexr libatlas-base-dev python3-dev python3-numpy \
#   libtbb2 libtbb-dev libdc1394-22-dev

# # install CMake
# RUN apt-get remove --purge --auto-remove cmake
# RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
# RUN echo 'deb https://apt.kitware.com/ubuntu/ focal main' >> /etc/apt/sources.list
# RUN apt-get update && apt-get install -y cmake

# # Install OpenCV
# RUN apt-get install unzip

# RUN curl -LO https://github.com/opencv/opencv_contrib/archive/4.5.0.zip \
#   && unzip 4.5.0.zip \
#   && rm 4.5.0.zip
# RUN curl -LO https://github.com/opencv/opencv/archive/4.5.0.zip \
#   && unzip 4.5.0.zip \
#   && rm 4.5.0.zip
# RUN mkdir -p /dependencies/opencv-4.5.0/build && cd /dependencies/opencv-4.5.0/build
# RUN cmake /dependencies/opencv-4.5.0/ -D CMAKE_BUILD_TYPE=RELEASE \
#   -D CMAKE_INSTALL_PREFIX=/usr/local \
#   -D OPENCV_GENERATE_PKGCONFIG=ON \
#   -D OPENCV_EXTRA_MODULES_PATH=/dependencies/opencv_contrib-4.5.0/modules
# RUN cmake --build .
# # optimized for 4 cores!
# RUN make -j4
# RUN make install
# RUN rm -r /dependencies/opencv-4.5.0 \
#   && rm -r /dependencies/opencv_contrib-4.5.0

# Install bazel
RUN apt-get install curl gnupg
RUN curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor > bazel.gpg
RUN mv bazel.gpg /etc/apt/trusted.gpg.d/
RUN echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
RUN apt-get update && apt-get install bazel -y
#RUN apt-get update && apt-get full-upgrade

# Install Tensorflow
RUN apt-get install -y python3-pip
RUN pip3 install -U pip numpy wheel
RUN pip3 install -U keras_preprocessing --no-deps

RUN cd /dependencies
RUN git clone https://github.com/tensorflow/tensorflow.git
RUN cd tensorflow
# RUN cd tensorflow
# RUN git checkout r2.3
RUN ls
RUN ./tensorflow/configure
RUN bazel build //tensorflow/tools/pip_package:build_pip_package
RUN ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
RUN ls /tmp/tensorflow_pkg
# RUN pip install /tmp/tensorflow_pkg/tensorflow-version-tags.whl
