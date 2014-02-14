#!/usr/bin/env python
# Credentials are read in from a configuration file in the same directory. 
# The file is named config.cfg and takes the following format:
#
# [Credentials]
# customer: [customer]
# username: [username]
# password: [password]
#

import sys, json, httplib2, ConfigParser
from urllib import urlencode

# Create a new instance of the http2lib module
http = httplib2.Http()
# Force errors to be returned as normal responses
http.force_exception_to_status_code = True

# Create a new instance of the ConfigParser module
config = ConfigParser.ConfigParser()
try:
    # Read in the credentials from config.cfg
    config.read('config.cfg')
    apikey = config.get('Credentials', 'apikey', 'none')
except Exception, ex:
    # Exit if config file parsing failed
    print str(ex)
    sys.exit("Error reading config.cfg")

#####POST#####
# Create or modify an account
def createEditAccount():
    # Specify API resource URI and parameters
    uri = 'https://emailapi.dynect.net/rest/json/accounts'
    params = {
        'apikey': apikey,
        'username': 'username',
        'password': 'password',
        'companyname': 'Example, Inc.',
        'phone': '555-555-5555'
    }
    # Set the header for the web request
    header = {'content-type': 'application/x-www-form-urlencoded'}

    # Convert parameters into an HTTP query form, delimeted by &
    # Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example%40example.com
    contents = urlencode(params)

    # Make the web request
    response, content = http.request(uri, 'POST', contents, headers=header)
    result = json.loads(content)

    # Print result on success
    if result["response"]["status"] == 200:
        print "Account created or modified successfully."
        return 1
    # Throw an error message if request is not successful
    else:
        print "API Error:"
        print "Status: " + str(result["response"]["status"])
        print "Message: " + str(result["response"]["message"])
        return 0

#####POST#####
# Add to the list of approved recipients
def addSenders():
    # Specify API resource URI and parameters
    uri = 'http://emailapi.dynect.net/rest/json/senders'
    params = {
        'apikey': apikey,	
        'emailaddress':'example@example.com'
    }
    # Set the header for the web request
    header = {'content-type': 'application/x-www-form-urlencoded'}

    # Convert parameters into an HTTP query form, delimeted by &
    # Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example%40example.com
    contents = urlencode(params)

    # Make the web request
    response, content = http.request(uri, 'POST', contents, headers=header)
    result = json.loads(content)

    # Print result on success
    if result["response"]["status"] == 200:
        print "Sender added successfully."
        return 1
    # Throw an error message if request is not successful
    else:
        print "API Error:"
        print "Status: " + str(result["response"]["status"])
        print "Message: " + str(result["response"]["message"])
        return 0

#####POST#####
# Add to the list of approved recipients
def addRecipients():
    # Specify API resource URI and parameters
    uri = 'http://emailapi.dynect.net/rest/json/recipients/activate'
    params = {
        'apikey': apikey,	
        'emailaddress': 'example@example.com'
    }
    # Set the header for the web request
    header = {'content-type': 'application/x-www-form-urlencoded'}

    # Convert parameters into an HTTP query form, delimeted by &
    # Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example%40example.com
    contents = urlencode(params)

    # Make the web request
    response, content = http.request(uri, 'POST', contents, headers=header)
    result = json.loads(content)

    # Print result on success
    if result["response"]["status"] == 200:
        print "Recipient added successfully."
        return 1
    # Throw an error message if request is not successful
    else:
        print "API Error:"
        print "Status: " + str(result["response"]["status"])
        print "Message: " + str(result["response"]["message"])
        return 0

#####GET#####
# Return number of successfully delivered emails
def reportDelivered():
    # Specify parameters for API request
    params = {
        'apikey': apikey,
        'startdate': '2013-12-01',
        'enddate': '2014-01-31'
    }
    # Set the header for the web request
    header = {'content-type': 'application/x-www-form-urlencoded'}

    # Convert parameters into an HTTP query form, delimeted by &
    # Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example%40example.com
    contents = urlencode(params)

    # Append HTTP query form info to the URI
    uri = 'http://emailapi.dynect.net/rest/json/reports/sent/count?' + contents

    # Convert parameters into an HTTP query form, delimeted by &
    # Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example%40example.com
    contents = urlencode(params)

    # Make the web request
    response, content = http.request(uri, 'GET', contents, headers=header)
    result = json.loads(content)

    # Print result on success
    if result["response"]["status"] == 200:
        print "Messages sent successfully: " + str(result["decode"]["response"]["data"]["count"])
        return 1
    # Throw an error message if request is not successful
    else:
        print "API Error:"
        print "Status: " + str(result["response"]["status"])
        print "Message: " + str(result["response"]["message"])
        return 0

#####GET#####
# Return a report of bounced emails
def reportBounced(startIndex):
    # Specify parameters for API request
    params = {
        'apikey': apikey,
        'startdate': '2013-12-01',
        'enddate': '2014-01-31',
        'startindex': startIndex
    }
    # Set the header for the web request
    header = {'content-type': 'application/x-www-form-urlencoded'}

    # Convert parameters into an HTTP query form, delimeted by &
    # Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example%40example.com
    contents = urlencode(params)

    # Append HTTP query form info to the URI
    uri = 'http://emailapi.dynect.net/rest/json/reports/bounces?' + contents

    # Make the web request
    response, content = http.request(uri, 'POST', contents, headers=header)
    result = json.loads(content)

    count = 0
    # If the API did not respond with an error
    if result["response"]["status"] == 200:
        # Cycle through each bounce record
        for bounce in result["response"]["data"]["bounces"]:
            # Print up to 500 bounce records on success
            if (count < 500):
                print "Bounce type: " + bounce["bouncetype"]
                print "Bounce rule: " + bounce["bouncerule"]
                print "Sender address: " + bounce["emailaddress"]
                print "Bounce time: " + bounce["bouncetime"] + "\n"
            # If 500 records have already been returned
            # Call the function again with a start index incremented by 500
            else:
                reportBounced(startIndex + 500);
                return

    # Throw an error message if API request is not successful
    else:
        print "API Error:"
        print "Status: " + str(result["response"]["status"])
        print "Message: " + str(result["response"]["message"])
        return 0

#####POST#####
# Send email with the Dyn Message Manager API
def sendEmail():
    # Specify API resource URI and parameters
    uri = 'http://emailapi.dynect.net/rest/json/send'
    params = {
        'apikey': apikey,	
        'from': 'example@example.com',
        'to': 'example2@example.com',
        'subject': 'Test',
        'bodytext': 'Test test test',
        'bodyhtml': 'Test test test'
    }
    # Set the header for the web request
    header = {'content-type': 'application/x-www-form-urlencoded'}

    # Convert parameters into an HTTP query form, delimeted by &
    # Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example%40example.com
    contents = urlencode(params)

    # Make the web request
    response, content = http.request(uri, 'POST', contents, headers=header)
    result = json.loads(content)

    # Print result on success
    if result["response"]["status"] == 200:
        print "Message sent successfully."
        return 1
    # Throw an error message if request is not successful
    else:
        print "API Error:"
        print "Status: " + str(result["response"]["status"])
        print "Message: " + str(result["response"]["message"])
        return 0
