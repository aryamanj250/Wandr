"""
Main API routes for Wandr Backend.
Contains health check and basic API endpoints.
"""

from flask import Blueprint, jsonify, request, current_app
from datetime import datetime
import sys
import platform
import json
import threading
import uuid
import multiprocessing # Import multiprocessing
import os # Import os for path operations
import time # Import time for polling

from app.services.gemini_service import GeminiService

# Create API blueprint
api_bp = Blueprint('api', __name__)

# Directory to store task results (for demonstration purposes)
# In a production environment, consider Redis, a database, or a dedicated task queue
TASK_RESULTS_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'tmp', 'task_results')
os.makedirs(TASK_RESULTS_DIR, exist_ok=True) # Ensure the directory exists

# Helper function to get task file path
def get_task_file_path(task_id):
    return os.path.join(TASK_RESULTS_DIR, f"{task_id}.json")

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

# Moved to top level to be accessible by multiprocessing
def _process_gemini_in_background_process(text, task_id, api_key, file_path):
    """
    This function runs in a separate process to handle the Gemini API call.
    It updates the task status file with the progress and result.
    """
    try:
        # Update status to 'processing'
        with open(file_path, 'w') as f:
            json.dump({'status': 'processing', 'result': None, 'error': None}, f)
        
        print(f"Task {task_id}: Processing text with Gemini...", file=sys.stderr)
        print(f"Task {{task_id}}: Input text for Gemini: '{{text}}'", file=sys.stderr)
        
        # Call the Gemini service to process the text
        gemini_result_text = GeminiService.process_text_command(text, api_key)
        
        print(f"Task {{task_id}}: Received response from Gemini.", file=sys.stderr)
        print(f"Task {{task_id}}: Raw response from Gemini: '{{gemini_result_text}}'", file=sys.stderr)

        # Clean the response from Gemini to ensure it's valid JSON
        cleaned_text = gemini_result_text.strip()
        if cleaned_text.startswith("```json"):
            # Remove the starting ```json marker
            cleaned_text = cleaned_text[7:]
        if cleaned_text.endswith("```"):
            # Remove the ending ``` marker
            cleaned_text = cleaned_text[:-3]
        
        # Strip any remaining whitespace
        cleaned_text = cleaned_text.strip()

        # The Gemini service is expected to return a JSON string.
        # We parse it here to store it as a structured object.
        try:
            result_data = json.loads(cleaned_text)
        except json.JSONDecodeError:
            # If Gemini's output isn't valid JSON, we log the issue
            # and store the raw text for debugging.
            print(f"Task {task_id}: Gemini output was not valid JSON even after cleaning.", file=sys.stderr)
            result_data = {
                'raw_output': gemini_result_text, # store original output
                'parsing_error': 'Gemini output could not be parsed as JSON.'
            }

        # Write the final result to the task file
        with open(file_path, 'w') as f:
            json.dump({'status': 'completed', 'result': result_data, 'error': None}, f)
        
        print(f"Task {task_id} completed successfully.", file=sys.stderr)

    except Exception as e:
        error_message = f"Error in background process for task {task_id}: {e}"
        print(error_message, file=sys.stderr)
        
        # Write the failure status to the task file
        with open(file_path, 'w') as f:
            json.dump({
                'status': 'failed',
                'result': None,
                'error': {
                    'type': type(e).__name__,
                    'message': 'An error occurred in the background Gemini process.',
                    'details': str(e)
                }
            }, f)

@api_bp.route('/process-text-command', methods=['POST'])
def process_text_command():
    """
    Endpoint to process transcribed text commands using Gemini.
    Expects a JSON payload with 'text' field.
    Initiates asynchronous processing and returns a task ID.
    """
    print("Received request to /process-text-command") # Debug print
    try:
        data = request.get_json()
        if not data:
            return jsonify({'error': 'Invalid JSON', 'message': 'Request must contain a JSON body.'}), 400

        text_input = data.get('text')
        if not text_input:
            return jsonify({'error': 'Missing Text', 'message': 'JSON payload must contain a "text" field.'}), 400
        
        if not isinstance(text_input, str):
            return jsonify({'error': 'Invalid Text Format', 'message': 'The "text" field must be a string.'}), 400

        if not text_input.strip():
            return jsonify({'error': 'Empty Text', 'message': 'The "text" field cannot be empty.'}), 400

        task_id = str(uuid.uuid4())
        task_file_path = get_task_file_path(task_id)

        # Initialize task status in file
        with open(task_file_path, 'w') as f:
            json.dump({'status': 'pending', 'result': None, 'error': None}, f)

        # Get API key from current_app.config in the main thread
        gemini_api_key = current_app.config.get('GEMINI_API_KEY')
        if not gemini_api_key:
            # Clean up the task file if API key is missing
            if os.path.exists(task_file_path):
                os.remove(task_file_path)
            return jsonify({'error': 'Configuration Error', 'message': 'GEMINI_API_KEY is not configured.'}), 500

        # Start the background process, passing the API key and file path directly
        # Using multiprocessing.Process for true process isolation, better for Gunicorn
        process = multiprocessing.Process(target=_process_gemini_in_background_process, args=(text_input, task_id, gemini_api_key, task_file_path))
        process.daemon = True # Allow the main program to exit even if the process is still running
        process.start()

        return jsonify({
            'message': 'Command processing initiated',
            'task_id': task_id,
            'status': 'pending'
        }), 202

    except Exception as e:
        current_app.logger.error(f"Error in process_text_command endpoint: {e}")
        return jsonify({
            'error': 'Bad Request',
            'message': 'An error occurred while parsing your request.',
            'details': str(e)
        }), 400

@api_bp.route('/get-command-result/<task_id>', methods=['GET'])
def get_command_result(task_id):
    """
    Endpoint to retrieve the result of an asynchronously processed text command.
    Reads the result from a file.
    """
    task_file_path = get_task_file_path(task_id)
    
    if not os.path.exists(task_file_path):
        return jsonify({'error': 'Task Not Found', 'message': f'No task found with ID: {task_id}'}), 404
    
    try:
        with open(task_file_path, 'r') as f:
            task_info = json.load(f)
        return jsonify(task_info), 200
    except json.JSONDecodeError as e:
        return jsonify({
            'error': 'Task File Corrupted',
            'message': 'The task result file could not be read.',
            'details': str(e)
        }), 500
    except Exception as e:
        current_app.logger.error(f"Error reading task result file {task_id}: {e}")
        return jsonify({
            'error': 'Internal Server Error',
            'message': 'An unexpected error occurred while retrieving task result.',
            'details': str(e)
        }), 500


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
