"""
File: run.py
Description: Entry point for starting the development server for the Kennel Management System Flask application.
Author: Kendall Levy
Date: 6/7/2024

This script serves as the entry point for starting the development server for the Kennel Management System Flask application.
It imports the Flask app instance from the app package and starts the development server using the run() method.

Usage:
    - Run this script to start the development server for the Flask application.
    - Access the application by navigating to http://127.0.0.1:5000/ in your web browser.

Please ensure that all required dependencies are installed and the Flask app instance is properly configured in the app package.
"""

from app import app

if __name__ == '__main__':
    app.run(debug=False)
