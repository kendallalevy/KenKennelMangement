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

# Load environment variables from a .env file
load_dotenv()

# Create the Flask app instance
app = Flask(__name__)
app.secret_key = 'tigger'


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

@app.route('/', methods=['POST', 'GET'])
def home():
    return render_template('index.html')

@app.route('/edit_dog', methods=['POST', 'GET'])
def edit_dog():
    if request.method == 'POST':
        first_name = request.form.get('first_name')
        last_name = request.form.get('last_name')
        
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM V_Get_Dogs WHERE [First name] = ? AND [Last name] = ?', (first_name, last_name))
        dogs = cursor.fetchall()
        cursor.close()
        conn.close()
        return render_template('edit_dog.html', dogarray=dogs)
    return render_template('edit_dog.html')

@app.route('/add_dog', methods=['POST', 'GET'])
def add_dog():
    # get all possible tags  
    all_tags = []
    all_vax = []
    try:
      conn = get_db_connection()
      cursor = conn.cursor()
      cursor.execute('SELECT TagDescr FROM dbo.TAG')
      all_tags = cursor.fetchall()
      cursor.execute('SELECT VaxName FROM dbo.VACCINATION')
      all_vax = [vax[0] for vax in cursor.fetchall()]
      conn.commit()
      cursor.close()
      conn.close()
    except pyodbc.Error as e:
      flash(str(e), 'error, could not generate values to display')
      
    if request.method == 'POST':
        # Get form data
        breed_name = request.form.get('breed_name') or None
        cust_fname = request.form.get('cust_fname')
        cust_lname = request.form.get('cust_lname')
        sex = request.form.get('sex')
        age = request.form.get('age')
        name = request.form.get('name')
        nickname = request.form.get('nickname') or None
        weight = request.form.get('weight')
        color = request.form.get('color')
        vet = request.form.get('vet') or None
        selected_tags = request.form.getlist('tags') or None
        vaccination_dates = {vax: request.form.get(vax) for vax in all_vax}
        notes = request.form.get('notes') or None
        
        try:
            conn = get_db_connection()
            cursor = conn.cursor()
            
            # execute AddDog to add dog to DB
            cursor.execute('EXEC dbo.AddDog @BreedName=?, @CustFName=?, @CustLName=?, @Sex=?, @Age=?, @Name=?, @Nickname=?, @Weight=?, @Color=?, @Vet=?, @Notes=?',
                           (breed_name, cust_fname, cust_lname, sex, age, name, nickname, weight, color, vet, notes))
 
            # execute AddTag to add tag to dog for every selected in form
            if selected_tags is not None:
                for tag in selected_tags:
                    cursor.execute('EXEC dbo.AddTag @Name=?, @LName=?, @TagDescr=?', (name, cust_lname, tag))
               
            # execute AddVax to add vaccination dates
            for vax, date in vaccination_dates.items():
                cursor.execute('EXEC dbo.AddVax @Name=?, @LName=?, @VaxName=?, @VaxDate=?', (name, cust_lname, vax, date))  
                
            conn.commit()
            cursor.close()
            conn.close()
            flash('Dog added successfully!', 'success')
        except pyodbc.Error as e:
            flash(str(e), 'error')
    
    return render_template('add_dog.html', tags=all_tags, vaccinations=all_vax)

@app.route('/add_cust', methods=['POST', 'GET'])
def add_cust():
    if request.method == 'POST':
        # Get form data
        cust_fname = request.form.get('cust_fname')
        cust_lname = request.form.get('cust_lname')
        email = request.form.get('email') or None
        
        try:
            conn = get_db_connection()
            cursor = conn.cursor()
            cursor.execute("""
                EXEC dbo.AddCust @CustFName=?, @CustLName=?, email=?
            """, (cust_fname, cust_lname, email))
            conn.commit()
            cursor.close()
            conn.close()
            flash('Customer added successfully!', 'success')
        except pyodbc.Error as e:
            flash(str(e), 'error')
    
    return render_template('add_cust.html')

if __name__ == '__main__':
    app.run(debug=True)
