# Use an Ubuntu base image with Python 2.7 installed
FROM ubuntu:18.04

# Install Python, pip, and other necessary packages
RUN apt-get update && apt-get install -y \
    python2.7 \
    python-pip \
    software-properties-common \
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

# Install Python GDAL bindings and Flask
RUN pip install Flask GDAL==$(gdal-config --version)

# Copy the local directory contents into the container at /usr/src/app
COPY . /usr/src/app

# Set the working directory in the container
WORKDIR /usr/src/app

# Flask app port
EXPOSE 5000

# Define entry point and command to run the Flask app
ENTRYPOINT ["python"]
CMD ["app.py"]
