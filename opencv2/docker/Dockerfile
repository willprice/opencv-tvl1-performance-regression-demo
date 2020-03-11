FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04
LABEL maintainer="will.price94+docker@gmail.com"
ARG OPENCV_VERSION=2.4.13.6

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# software-properties-common provides add-apt-repository needed for
# adding PPAs
RUN apt-get update && \
    apt-get install -y wget software-properties-common apt-utils


RUN apt-get update && \
    apt-get install -y \
        build-essential \
        ninja-build \
        cmake \
        git \
        pkg-config \
        libopencv-dev \
        libtbb2 \
        libtbb-dev \
        libatlas-base-dev \
        gfortran \
        libgtk2.0-dev \
        libgtk-3-dev \
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        libavresample-dev \
        libxvidcore-dev \
        libx264-dev \
        gstreamer1.0-tools \
        gstreamer1.0-libav \
        gstreamer1.0-plugins-good \
        gstreamer1.0-plugins-bad \
        gstreamer1.0-plugins-ugly \
        libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-dev \
        libgstreamer-plugins-base1.0-0 \
        libgstreamer-plugins-good1.0-0 \
        libgstreamer-plugins-good1.0-dev \
        libgstreamer-plugins-bad1.0-0 \
        libgstreamer-plugins-bad1.0-dev \
        gstreamer1.0-libav \
        libxine2-dev \
        libv4l-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libjasper-dev \
        libdc1394-22-dev \
        python-dev \
        python-numpy \
        python3 \
        python3-pip \
        python3-numpy && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB && \
    apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB && \
    wget https://apt.repos.intel.com/setup/intelproducts.list -O /etc/apt/sources.list.d/intelproducts.list && \
    apt-get update && \
    apt-get install -y libeigen3-dev intel-mkl-2019.3-062 && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /src
WORKDIR /src
ARG CMAKE_BUILD_TYPE=Release
RUN apt-get install apt-transport-https ca-certificates gnupg software-properties-common wget && \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add - && \
    apt-add-repository 'deb https://apt.kitware.com/ubuntu/ xenial main' && \
    apt-add-repository 'deb https://apt.kitware.com/ubuntu/ xenial-rc main' && \
    apt-get update && \
    apt-get install -y kitware-archive-keyring cmake && \
    apt-key --keyring /etc/apt/trusted.gpg del C1F34CDD40CD72DA

RUN wget "https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip" -O opencv-${OPENCV_VERSION}.zip
RUN apt-get update && \
    apt-get install -y unzip && \
    unzip opencv-$OPENCV_VERSION && \
    mkdir -p opencv_build && \
    cd opencv_build && \
    cmake \
        -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D OPENCV_GENERATE_PKGCONFIG=on \
        -D PYTHON3_EXECUTABLE=python3 \
        -D WITH_FFMPEG=ON \
        -D WITH_CUDA=ON \
        -D WITH_CUBLAS=ON \
        -D CUDA_FAST_MATH=ON \
        -D ENABLE_FAST_MATH=ON \
        -D INSTALL_C_EXAMPLES=OFF \
        -D INSTALL_PYTHON_EXAMPLES=ON \
        -D BUILD_EXAMPLES=ON \
        -D BUILD_DOCS=OFF \
        -D CMAKE_LIBRARY_PATH=/usr/local/cuda/lib64/stubs \
        ../opencv-$OPENCV_VERSION && \
    make -j 8 && \
    make install && \
    cd / && rm -rf /src
# Mitigate issue with programs not being able to compile without
# static linking of cuda: -D CUDA_USE_STATIC_CUDA_RUNTIME=OFF
# See https://github.com/opencv/opencv/issues/6542 for more
RUN ln -s /usr/local/cuda/lib64/libcudart.so \
          /usr/local/lib/libopencv_dep_cudart.so
ENV LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"
