
"""
File: __init__.py
Description: Initialization script for the Kennel Management System Flask application.
Author: Kendall Levy
Date: 6/7/2024

This script initializes the Flask app instance and configures it for the Kennel Management System application.
"""
import os
from flask import Flask, render_template, session, request, flash
import pyodbc
from dotenv import load_dotenv

# Create the Flask app instance
app = Flask(__name__)
app.secret_key = "tigger"


def get_db_connection():
    connection_string = (
        f"DRIVER={os.getenv('DB_DRIVER')};"
        f"SERVER={os.getenv('DB_SERVER')};"
        f"DATABASE={os.getenv('DB_DATABASE')};"
        f"UID={os.getenv('DB_USERNAME')};"
        f"PWD={os.getenv('DB_PASSWORD')}"
    )
    # Connect to the database
    connection = pyodbc.connect(connection_string)
    return connection

@app.route('/', methods=["POST", "GET"])
def home():
    return render_template("index.html")

@app.route('/getdog', methods=['GET'])
def get_dogs():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM DOG")
    dogs = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template("getdog.html", dogarray=dogs)
    


if __name__ == '__main__':
    app.run(debug=True)
