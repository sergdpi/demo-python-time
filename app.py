from datetime import datetime
from flask import Flask
import os

app = Flask(__name__)

def getLocalTime():
    date = datetime.now()
    return str(date)

@app.route('/')
def home():
    name = os.environ['MyName']
    ltime = getLocalTime()
    return 'Hello, ' + name  + '\n' + '<br/>' +  'The current time on a server is: ' + str(ltime)

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)