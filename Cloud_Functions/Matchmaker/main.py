from flask import send_file
from google.cloud import firestore
import os
import json
import traceback
import datetime
import pandas as pd
import numpy as np
import sys
sys.path.append('/user_code/PathCrawler.py')
from PathCrawler import PathList, data_retrieval, dict_convert_formatted, send_download_alert, send_download_request_info
from flask import escape

# Establishes the Cloud Firestore client
db = firestore.Client()

def find_users():
    # Finds users associated with the user in the "posts" collection, as well as any comments associated with that post
    user_ref_docs = db.collection(u'users').stream()
    tupled_user_list = {}
    for user in user_ref_docs:
        tupled_user_list[user.id] = (user, 0)
    return tupled_user_list
 
def find_posts(tupled_user_list):
    # Deletes any posts associated with the user in the "posts" collection, as well as any comments associated with that post
    posts_ref_docs = db.collection(u'posts').stream()
    for doc in posts_ref_docs:
        doc_dict = doc.to_dict()
        doc_score = (doc_dict['Cloud_Polarity']+doc_dict['VADER_Polarity']+doc_dict['TextBlob_Polarity']/3)*doc_dict['TextBlob_Subjectivity']
        tupled_user_list[doc_dict['user_id']][1] += doc_score
    
    return tupled_user_list

def delete_groups():
    # Deletes any posts associated with the user in the "posts" collection, as well as any comments associated with that post
    groups_ref_docs = db.collection(u'groups').stream()
    for doc in groups_ref_docs:
        doc_id = doc.id
        doc.reference.delete()
        messages_ref_docs = db.collection(u'groups').document(doc_id).collection(u'messages').stream()
        for doc in messages_ref_docs:
            doc.reference.delete()

def create_groups(tupled_user_list):
    list_of_keys = []
    list_of_values = []
    for index, (key, value) in enumerate(tupled_user_list.items()):
        list_of_keys[index] = key
        list_of_values[index] = value
    weights_norm = np.linalg.norm(np.array(list_of_values))
    weights_normed = np.array([abs(weight/weights_norm) for weight in list_of_values])
    weights_array = weights_normed / weights_normed.sum()
    weights_scaled = weights_array.tolist()
    counter_list = np.random.choice(list_of_keys, len(list_of_keys), replace=False, p=weights_scaled)
    group_data = (tupled_user_list, counter_list)
    return group_data

def create_random_groups(tupled_user_list):
    list_of_keys = []
    for index, key in enumerate(tupled_user_list):
        list_of_keys[index] = key
    counter_list = np.random.choice(list_of_keys, len(list_of_keys), replace=False)
    group_data = (tupled_user_list, counter_list)
    return group_data

def make_conversations(group_data):
    users = group_data[0]
    counter_list = group_data[1]
    for i in range(0, len(counter_list), 2):
        first_member = counter_list[i]
        second_member = counter_list[i+1]
        members_array = [users[first_member][0].todict()['uid'], users[second_member][0].todict()['uid']]
        group_json = {'last_updated': datetime.datetime.now(), "members": members_array}
        db.collection('groups').add(group_json)

def matchmaker(event, context):
    """Triggered by a change to a Firestore document.
    Args:
         event (dict): Event payload.
         context (google.cloud.functions.Context): Metadata for the event.
    """
    resource_string = context.resource
    # print out the resource string that triggered the function
    print(f"Function triggered by change to: {resource_string}.")
    # now print out the entire event object
    print(str(event))
    # Defines the ID of the user
    resource_string_list = resource_string.split('/')
    user_id = resource_string_list[6]
    # Defines the nickname of the user
    user_ref = db.collection(u'users').document(user_id)
    user_dict = user_ref.get().to_dict()
    requested_learning_boolean = user_dict['like-minded']
    try:
        if requested_learning_boolean == True:
            try:
                data = create_groups(find_posts(find_users))
                delete_groups()
                make_conversations(data)
            except Exception:
                traceback.print_exc()
            return
        else:
            try:
                data = create_random_groups(find_posts(find_users))
                delete_groups()
                make_conversations(data)
            except Exception:
                traceback.print_exc()
            return
    except Exception:
         print('An error occurred with sending the download')
         traceback.print_exc()