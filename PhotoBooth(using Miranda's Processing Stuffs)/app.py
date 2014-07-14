from flask import Flask,session,request,redirect,url_for
from flask import render_template
from datetime import date
from geopy import geocoders
import csv, shelve, time, json
import os,hashlib, os.path


app = Flask(__name__)
app.secret_key="secret key"

@app.route("/")
def index():
    pics = len([name for name in os.listdir('.') if os.path.isfile(name)])
    #temp = ""
    #for x in range(1,pics):
    #    temp = temp + '<li><img src="{{ url_for('+" 'static', filename='img/line-"+str(x)+".jpg') }}"+' " style="height:727.5px; width:970px"></li>'
    return render_template("index.html",pictures=pics)  

if __name__=="__main__":
    app.debug=True
    app.run(host='0.0.0.0',port=8000)
    
