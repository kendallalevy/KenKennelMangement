"""
File: modules.py
Description: Module loader for the Kennel Management System Flask application.
Author: Kendall Levy
Date: 6/7/2024

This file serves as a module loader for the Flask application. It imports and registers all the blueprints (modules)
and other components of the application.

Usage:
    - Import this module into your Flask application to load all modules.
    - Register the modules with the Flask application using the `register_modules` function.

Please refer to the documentation or comments within this file for detailed information about each module.
"""

from flask import Blueprint

def register_modules(app):
    """
    Register all modules with the Flask application.
    """
