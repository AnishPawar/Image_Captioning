from flask import Flask,render_template
import os
app = Flask(__name__)

def factors(num):
  return [x for x in range (1, num+1) if num%x==0]
  
@app.route('/')
def home():
    return render_template('StartPage.html')
if __name__ == '__main__':
  app.run(debug=True)

