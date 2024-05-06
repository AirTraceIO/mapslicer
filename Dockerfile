# Use an Ubuntu base image with Python 2.7 installed
FROM ubuntu:18.04

# Install Python and pip
RUN apt-get update && apt-get install -y \
    python2.7 \
    python-pip \
    software-properties-common

# Install necessary libraries for GDAL and wxPython
RUN apt-get install -y \
    libgdal-dev \
    gdal-bin \
    python-wxgtk3.0 \
    python-wxtools \
    libgtk2.0-0 \
    libgtk-3-0 \
    && rm -rf /var/lib/apt/lists/*

# Set GDAL environment variables
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal
ENV GDAL_DATA=/usr/share/gdal
ENV PYTHONPATH=$PYTHONPATH:/usr/lib/python2.7/dist-packages

# Install Python GDAL bindings
RUN pip install GDAL==$(gdal-config --version) --global-option=build_ext --global-option="-I/usr/include/gdal"

# Copy the local directory contents into the container at /usr/src/app
COPY . /usr/src/app

# Set the working directory in the container
WORKDIR /usr/src/app

# Define entry point for running the gdal2tiles script
ENTRYPOINT ["python", "mapslicer/gdal2tiles.py"]

# Default command to display the usage of gdal2tiles.py
CMD ["--help"]

