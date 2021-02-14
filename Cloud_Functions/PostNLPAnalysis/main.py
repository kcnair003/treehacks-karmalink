from __future__ import print_function
import json
import nltk
from nltk.corpus import stopwords
import pandas as pd
import spacy
import string
from google.cloud import firestore
import datetime
from httplib2 import Http
from email.mime.text import MIMEText
import base64
from google.oauth2 import service_account
import os
from google.cloud import language_v1
from googleapiclient.discovery import build
from googleapiclient import errors
import traceback

import sys
sys.path.append('/user_code/SentimentAnalysis.py')
from SentimentAnalysis import analyze_blob_sentiment, analyze_blob_subjectivity, analyze_vader_sentiment

# Establishes the Firestore client
db = firestore.Client()

def analyze_cloud_sentiment(text_phrase):
    # Defines the client, type of document, and the language used in the sentiment analysis
    client = language_v1.LanguageServiceClient()
    language = "en"
    document = language_v1.Document(content=text_phrase, type_=language_v1.Document.Type.PLAIN_TEXT, language=language)
    response = client.analyze_sentiment(request={'document': document})
    # Uses the analyze_sentiment() method to find the overall polarity and magnitude of the text
    text_polarity = response.document_sentiment.score
    return(text_polarity)

#Combines different sentiment methods into one data dict
def combine_sentiment_methods(message):
    cloud_polarity = analyze_cloud_sentiment(message)
    blob_polarity = analyze_blob_sentiment(message)
    blob_subjectivity = analyze_blob_subjectivity(message)
    vader_polarity = analyze_vader_sentiment(message)
    data = {'Cloud_Polarity': cloud_polarity, 'TextBlob_Polarity': blob_polarity, 'TextBlob_Subjectivity': blob_subjectivity, 'VADER_Polarity': vader_polarity}
    return data


def calculate_post_polarity(event, context):
    """Triggered by a change to a Firestore document.
    Args:
         event (dict): Event payload.
         context (google.cloud.functions.Context): Metadata for the event.
    """
    resource_string = context.resource
    # print out the resource string that triggered the function
    #print(f"Function triggered by change to: {resource_string}.")
    # now print out the entire event object
    #print(str(event))
    # Finds the user ID associated with the journal entry
    resource_string_list = resource_string.split('/')
    post_ID = resource_string_list[6]
    # Finds the name of the user
    post_ref = db.collection(u'posts').document(post_ID)
    # Defines the dictionary associated with the 'value' key
    value_dict = event['value']
    # Defines the dictionary associated the 'fields' key
    fields_dict = value_dict['fields']
    # Defines the dictionaries associated with the keys 'journal_text' and 'timestamp'
    post_text_dict = fields_dict['content']
    #timestamp_dict = fields_dict['timestamp']
    # Defines the journal text (string) and the timestamp (string)
    post_text = post_text_dict['message']
    #timestamp_string = timestamp_dict['timestampValue']
    # Converts the timestamp into a 'datetime' object
    #timestamp_datetime = datetime.strptime(timestamp_string, '%Y-%m-%dT%H:%M:%SZ')
    # Checks for profanity and extracts keywords from the journal
    try:
        data = combine_sentiment_methods(post_text)
        post_ref.update(data)
    except Exception as e:
        print("Sorry, something unexpected occurred. Please contact Hespr Support so that we can investigate the issue for you!")
        traceback.print_exc()
