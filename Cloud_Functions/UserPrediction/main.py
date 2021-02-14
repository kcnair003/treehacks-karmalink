from __future__ import print_function
import json
import pandas as pd
import string
from google.cloud import firestore
import datetime
from httplib2 import Http
from email.mime.text import MIMEText
import base64
from google.oauth2 import service_account
import os
from google.cloud import language_v1
import googleapiclient.discovery
from googleapiclient.discovery import build
from googleapiclient import errors
import traceback

# Establishes the Firestore client
db = firestore.Client()

PROJECT_ID = "treehacks-karmalink"
VERSION_NAME = "Version_2"
MODEL_NAME = "Sentiment_KNN"

def test_prediction_model(test_array, test_labels):

    service = googleapiclient.discovery.build('ml', 'v1')
    name = 'projects/{}/models/{}'.format(PROJECT_ID, MODEL_NAME)
    name += '/versions/{}'.format(VERSION_NAME)

    X_test = test_array
    y_test = test_labels

    # Due to the size of the data, it needs to be split in 2
    first_half = X_test[:int(len(X_test)/2)]
    second_half = X_test[int(len(X_test)/2):]

    complete_results = []
    for data in [first_half, second_half]:
        responses = service.projects().predict(
            name=name,
            body={'instances': data}
        ).execute()

        if 'error' in responses:
            print(response['error'])
        else:
            complete_results.extend(responses['predictions'])

    # Print the first 10 responses
    datadict=[]
    for i, response in enumerate(complete_results[:10]):
        datadict.append('Prediction: {}\tLabel: {}'.format(response, y_test[i]))
    return datadict

def calculate_polarity(request):
    """Responds to any HTTP request.
    Args:
        request (flask.Request): HTTP request object.
    Returns:
        The response text or any set of values that can be turned into a
        Response object using
        `make_response <http://flask.pocoo.org/docs/1.0/api/#flask.Flask.make_response>`.
    """
    request_json = request.get_json()
    if request.args and 'X_test' in request.args and 'y_test' in request.args:
        scores = request.args.get('X_test')
        labels = request.args.get('y_test')
        df = pd.json_normalize(scores)
        df2 = pd.json_normalize(labels)
        data = test_prediction_model(df, df2)
        return data
    elif request_json and 'X_test' in request_json and 'y_test' in request_json:
        scores = request_json['X_test']
        labels = request_json['y_test']
        df = pd.json_normalize(scores)
        df2 = pd.json_normalize(labels)
        data = test_prediction_model(df, df2)
        return data
    else:
        return f'The proper input was not given'
