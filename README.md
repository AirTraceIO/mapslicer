# MapSlicer Docker Container with Flask API

This README provides instructions on how to build and run the Docker container for the MapSlicer project, now set up to expose `gdal2tiles.py` functionality through a Flask API. This allows generating map tiles from a TIFF image without requiring georeferencing, using the raster profile.

## Requirements

- Docker installed on your machine.
- A geospatial TIFF image (`final.tif`) that you wish to convert into map tiles. The image should be placed in a directory named `data` at your working directory.

## Building the Docker Image

Before running the container, you need to build the Docker image. You can do this by navigating to the directory containing the Dockerfile and running the following command:

```bash
docker build -t gdal-flask-api .
```
This command builds the Docker image and tags it as `gdal-flask-api`.

## Running the Container

To run the Flask API that provides access to the `gdal2tiles.py` functionality, use the following command:

```bash
docker run -p 5000:5000 -v $(pwd)/data:/usr/src/app/data gdal-flask-api

```
This command does the following:
- Maps port `5000` of the container to port `5000` on the host, allowing the Flask application to be accessed via `localhost:5000`.
- This command mounts your local `data` directory to the `/usr/src/app/data` directory in the container. The `gdal2tiles.py` script reads the `final.tif` file from this directory and outputs the tiles to the `output_folder` within the same directory.

### Using the Flask API to Generate Map Tiles

Once the Docker container is running, you can generate map tiles by sending a POST request to the Flask app. Here is an example using `curl`: 

```bash
curl -X POST http://localhost:5000/process \
     -H "Content-Type: application/json" \
     -d '{
           "profile": "raster",
           "zoom": 5,
           "input_file": "final.tif",
           "output_folder": "output_folder"
         }'
```

In this request:

- `"profile": "raster"` specifies that the raster profile should be used.
- `"zoom": 5` sets the zoom level to 5.
- `"input_file": "final.tif"` specifies the input TIFF file located in the mounted `data` directory.
- `"output_folder": "output_folder"` specifies the directory where the output tiles will be stored, relative to the mounted `data` directory.

### Important Notes

- Ensure that your `data` directory contains the `final.tif` file before running the container and making the API call.
- The `output_folder` will be created if it does not exist. If it exists, it will be overwritten.
- The API uses default values for `profile` and `zoom` if they are not specified in the request.

## Troubleshooting

If you encounter errors related to GDAL not finding EPSG files, ensure the `GDAL_DATA` environment variable is set correctly in your Dockerfile to point to the directory containing the EPSG CSV files, typically `/usr/share/gdal`.

If there are permission issues with accessing the mounted directory, ensure that the user running Docker has the necessary permissions to access and write to the `data` directory on your host machine.

## Contributions

Contributions to this project are welcome. Please fork the repository, make your changes, and submit a pull request on GitHub.

## License

This project is licensed under the terms of the [BSD License](LICENSE).
