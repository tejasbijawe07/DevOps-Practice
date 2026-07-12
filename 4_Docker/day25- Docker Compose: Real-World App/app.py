from flask import Flask
import os

app = Flask(__name__)


@app.route("/")
def home():
      return f"""
      <h2>Docker Compose Demo</h2>

      Database Host : {os.getenv('DB_HOST')}

      Redis Host : {os.getenv('REDIS_HOST')}
      """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)


