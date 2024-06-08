"""
File: routes.py
Description: Defines the routes for the Kennel Management System Flask application.
Author: Kendall Levy
Date: 6/7/2024

This file defines the routes (URL endpoints) for the Flask application. It contains handlers for processing
incoming requests and returning appropriate responses.

Usage:
    - Import this module into your Flask application to register the routes.
    - Add new route handlers as needed for different functionalities of the application.

Please refer to the documentation or comments within this file for detailed information about each route.
"""

from flask import Blueprint

# Define a blueprint for routes
main_bp = Blueprint('main', __name__)

@main_bp.route('/')
def index():
    """
    Route handler for the home page.
    """
    return 'Welcome to the Kennel Management System!'
