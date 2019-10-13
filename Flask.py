
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np
import firebase_admin
from firebase_admin import credentials
from firebase_admin import auth
from multiprocessing import Pool, TimeoutError
#root = db.reference()

cred = credentials.Certificate('mhacks12-2bfee-firebase-adminsdk-hz4yi-d6b7a1c521.json')
firebase_admin.initialize_app(cred, {
    'databaseURL' : 'https://mhacks12-2bfee.firebaseio.com/'
})


# In[32]:

from firebase_admin import db
from flask import Flask, jsonify, request
root = db.reference()

def insertNewUserTree(UID, person, lang, project, category):
    #Creates new user tree under the userbase
        
    new_group = root.child('UserBase/'+ UID + "/Actions/").set({
        'Current Group':0,
        'Current Queue':0,
        'Swipes':0,
        'Swiped By':0,
        'Matches':0
    })
    
    new_group = root.child('UserBase/'+ UID + "/Data/").set({
        'Personality': person,
        'Languages': lang,
        'Project Interests': project,
        "Category": category
    })


# In[2]:


def createUser(email, phone, passw, disp_name):
    user = auth.create_user(
        email=email,
        email_verified=False,
        phone_number=phone, #+1, 10 digit (str len = 12)
        password= passw,
        display_name=disp_name,
        disabled=False)
    return user.uid


# In[15]:


def userSwipeNo(uid):
    ref = db.reference("UserBase/" + uid +"/Actions/Current Queue")
    currentQueue = ref.get()
    newQueue = currentQueue[1:]
    new_update = root.child("UserBase/" +uid + "/Actions")
    new_update.update({
        'Current Queue': newQueue
    })
    
def userSwipeYes(swiperID, swipedID):
    
    ref = db.reference("UserBase/" + swiperID +"/Actions/Current Queue")
    currentQueue = ref.get()
    newQueue = currentQueue[1:]
    new_update = root.child("UserBase/" + swiperID + "/Actions")
    new_update.update({
        'Current Queue': newQueue
    })
    
    ref = db.reference("UserBase/" + swiperID +"/Actions/Swipes")
    SwipercurrentList = []
    SwipedcurrentList = []
    
    if(ref.get() != 0):
        SwipercurrentList = ref.get()
    if(swipedID in SwipercurrentList):
        print("Already in the list")
    else:
        SwipercurrentList.append(swipedID)
        new_update = root.child('UserBase/' + swiperID + '/Actions/')
        new_update.update({
            'Swipes': SwipercurrentList
        })

    
    ref = db.reference("UserBase/" + swipedID +"/Actions/Swiped By")
    if(ref.get() != 0):
        SwipedcurrentList = ref.get()
    if(swiperID in SwipedcurrentList):
        print("Already in your list")
    else:
        SwipedcurrentList.append(swiperID)
        new_update = root.child('UserBase/' + swipedID + '/Actions/')
        new_update.update({
            'Swiped By': SwipedcurrentList
        })
        
    if(possibleMatch(swiperID, swipedID) == True):
        matchUsers(swiperID, swipedID)
    else:
        insertInQueue(swiperID, swipedID)


# In[27]:


def generateQueue(userID):
    ref = db.reference("UserBase/" + userID + "/Actions/Current Queue")
    currentQ = ref.get()
    if(currentQ == 0 or len(currentQ) < 2):
        userRef = db.reference("UserBase/" + userID + "/Data")
        userInfo = userRef.get()
        print(userInfo)
        
        UIDList = userMatch(userInfo['Languages'], userInfo['Project Interests'], userInfo['Personality'])
        
        new_update = root.child('UserBase/' + userID + '/Actions/')
        new_update.update({
            'Current Queue': UIDList
        }) 
    else:
        print("Queue large enough")


# In[7]:


def getUserData(UID):
# Get a database reference to our posts
    ref = db.reference('UserBase/' + UID)
    return ref.get()


# In[8]:


def possibleMatch(userOne, userTwo):
    OneSwipes = db.reference("UserBase/" + userOne +"/Actions/Swipes")
    OneSwipesResult = OneSwipes.get()
    TwoSwipes = db.reference("UserBase/" + userTwo +"/Actions/Swipes")
    TwoSwipesResult = TwoSwipes.get()
    if(OneSwipesResult != 0 and TwoSwipesResult != 0):
        if(userOne in TwoSwipesResult and userTwo in OneSwipesResult):
            return True
        else:
            return False
    else:
        return False

newQueue = []

def insertInQueue(userOne, userTwo):
    #put user one into user two's queue
    ref = db.reference("UserBase/" +userTwo + "/Actions/Current Queue")
    newQueue = ref.get()
    if(newQueue == 0):
        new_update = root.child("UserBase/" +userTwo + "/Actions")
        new_update.update({
            'Current Queue': [userOne]
        })
    else:
        newQueue.append(userOne)
        new_update = root.child("UserBase/" +userTwo + "/Actions")
        new_update.update({
            'Current Queue': newQueue
        })
        

def matchUsers(userOne, userTwo):
    print("Match users function...")
    ref = db.reference("UserBase/" + userOne + "/Actions/Matches")
    MatchesList = ref.get()
    
    #adds the second user into the first user match list   
    if(MatchesList == 0):
        new_update = root.child("UserBase/" +userOne + "/Actions/")
        new_update.update({
            "Matches": [userTwo]
        })
    else:
        MatchesList.append(userTwo)
        new_update = root.child("UserBase/" +userOne + "/Actions/")
        new_update.update({
            "Matches": MatchesList
        })
    
    #adds the first user into the usertwo match list
    ref = db.reference("UserBase/" + userTwo + "/Actions/Matches")
    MatchesList = ref.get()
    
    if(MatchesList == 0):
        new_update = root.child("UserBase/" +userTwo + "/Actions/")
        new_update.update({
            "Matches": [userOne]
        })
    else:
        MatchesList.append(userOne)
        new_update = root.child("UserBase/" +userTwo + "/Actions/")
        new_update.update({
            "Matches": MatchesList
        })
        


# In[9]:



def CalculateDistance(x1, y1, x2, y2):
    return round(pow(((x1 - x2) * (x1 - x2) + (y1-y2) * (y1-y2)), 0.5),2)

#Used KMeans Clustering to determine the ideal centroid points to group the users into 5 main categories
#Function takes the 5 answers from the survey questions and returns the group that the user most aligns with
def matchingInfo(newUserResponses):
    xCoord = newUserResponses[0] + newUserResponses[2] + newUserResponses[4]
    yCoord = newUserResponses[1] + newUserResponses[3]
    distanceArray = []
    BasePoints = [[6,8], [5.5, 4.5], [9,3], [9,6], [12.5, 5]]
    for x in range(5):
        distanceArray.append(CalculateDistance(xCoord, yCoord, BasePoints[x][0], BasePoints[x][1]))
    return distanceArray.index(min(distanceArray)) + 1
"""
def compute(x):
    # AllLang1, AllLang2, AllLang3, AllInterest1, AllInterest2, AllInterest3,
    matchPoints = 0
    if([AllLang1[x], AllLang2[x], AllLang3[x]] in NewUserLang) {
        matchPoints += 1
    }
    if([AllInterest1[x], AllInterest2[x], AllInterest3[x]] in newUserProj) {
        matchPoints += 2
    }
    return matchPoints

"""
#Function takes 3 arrays - userlang preferences[3], user proj preferences[3], personality questions responses[5]
def userMatch(NewUserLang, newUserProj, newUserQuestions):
    category = matchingInfo(newUserQuestions)
    print(category)
    category_df = current_data[current_data['Category'] == category]
    
    new_size = int(0.4 * len(category_df))
    category_df = category_df[0:new_size]
    
    category_df['Match'] = 0
    AllLang1 = category_df['Lang1'].values
    AllLang2 = category_df['Lang2'].values
    AllLang3 = category_df['Lang3'].values
    
    AllInterest1 = category_df['Interest1'].values
    AllInterest2 = category_df['Interest2'].values
    AllInterest3 = category_df['Interest3'].values
    print(len(category_df))
    
   # pool = multiprocessing.Pool(processes=4)
    
   # pool.map(compute, list(range(0,10)))
    
    
    for z in range(len(category_df)):
        MatchPoints = 0
        currentLang = [AllLang1[z], AllLang2[z], AllLang3[z]]
        currentProj = [AllInterest1[z],AllInterest2[z], AllInterest3[z]]
        for x in range(3):
            if(currentLang[x] in NewUserLang):
                MatchPoints += 1
            if(currentProj[x] in newUserProj):
                MatchPoints += 2
        category_df['Match'].iloc[z] = MatchPoints
    return_df = category_df.sort_values(by='Match', ascending=False).head(5)
    return_df = return_df['Name']
    UIDList = []
    
    nameList = return_df.values
    
    for x in range(len(return_df)):
        ref = db.reference("NameToUID/" + nameList[x])
        UIDList.append(ref.get())
    return UIDList



app = Flask(__name__)
current_data = pd.read_csv("NEWDataCSV.csv")

#Works
@app.route('/create_user', methods=['POST'])
def index():
    some_json = request.get_json()
    print(some_json)
    userUID = createUser(some_json['email'], some_json['phone'], some_json['passw'], some_json['disp_name'])
    print(userUID)
    return jsonify(userUID)

#Works
@app.route('/generate_user_tree', methods=['POST'])
def gen_user_tree():
    new_data = request.get_json()
    insertNewUserTree(new_data['UID'], new_data['person'], new_data['lang'], new_data['project'], new_data['category'])
    return jsonify({"Status":"True"})

#Works
@app.route('/swipe_no', methods=['POST'])
def SwipeNo():
    new_data = request.get_json()
    userSwipeNo(new_data['UID'])
    return jsonify({"Status":"True"})

#Works
@app.route('/swipe_yes', methods=['POST'])
def SwipeYes():
    new_data = request.get_json()
    userSwipeYes(new_data['Swiper'], new_data['Swiped'])
    return jsonify({"Status":"True"})

#Works
@app.route('/generate_queue', methods=['POST'])
def GenQ():
    new_data = request.get_json()
    generateQueue(new_data['UID'])
    return jsonify({"Status":"True"})

#Works
@app.route('/get_profile', methods=['POST'])
def getProfile():
    new_data = request.get_json()
    result = getUserData(new_data['UID'])
    return jsonify(result)

#Works
@app.route('/user_match', methods=['POST'])
def getMatches():
    new_data = request.get_json()
    result = userMatch(new_data['NewUserLang'], new_data['newUserProj'], new_data['newUserQuestions'])
    return jsonify(result)
    
if __name__ == '__main__':
    app.run(host="0.0.0.0",port="80")


# In[31]:

