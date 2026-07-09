from flask import Flask, request, render_template, redirect
import psycopg2
import os

app = Flask(__name__)

conn = psycopg2.connect(
     host=os.getenv("DB_HOST"),
     database=os.getenv("DB_NAME"),
     user=os.getenv("DB_USER"),
     password=os.getenv("DB_PASSWORD")
)

cur = conn.cursor()

cur.execute("""
CREATE TABLE IF NOT EXISTS employees(
id SERIAL PRIMARY KEY,
name TEXT,
department TEXT
)
""")

conn.commit()


@app.route("/")
def index():
    cur.execute("SELECT * FROM employees")
    employees = cur.fetchall()
    return render_template("index.html", employees=employees)


@app.route("/add", methods=["POST"])
def add():
    name = request.form["name"]
    department = request.form["department"]

    cur.execute(
       "INSERT INTO employees(name,department) VALUES(%s,%s)",
        (name, department)
    )
    conn.commit()
 
    return redirect("/")

app.run(host="0.0.0.0", port=5000)

