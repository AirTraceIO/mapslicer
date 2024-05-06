# MapSlicer Docker Container

This README provides instructions on how to build and run the Docker container for the MapSlicer project. This container is set up to run `gdal2tiles.py` to generate map tiles from a TIFF image without requiring georeferencing, using the raster profile.

## Requirements

- Docker installed on your machine.
- A geospatial TIFF image (`final.tif`) that you wish to convert into map tiles. The image should be placed in a directory named `data` at your working directory.

## Building the Docker Image

Before running the container, you need to build the Docker image. You can do this by navigating to the directory containing the Dockerfile and running the following command:

```bash
docker build -t mapslicer .
```
This command builds the Docker image and tags it as `mapslicer`.
## Running the Container

To generate map tiles from your TIFF image, use the following command:

```bash
docker run -v $(pwd)/data:/usr/src/app/data mapslicer --profile=raster --zoom 5 /usr/src/app/data/final.tif /usr/src/app/data/output_folder
```

This command mounts your local `data` directory to the `/usr/src/app/data` directory in the container. The `gdal2tiles.py` script reads the `final.tif` file from this directory and outputs the tiles to the `output_folder` within the same directory.

### Important Notes

- Ensure that your `data` directory contains the `final.tif` file before running the command.
- The `output_folder` will be created if it does not exist. If it exists, it will be overwritten.
- The `--profile=raster` option is used to allow tile generation without georeferenced data. If your TIFF file is georeferenced, you may omit this option.

## Troubleshooting

If you encounter errors related to GDAL not finding EPSG files, ensure the `GDAL_DATA` environment variable is set correctly in your Dockerfile to point to the directory containing the EPSG CSV files, typically `/usr/share/gdal`.

If there are permission issues with accessing the mounted directory, ensure that the user running Docker has the necessary permissions to access and write to the `data` directory on your host machine.

## Contributions

Contributions to this project are welcome. Please fork the repository, make your changes, and submit a pull request on GitHub.

## License

This project is licensed under the terms of the [BSD License](LICENSE).
