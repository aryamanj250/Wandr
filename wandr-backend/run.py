"""
Wandr Backend Application Runner.
Entry point for running the Flask application.
"""

import os
from app import create_app
from app.config import get_config

# Create Flask application
app = create_app()

if __name__ == '__main__':
    # Get configuration for host and port
    config_class = get_config()
    host = config_class.HOST
    port = config_class.PORT
    debug = config_class.DEBUG
    
    print(f"""
    🚀 Starting Wandr Backend Server
    ================================
    Environment: {os.getenv('FLASK_ENV', 'development')}
    Host: {host}
    Port: {port}
    Debug: {debug}
    
    API Endpoints:
    - Health Check: http://{host}:{port}/api/v1/health
    - Status: http://{host}:{port}/api/v1/status
    - Config: http://{host}:{port}/api/v1/config
    - Test: http://{host}:{port}/api/v1/test
    
    Ready for iOS app connections! 📱
    """)
    
    app.run(
        host=host,
        port=port,
        debug=debug,
        threaded=True
    )
