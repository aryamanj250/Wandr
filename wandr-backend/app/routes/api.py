"""
Main API routes for Wandr Backend.
Contains health check and basic API endpoints.
"""

from flask import Blueprint, jsonify, request
from datetime import datetime
import sys
import platform

# Create API blueprint
api_bp = Blueprint('api', __name__)

@api_bp.route('/health', methods=['GET'])
def health_check():
    """
    Health check endpoint to verify server is running.
    
    Returns:
        JSON response with server status and basic info
    """
    return jsonify({
        'status': 'healthy',
        'message': 'Wandr Backend is running successfully',
        'timestamp': datetime.utcnow().isoformat(),
        'version': '1.0.0',
        'service': 'wandr-backend'
    })

@api_bp.route('/status', methods=['GET'])
def api_status():
    """
    Detailed API status endpoint with system information.
    
    Returns:
        JSON response with detailed system information
    """
    return jsonify({
        'api': {
            'name': 'Wandr Multi-Agent Travel System',
            'version': '1.0.0',
            'status': 'operational',
            'endpoints': {
                'health': '/api/v1/health',
                'status': '/api/v1/status',
                'future_agents': '/api/v1/agents (coming soon)',
                'future_nlp': '/api/v1/nlp (coming soon)',
                'future_booking': '/api/v1/booking (coming soon)'
            }
        },
        'system': {
            'python_version': sys.version,
            'platform': platform.platform(),
            'architecture': platform.machine(),
            'timestamp': datetime.utcnow().isoformat()
        },
        'features': {
            'multi_agent_system': 'planned',
            'nlp_processing': 'planned',
            'voice_recognition': 'planned',
            'booking_automation': 'planned',
            'payment_processing': 'planned',
            'real_time_updates': 'planned'
        }
    })

@api_bp.route('/config', methods=['GET'])
def get_config_info():
    """
    Get non-sensitive configuration information.
    
    Returns:
        JSON response with public configuration details
    """
    from flask import current_app
    
    return jsonify({
        'environment': current_app.config.get('FLASK_ENV', 'unknown'),
        'debug_mode': current_app.config.get('DEBUG', False),
        'cors_origins': current_app.config.get('CORS_ORIGINS', []),
        'features': {
            'cors_enabled': True,
            'json_pretty_print': current_app.config.get('JSONIFY_PRETTYPRINT_REGULAR', False),
            'session_security': {
                'httponly': current_app.config.get('SESSION_COOKIE_HTTPONLY', True),
                'secure': current_app.config.get('SESSION_COOKIE_SECURE', False),
                'samesite': current_app.config.get('SESSION_COOKIE_SAMESITE', 'Lax')
            }
        }
    })

@api_bp.route('/test', methods=['GET', 'POST'])
def test_endpoint():
    """
    Test endpoint for development and debugging.
    Accepts both GET and POST requests.
    
    Returns:
        JSON response with request information
    """
    response_data = {
        'method': request.method,
        'timestamp': datetime.utcnow().isoformat(),
        'headers': dict(request.headers),
        'args': dict(request.args),
        'endpoint': request.endpoint,
        'url': request.url,
        'message': 'Test endpoint working correctly'
    }
    
    if request.method == 'POST':
        response_data['json_data'] = request.get_json() if request.is_json else None
        response_data['form_data'] = dict(request.form) if request.form else None
    
    return jsonify(response_data)

# Error handler specific to this blueprint
@api_bp.errorhandler(404)
def api_not_found(error):
    """Handle 404 errors for API routes."""
    return jsonify({
        'error': 'API Endpoint Not Found',
        'message': f'The API endpoint {request.path} was not found.',
        'available_endpoints': [
            '/api/v1/health',
            '/api/v1/status',
            '/api/v1/config',
            '/api/v1/test'
        ],
        'status_code': 404
    }), 404

@api_bp.errorhandler(405)
def method_not_allowed(error):
    """Handle 405 errors for API routes."""
    return jsonify({
        'error': 'Method Not Allowed',
        'message': f'The method {request.method} is not allowed for {request.path}.',
        'status_code': 405
    }), 405
