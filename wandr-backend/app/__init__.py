"""
Wandr Backend Application Factory.
Creates and configures the Flask application using the factory pattern.
"""

from flask import Flask, jsonify
from flask_cors import CORS
from app.config import get_config

def create_app(config_name=None):
    """
    Create and configure Flask application.
    
    Args:
        config_name (str): Configuration name ('development', 'production', 'testing')
        
    Returns:
        Flask: Configured Flask application
    """
    app = Flask(__name__)
    
    # Load configuration
    config_class = get_config(config_name)
    app.config.from_object(config_class)
    
    # Initialize configuration
    config_class.init_app(app)
    
    # Initialize extensions
    init_extensions(app)
    
    # Register blueprints
    register_blueprints(app)
    
    # Register error handlers
    register_error_handlers(app)
    
    # Register CLI commands (for future use)
    register_cli_commands(app)
    
    return app

def init_extensions(app):
    """Initialize Flask extensions."""
    
    # Initialize CORS for iOS app communication
    CORS(app, 
         origins=app.config['CORS_ORIGINS'],
         methods=app.config['CORS_METHODS'],
         allow_headers=app.config['CORS_ALLOW_HEADERS'],
         supports_credentials=True)
    
    # Future extensions will be initialized here:
    # db.init_app(app)
    # socketio.init_app(app)
    # redis_client.init_app(app)

def register_blueprints(app):
    """Register application blueprints."""
    
    # Import and register the API blueprint
    from app.routes.api import api_bp
    app.register_blueprint(api_bp, url_prefix='/api/v1')
    
    # Future agent blueprints will be registered here:
    # from app.blueprints.agents import agents_bp
    # app.register_blueprint(agents_bp, url_prefix='/api/v1/agents')

def register_error_handlers(app):
    """Register application error handlers."""
    
    @app.errorhandler(404)
    def not_found(error):
        """Handle 404 errors."""
        return jsonify({
            'error': 'Not Found',
            'message': 'The requested resource was not found.',
            'status_code': 404
        }), 404
    
    @app.errorhandler(500)
    def internal_error(error):
        """Handle 500 errors."""
        return jsonify({
            'error': 'Internal Server Error',
            'message': 'An internal server error occurred.',
            'status_code': 500
        }), 500
    
    @app.errorhandler(400)
    def bad_request(error):
        """Handle 400 errors."""
        return jsonify({
            'error': 'Bad Request',
            'message': 'The request was malformed or invalid.',
            'status_code': 400
        }), 400

def register_cli_commands(app):
    """Register custom CLI commands."""
    
    @app.cli.command()
    def init_db():
        """Initialize the database."""
        click.echo('Initializing database...')
        # Future database initialization logic
        click.echo('Database initialized successfully!')
    
    @app.cli.command()
    def test():
        """Run the unit tests."""
        import unittest
        tests = unittest.TestLoader().discover('tests')
        unittest.TextTestRunner(verbosity=2).run(tests)

# Import click here to avoid circular imports
try:
    import click
except ImportError:
    click = None
    # CLI commands will be disabled if click is not available
    def register_cli_commands(app):
        pass
