#### Use latest Ubuntu LTS release as the base
FROM ubuntu:bionic

# Update base container install
RUN apt-get update
RUN apt-get upgrade -y

# Install GDAL dependencies
RUN apt-get install -y python3-pip libgdal-dev locales netcat

# Ensure locales configured correctly
RUN locale-gen en_US.UTF-8
ENV LC_ALL='en_US.utf8'

# Set python aliases for python3
RUN echo 'alias python=python3' >> ~/.bashrc
RUN echo 'alias pip=pip3' >> ~/.bashrc

# Update C env vars so compiler can find gdal
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

COPY ./requirements.txt /requirements.txt
WORKDIR /app

# Before installing GDAL we need to install the requirements
RUN pip3 install -r /requirements.txt

# This will install latest version of GDAL
RUN pip3 install GDAL==$(gdal-config --version) --global-option=build_ext --global-option="-I/usr/include/gdal"

CMD ["python3", "app.py"]