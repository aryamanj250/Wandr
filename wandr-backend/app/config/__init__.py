"""
Configuration module for Wandr Backend.
Uses environment-based configuration with python-decouple for security.
"""

import os
from decouple import config, Csv
from datetime import timedelta


class Config:
    """Base configuration class with common settings."""
    
    # Flask Core Settings
    SECRET_KEY = config('SECRET_KEY', default='dev-key-change-in-production')
    DEBUG = config('FLASK_DEBUG', default=False, cast=bool)
    TESTING = False
    
    # Server Settings
    HOST = config('FLASK_HOST', default='127.0.0.1')
    PORT = config('FLASK_PORT', default=5000, cast=int)
    
    # CORS Settings - Allow iOS app to communicate
    CORS_ORIGINS = config('CORS_ORIGINS', default='*', cast=Csv())
    CORS_METHODS = ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS']
    CORS_ALLOW_HEADERS = ['Content-Type', 'Authorization', 'X-Requested-With']
    
    # Session Configuration
    PERMANENT_SESSION_LIFETIME = timedelta(hours=24)
    SESSION_COOKIE_SECURE = config('SESSION_COOKIE_SECURE', default=False, cast=bool)
    SESSION_COOKIE_HTTPONLY = True
    SESSION_COOKIE_SAMESITE = 'Lax'
    
    # JSON Settings
    JSON_SORT_KEYS = False
    JSONIFY_PRETTYPRINT_REGULAR = True
    
    # Future API Keys (will be uncommented as needed)
    # GEMINI_API_KEY = config('GEMINI_API_KEY', default=None)
    # TWILIO_ACCOUNT_SID = config('TWILIO_ACCOUNT_SID', default=None)
    # TWILIO_AUTH_TOKEN = config('TWILIO_AUTH_TOKEN', default=None)
    # RAZORPAY_KEY_ID = config('RAZORPAY_KEY_ID', default=None)
    # RAZORPAY_KEY_SECRET = config('RAZORPAY_KEY_SECRET', default=None)
    # GOOGLE_PLACES_API_KEY = config('GOOGLE_PLACES_API_KEY', default=None)
    
    # Database Configuration (for future use)
    # DATABASE_URL = config('DATABASE_URL', default='sqlite:///wandr.db')
    # REDIS_URL = config('REDIS_URL', default='redis://localhost:6379/0')
    
    @classmethod
    def init_app(cls, app):
        """Initialize application with this configuration."""
        pass


class DevelopmentConfig(Config):
    """Development configuration."""
    DEBUG = True
    CORS_ORIGINS = config('CORS_ORIGINS', default='http://localhost:3000,http://127.0.0.1:3000', cast=Csv())


class ProductionConfig(Config):
    """Production configuration."""
    DEBUG = False
    SESSION_COOKIE_SECURE = True
    CORS_ORIGINS = config('CORS_ORIGINS', cast=Csv())  # Must be explicitly set in production
    
    @classmethod
    def init_app(cls, app):
        """Production-specific initialization."""
        Config.init_app(app)
        
        # Log to stderr in production
        import logging
        from logging import StreamHandler
        file_handler = StreamHandler()
        file_handler.setLevel(logging.WARNING)
        app.logger.addHandler(file_handler)


class TestingConfig(Config):
    """Testing configuration."""
    TESTING = True
    DEBUG = True
    CORS_ORIGINS = ['http://localhost:3000']


# Configuration mapping
config_map = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'testing': TestingConfig,
    'default': DevelopmentConfig
}


def get_config(config_name=None):
    """Get configuration class based on environment."""
    if config_name is None:
        config_name = config('FLASK_ENV', default='development')
    
    return config_map.get(config_name, config_map['default'])
