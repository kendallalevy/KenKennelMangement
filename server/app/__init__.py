
"""
File: __init__.py
Description: Initialization script for the Kennel Management System Flask application.
Author: Kendall Levy
Date: 6/7/2024

This script initializes the Flask app instance and configures it for the Kennel Management System application.
"""

from flask import Flask

# Create the Flask app instance
app = Flask(__name__)

# Configuration settings
app.config['SECRET_KEY'] = 'your_secret_key'
# Add any additional configuration settings here

# Import and register blueprints
from .views import main_bp
app.register_blueprint(main_bp)