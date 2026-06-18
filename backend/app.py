from flask import Flask, jsonify
from flask_cors import CORS
import os

app = Flask(__name__)
CORS(app)

@app.route('/api/health', methods=['GET'])
def health_check():
    return jsonify({
        "status": "healthy",
        "database_connected": True,
        "environment": os.getenv("FLASK_ENV", "development"),
        "message": "DevOps Microservices Pipeline Active!"
    }), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)