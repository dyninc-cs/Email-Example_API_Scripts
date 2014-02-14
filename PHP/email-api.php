#!/usr/bin/php
<?php
# Credentials are read in from an INI file in the same directory. 
# The file is named config.ini and takes the following format:
#
# customer=[customer]
# username=[username]
# password=[password]
#

# Parse ini file (can fail)
$ini = parse_ini_file('config.ini') or die;

# Read in apikey from config.cfg or die
$apiKey = $ini['apikey'] or die("API key required in config.ini for API login\n");
# Optional: read in username from config.ini
$username = $ini['username'];
# Optional: read in password from config.ini
$password = $ini['password'];

#####POST#####
# Make a request to the Dyn Message Management API
function apiRequest($uri, $requestType, $params) {
	$ch = curl_init();
	# TRUE to return the transfer as a string of the return value of curl_exec() instead of outputting it out directly
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	# Do not fail silently. We want a response regardless
	curl_setopt($ch, CURLOPT_FAILONERROR, false);
	# Disables the response header and only returns the response body
	curl_setopt($ch, CURLOPT_HEADER, false);
	# Set the token and the content type so we know the response format
	curl_setopt($ch, CURLOPT_HTTPHEADER, array('content-type' => 'application/json'));
	curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $requestType);
	# Specify the zone uri where this action is going
	curl_setopt($ch, CURLOPT_URL, $uri);
	curl_setopt($ch, CURLOPT_POSTFIELDS, $params);
	
	$result = curl_exec($ch);
	
	# Decode from JSON as our results are in the same format as our request
	$result = json_decode($result);
	return $result;
}

#####POST#####
# Create or modify an account
function createEditAccount() {
	# Use the API key declared at the global level
	global $apiKey;
	# Specify API resource URI and parameters
	$uri = 'https://emailapi.dynect.net/rest/json/accounts';
	$params = array(
		'apikey' => $apiKey,
		'username' => $username,
		'password' => $password,
		'companyname' => 'Examples, Inc.',
		'phone' => '555-555-5555'
	);
	
	# Convert parameters into an HTTP query form, delimeted by &
	# Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example%40example.com
	$contents = http_build_query($params, '', '&');
	
	# Make the web request
	$result = apiRequest($uri, 'POST', $contents);	
	
	# Print results on success
	if ($result->status == 200) {
		print "Account modified or created succesfully.\n";
	}
	# Throw an error message if API command is not successful
	else {
		print "API Error:\n";
		print "Status: " . $result->status . "\n";
		print "Message: " . $result->message . "\n";
	}
	return;
}

#####POST#####
# Add to the list of approved senders
function addSenders() {
	# Use the API key declared at the global level
	global $apiKey;
	# Specify API resource URI and parameters
	$uri = 'http://emailapi.dynect.net/rest/json/senders';
	$params = array(
		'apikey' => $apiKey,	
		'emailaddress' => 'example@example.com'
	);
	
	# Convert parameters into an HTTP query form, delimeted by &
	# Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example%40example.com
	$contents = http_build_query($params, '', '&');
	
	# Make the web request
	$result = apiRequest($uri, 'POST', $contents);	
	
	# Print results on success
	if ($result->status == 200) {
		print "Sender added succesfully.\n";
	}
	# Throw an error message if API command is not successful
	else {
		print "API Error:\n";
		print "Status: " . $result->status . "\n";
		print "Message: " . $result->message . "\n";
	}
	return;
}

#####POST#####
# Add to the list of approved recipients
function addRecipients() {
	# Use the API key declared at the global level
	global $apiKey;
	# Specify API resource URI and parameters
	$uri = 'http://emailapi.dynect.net/rest/json/recipients/activate';
	$params = array(
		'apikey' => $apiKey,	
		'emailaddress' => 'example@example.com'
	);
	
	# Convert parameters into an HTTP query form, delimeted by &
	# Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example%40example.com
	$contents = http_build_query($params, '', '&');
	
	# Make the web request
	$result = apiRequest($uri, 'POST', $contents);	
	
	# Print results on success
	if ($result->status == 200) {
		print "Recipient added succesfully.\n";
	}
	# Throw an error message if API command is not successful
	else {
		print "API Error:\n";
		print "Status: " . $result->status . "\n";
		print "Message: " . $result->message . "\n";
	}
	return;
}

#####GET#####
# Return number of successfully delivered emails
function reportDelivered() {
	# Use the API key declared at the global level
	global $apiKey;
	# Specify parameters for the API request
 	$params = array(
 		'apikey' => $apiKey,
 		'starttime' => '2013-12-01',
 		'endtime' => '2014-01-31'
 	);
 	
 	# Convert parameters into an HTTP query form, delimeted by &
	# Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example%40example.com
	$contents = http_build_query($params, '', '&');
 	
 	# Append HTTP query form info to the URI
 	$uri = 'http://emailapi.dynect.net/rest/json/reports/sent/count?' . $contents;
 	
 	# Make the web request
 	$result = apiRequest($uri, 'GET', $params);	
	
	# Print results on success
	if ($result->response->status == 200) {
		print "Messages delivered successfully: " . $decode->response->data->count . "\n";
	}
	# Throw an error message if API request is not successful
	else {
		print "API Error:\n";
		print "Status: " . $result->status . "\n";
		print "Message: " . $result->message . "\n";
	}
	return;
}

#####GET#####
# Return a report of bounced emails
function reportBounced($startIndex) {
	# Use the API key declared at the global level
	global $apiKey;
	# Specify parameters for the API request
 	$params = array(
 		'apikey' => $apiKey,
 		'starttime' => '2013-12-01',
 		'endtime' => '2014-01-31',
 		'startindex' => $startIndex
 	);
 	
 	# Convert parameters into an HTTP query form, delimeted by &
	# Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example%40example.com
	$contents = http_build_query($params, '', '&');
	
	# Append HTTP query form info to the URI
	$uri = 'http://emailapi.dynect.net/rest/json/reports/bounces?' . $contents;

	# Make the web request
 	$result = apiRequest($uri, 'GET', $params);
 	
 	$count = 0;
	if ($result->response->status == 200) {
		foreach ($result->response->data->bounces as $bounce) {
			# Print up to 500 bounce records on success
			if ($count < 500) {
				print "Bounce type: " . $bounce->bouncetype . "\n";
				print "Bounce rule: " . $bounce->bouncerule . "\n";
				print "Sender address: " . $bounce->emailaddress . "\n";
				print "Bounce time: " . $bounce->bouncetime . "\n\n";
				$count++;
			}
			# If 500 records have already been returned
			# Call the function again with a start index incremented by 500
			else {
				reportBounced($startIndex + 500);
				return;
			}
		}
	}
	# Throw an error message if API request is not successful
	else {
		print "API Error:\n";
		print "Status: " . $result->status . "\n";
		print "Message: " . $result->message . "\n";
	}
	return;
}

#####POST#####
# Send email with the Dyn Message Manager API
function sendEmail() {
	# Use the API key declared at the global level
	global $apiKey;
	# Specify API resource URI and parameters
	$uri = 'http://emailapi.dynect.net/rest/json/send';
	$params = array(
		'apikey' => $apiKey,	
		'from' => 'example@example.com',
		'to' => 'example2@example.com',
		'subject' => 'Test',
		'bodytext' => 'Test test test test.'
	);
	
	# Convert parameters into an HTTP query form, delimeted by &
	# Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example%40example.com
	$contents = http_build_query($params, '', '&');
	
	# Make the web request
	$result = apiRequest($uri, 'POST', $contents);	
	
	# Print results on success
	if ($result->response->status == 200) {
		print "Sender: " . $params['from'];
		print "Recipient: " . $params['to'];
		print "Email sent succesfully.\n\n";
	}
	# Throw an error message if API request is not successful
	else {
		print "API Error:\n";
		print "Status: " . $result->status . "\n";
		print "Message: " . $result->message . "\n";
	}
	return;
}

?>
