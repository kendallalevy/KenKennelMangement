"""
File: __init__.py
Description: Initialization script for the Kennel Management System Flask application.
Author: Kendall Levy
Date: 6/7/2024

This script initializes the Flask app instance and configures it for the Kennel Management System application.
"""
import os
from re import M
from flask import Flask, render_template, session, request, flash
import pyodbc
from dotenv import load_dotenv
import random
import copy

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
  all_cust = []
  all_tags = []
  all_breeds = []
  all_sexes = []
  all_vax = []
  all_meds = []
  try:
    # get data to display in form
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT FName, LName FROM dbo.V_Get_Cust_Name')
    all_cust = cursor.fetchall()
    cursor.execute('SELECT TagDescr FROM dbo.TAG')
    all_tags = cursor.fetchall()
    cursor.execute('SELECT BreedName FROM dbo.BREED')
    all_breeds = [breed[0] for breed in cursor.fetchall()]
    cursor.execute('SELECT SexName FROM dbo.SEX')
    all_sexes = [sex[0] for sex in cursor.fetchall()]
    cursor.execute('SELECT VaxName FROM dbo.VACCINATION')
    all_vax = [vax[0] for vax in cursor.fetchall()]
    cursor.execute('SELECT MedName FROM dbo.MEDICATION')
    all_meds = [med[0] for med in cursor.fetchall()]
    conn.commit()
    cursor.close()
    conn.close()
  except pyodbc.Error as e:
    flash(str(e), 'error, could not generate values to display')
      
  if request.method == 'POST':
    # Get form data
    cust_name = request.form.get('cust_name')
    cust_fname, cust_lname = cust_name.rsplit(" ")
    breed_name = request.form.get('breed') or None
    sex = request.form.get('sex')
    age = request.form.get('age')
    name = request.form.get('name')
    nickname = request.form.get('nickname') or None
    weight = request.form.get('weight')
    color = request.form.get('color')
    vet = request.form.get('vet') or None
    notes = request.form.get('notes') or None
    selected_tags = request.form.getlist('tags') or None
    vaccination_dates = {vax: request.form.get(vax) for vax in all_vax}
    selected_meds = request.form.getlist('meds') or None
        
    try:
      conn = get_db_connection()
      cursor = conn.cursor()

      # execute AddDog to add dog to DB
      cursor.execute('EXEC dbo.AddDog @Name=?, @CustFName=?, @CustLName=?, @BreedName=?, @Sex=?, @Age=?, @Nickname=?, @Weight=?, @Color=?, @Vet=?, @Notes=?',
                      (name, cust_fname, cust_lname, breed_name, sex, age, nickname, weight, color, vet, notes))

 
      # execute AddTag to add tag to dog for every selected in form
      if selected_tags is not None:
        for tag in selected_tags:
          cursor.execute('EXEC dbo.AddTag @FName=?, @LName=?, @Name=?, @TagDescr=?', (cust_fname, cust_lname, name, tag))

               
      # execute AddVax to add vaccination dates
      for vax, date in vaccination_dates.items():
        cursor.execute('EXEC dbo.AddVax @FName=?, @LName=?, @Name=?, @VaxName=?, @VaxDate=?', (cust_fname, cust_lname, name, vax, date))      

      # execute AddMed to add medications if any were input
      if selected_meds is not None:
        for index in range(len(selected_meds)):
          med_name = request.form.get(f'medications[{index}][name]')
          med_dose = request.form.get(f'medications[{index}][dose]')
          med_notes = request.form.get(f'medications[{index}][notes]')
          cursor.execute('EXEC dbo.AddMed @FName=?, @LName=?, @Name=?, @MedName=?, @Dose=?, @Notes=?', (cust_fname, cust_lname, name, med_name, med_dose, med_notes))

      conn.commit()
      cursor.close()
      conn.close()
      flash('Dog added successfully!', 'success')
    except pyodbc.Error as e:
      flash(str(e), 'error')
    
  return render_template('add_dog.html', names=all_cust, breeds=all_breeds, sexes=all_sexes, tags=all_tags, vaccinations=all_vax, meds=all_meds)


@app.route('/add_cust', methods=['POST', 'GET'])
def add_cust():
  all_states = []
  
  try:
    # get data to display in form
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT StateAbrv FROM dbo.STATE')
    all_states = cursor.fetchall()
    conn.commit()
    cursor.close()
    conn.close()
  except pyodbc.Error as e:
    flash(str(e), 'error, could not generate values to display')

  if request.method == 'POST':
    # Get form data
    cust_fname = request.form.get('cust_fname')
    cust_lname = request.form.get('cust_lname')
    email = request.form.get('email') or None
    phone = request.form.get('phone')
    addr1 = request.form.get('addr1')
    addr2 = request.form.get('addr2') or None
    city = request.form.get('city')
    state = request.form.get('state')
    zipCode = request.form.get('zipCode')
        
    try:
      conn = get_db_connection()
      cursor = conn.cursor()
      # execute stored proc to add customer to db
      cursor.execute('EXEC dbo.AddCust @CustFName=?, @CustLName=?, @Email=?, @Phone=?, @AddrLine1=?, @AddrLine2=?, @City=?, @State=?, @Zip=?',
                      (cust_fname, cust_lname, email, phone, addr1, addr2, city, state, zipCode))
      conn.commit()
      cursor.close()
      conn.close()
      flash('Customer added successfully!', 'success')
    except pyodbc.Error as e:
      flash(str(e), 'error')
    
  return render_template('add_cust.html', states=all_states)

@app.route('/add_visit', methods=['POST', 'GET'])
def add_visit():
  all_cust = []
  all_statuses = []
  try:
    # get data to display in form
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT FName, LName FROM dbo.V_Get_Cust_Name')
    all_cust = cursor.fetchall()
    cursor.execute('SELECT VisitStatus FROM VISIT_STATUS')
    all_statuses = [status[0] for status in cursor.fetchall()]
    cursor.execute('SELECT BelongingTypeName FROM dbo.BELONGING_TYPE')
    all_bel_types = [belType[0] for belType in cursor.fetchall()]
    cursor.execute('SELECT ActivityTypeName FROM ACTIVITY_TYPE')
    all_act_types = [actType[0] for actType in cursor.fetchall()]
    conn.commit()
    cursor.close()
    conn.close()
  except pyodbc.Error as e:
    flash(str(e), 'error, could not generate values to display')
      
  if request.method == 'POST':
    # Get form data
    cust_name = request.form.get('cust_name')
    cust_fname, cust_lname = cust_name.rsplit(" ")
    dog_name = request.form.get('dog_name')
    status = request.form.get('status')
    arrvDate = request.form.get('arrvDate')
    dprtDate = request.form.get('dprtDate')
    grmDate = request.form.get('grmDate')
    selected_belongings = request.form.getlist('belongings') or None
    selected_activities = request.form.getlist('activities') or None
      


    if selected_belongings is not None:
      for index in range(len(selected_belongings)):
        bel_descr = request.form.get(f'belongings[{index}][descr]')
        bel_type = request.form.get(f'belongings[{index}][type]')
            
    if selected_activities is not None:
      for index in range(len(selected_activities)):
        act_type = request.form.get(f'activities[{index}][type]')
      

    try:
      # open connection to db  
      conn = get_db_connection()
      cursor = conn.cursor()
      # get avaialable runs from db
      cursor.execute('SELECT RunNumber, RunTypeAbrv FROM dbo.F_Get_Available_Runs (?, ?)',
                      (arrvDate, dprtDate))
      available_runs = cursor.fetchall()
      runs = {}
      # make dict with key = run name and value = run type
      for run in available_runs:
        runs[run[0]] = run[1]
      cursor.execute('SELECT dbo.F_Get_DogID(?, ?, ?)', (cust_fname, cust_lname, dog_name))
      dogID = cursor.fetchone()[0]
      # call fuction to assign run to dog
      runID = get_run(cursor, runs, dogID)
      if runID == -1:
        flash('No Run Available', 'error')
      else:
        # execute stored proc to add customer to db
        cursor.execute('EXEC dbo.AddVisit @DogID=?, @Status=?, @Arrive=?, @Depart=?, @Groom=?, @RunID=?',
                        (dogID, status, arrvDate, dprtDate, grmDate, runID))
        cursor.execute('SELECT RunNumber FROM RUN WHERE RunID = ?', (runID))
        runName = cursor.fetchone()[0]
        flash(f'Visit added successfully! Assigned to run: {runName}', 'success')
      conn.commit()
      cursor.close()
      conn.close()
    except pyodbc.Error as e:
      flash(str(e), 'error')

  return render_template('add_visit.html', names=all_cust, statuses=all_statuses, belongings=all_bel_types, activities=all_act_types)

"""
function to assign a dog to a run.
Takes pyodbc cursor and dictionary of runs as parameters
"""
def get_run(cursor, available_runs, dogID):
  cursor.execute('SELECT T.TagDescr FROM TAG T JOIN DOG_TAG DT ON T.TagID = DT.TagID JOIN DOG D ON D.DogID = DT.DogID WHERE D.DogID = ?', (dogID))
  tags = [tag[0] for tag in cursor.fetchall()]
  cursor.execute('SELECT Weight FROM DOG WHERE DogID = ?', (dogID))
  weight = cursor.fetchone()[0]
  runs = copy.deepcopy(available_runs)
  # check if there are any available runs
  if not runs:
    return -1

  
  for key in available_runs:
    # if dog is do not enter, only allow runs in 'A' building
    if 'Do not enter' in tags:
      if key[0] != 'A':
        del runs[key]
        continue
   
    # if dog is larger than 100 lbs, don't allow in E building
    if weight > 100.0:
      if key[0] == 'E':
        del runs[key]
        continue
    
    if 'A/B Kennel Request' in tags or 'A/B Suite Request' in tags:
      # if run is not in 'A' or 'B' building, remove option
      if key[0] != 'A' or key[0] != 'B':
        del runs[key]
        continue
      if 'A/B Suite Request' in tags:
        # if run is not a suite, remove run option
        if available_runs[key] != 'S':
          del runs[key]
          continue
        
    if 'D Kennel Request' in tags or 'D Suite Request' in tags:
      # allow only building 'D' if requested
      if key[0] != 'D':
        del runs[key]
        continue
      if 'D Suite Request' in tags:
        # allow only type Suite if requested
        if available_runs[key] != 'S':
          del runs[key]
          continue
    
    # only allow covered runs if necessary
    if 'Covered Run' in tags or 'Fence Climber' in tags:
      if available_runs[key] != 'C' or (available_runs[key] != 'S' and key[0] != 'D'):
        del runs[key]
        continue
    
    # remove uppers from option if necessary
    if 'No Uppers' in tags:
      if available_runs[key] == 'U':
        del runs[key]
        continue
      
    # only allow E kennels
    if 'E Kennel Request' in tags:
      if key[0] != 'E':
        del runs[key]
        continue
      
    # if dog is tall only allow type Tall or D Suites
    if 'Tall' in tags or weight > 130:
      if available_runs[key] != 'T' or (available_runs[key] != 'S' and key[0] != 'D'):
        del runs[key]
        continue
     
    # if dog weighs more than 15 pounds dont allow 4x4 kennels
    if weight > 15.0:
      if available_runs[key] == 'U' or available_runs[key] == 'L':
        del runs[key]
        continue

  # if no available runs
  if not runs:
    return -1
  
  key, val = random.choice(list(runs.items()))
  cursor.execute('SELECT RunID FROM RUN WHERE RunNumber = ?', (key))
  runID = cursor.fetchone()[0]
  return runID
  
     

@app.route('/get_dogs')
def get_dogs():
  customer_name = request.args.get('customer')
  cust_fname, cust_lname = customer_name.split()
  dogs = []

  try:
    conn = get_db_connection()
    cursor = conn.cursor()
    # Get dog names of customer based on args
    cursor.execute('SELECT D.[Name] FROM DOG D JOIN CUSTOMER C ON C.CustID = D.CustID WHERE C.FName = ? AND C.LName = ?', (cust_fname, cust_lname))
    dogs = [row[0] for row in cursor.fetchall()]
    cursor.close()
    conn.close()
  except pyodbc.Error as e:
    print(f"Database error: {e}")

  return {'dogs': dogs}

if __name__ == '__main__':
  app.run(debug=True)
