from flask import Flask, request, jsonify
import subprocess
import os

app = Flask(__name__)


@app.route('/processTiles', methods=['POST'])
def process():
    # Parse request data
    data = request.json
    profile = data.get('profile', 'raster')  # Default profile is 'raster'
    zoom = data.get('zoom', 5)  # Default zoom level is 5
    input_file = data.get('input_file')
    output_folder = data.get('output_folder')

    # Ensure the input file and output folder are provided
    if not input_file or not output_folder:
        return jsonify({'error': 'Missing input_file or output_folder'}), 400

    # Construct the full paths to the input and output
    input_path = os.path.join('/usr/src/app/data', input_file)
    output_path = os.path.join('/usr/src/app/data', output_folder)

    # Call the gdal2tiles script
    try:
        subprocess.check_call([
            'python', 'mapslicer/gdal2tiles.py',
            '--profile=' + profile,
            '--zoom=' + str(zoom),
            input_path,
            output_path
        ])
        return jsonify({'message': 'Processing completed successfully'}), 200
    except subprocess.CalledProcessError as e:
        return jsonify({'error': str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
