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
from SentimentAnalysis import analyzeBlobSentiment, analyzeBlobSubjectivity, analyzeVADERSentiment

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
    cloud_polarity = analyze_sentiment(message)
    blob_polarity = analyze_blob_sentiment(message)
    blob_subjectivity = analyze_blob_subjectivity(message)
    vader_polarity = analyze_VADER_sentiment(message)
    data = { u'polarity_generated_timestamp': datetime.datetime.now(), 'Cloud_Polarity': cloud_polarity, 'TextBlob_Polarity': blob_polarity, 'TextBlob_Subjectivity': blob_subjectivity, 'VADER_Polarity': vader_polarity}
    return data


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
    if request.args and 'message' in request.args:
        message = request.args.get('message')
        data = combine_sentiment_methods(message)
        return data
    elif request_json and 'message' in request_json:
        message = request_json['message']
        data = combine_sentiment_methods(message)
        return data
    else:
        return f'The proper input was not given'
