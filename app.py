from flask import Flask, jsonify, send_file, request 
from flask_cors import CORS
import os

app = Flask(__name__)
CORS(app, resources={r"/api/*": {"origins": "*"}})

VIDEO_LOGS_DIR = r"C:/Users/Lenovo SSD/Downloads/project/cc_pro/"


LOG_DIR = os.path.dirname(os.path.abspath(__file__))  # Get script directory

def read_log_file(file_name):
    """Helper function to read log files safely."""
    log_path = os.path.join(LOG_DIR, file_name)
    if os.path.exists(log_path):
        with open(log_path, 'r', encoding='utf-8') as file:
            logs = [line.strip() for line in file.readlines()]  # Remove newlines
        return logs
    return []  # Return empty list if file does not exist

# ✅ Root Route (Fixes 404 error when accessing '/')
@app.route('/')
def home():
    return jsonify({'message': 'Flask API is running!', 'status': 'success'})

@app.route('/api/video_logs/<filename>', methods=['GET'])
def get_video(filename):
    video_path = os.path.join(VIDEO_LOGS_DIR, filename)
    
    if os.path.exists(video_path):
        return send_file(video_path, mimetype="video/mp4")  # or "video/x-msvideo" for AVI
    
    return jsonify({'error': 'File not found', 'status': 'failed'}), 404

# ✅ Drowsiness Logs Endpoint
@app.route('/api/drowsiness_logs', methods=['GET'])
def get_drowsiness_logs():
    logs = read_log_file('drowsiness_log.txt')
    return jsonify({'logs': logs, 'status': 'success', 'count': len(logs)})

# ✅ Yawning Logs Endpoint
@app.route('/api/yawning_logs', methods=['GET'])
def get_yawning_logs():
    logs = read_log_file('yawning_log.txt')
    return jsonify({'logs': logs, 'status': 'success', 'count': len(logs)})

# ✅ Video Logs Endpoint (List Available Video Files)
@app.route('/api/video_logs', methods=['GET'])
def list_video_logs():
    videos = [f for f in os.listdir(VIDEO_LOGS_DIR) if f.endswith(('.mp4', '.avi'))]
    
    return jsonify({
        'videos': videos,
        'message': 'Video logs retrieved successfully' if videos else 'No video logs found',
        'status': 'success'
    })

# ✅ Video Download Endpoint (Allow User to Download)
@app.route('/api/download_video', methods=['GET'])
def download_video():
    file_name = request.args.get('filename')  # Get filename from request
    
    if not file_name:
        return jsonify({'error': 'Filename parameter is required', 'status': 'failed'}), 400
    
    video_path = os.path.join(LOG_DIR, file_name)

    if os.path.exists(video_path):
        return send_file(video_path, as_attachment=True)

    return jsonify({'error': 'File not found', 'status': 'failed'}), 404

# ✅ Run Flask Server
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)