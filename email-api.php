<?php

# Parse ini file (can fail)
$ini = parse_ini_file("config.ini") or die;

# Set the values from file to variables or die
$apikey = $ini['apikey'] or die("API key required in config.ini for API login\n");
$username = $ini['username'] or die("Username required in config.ini for API login\n");
$password = $ini['password'] or die("Password required in config.ini for API login\n");

#####POST#####
# Create or modify an account
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
	global $apikey;
	# Specify API resource URI and parameters
	$uri = 'https://emailapi.dynect.net/rest/json/accounts';
	$params = array(
		'apikey' => $apikey,
		'username' => $username,
		'password' => $password,
		'companyname' => 'Examples, Inc.',
		'phone' => '555-555-5555'
	);
	$contents = http_build_query($params, '', '&');
	print $contents;
	$result = apiRequest($uri, 'POST', $contents);	
	# Throw an error message if API command is not successful
	if ($result->status != 'success') {
		var_dump($result);
	}
	else {
		var_dump($result);
	}
	return;
}

#####POST#####
# Add to the list of approved senders
function addSenders() {
	# Specify API resource URI and parameters
	global $apikey;
	$uri = 'http://emailapi.dynect.net/rest/json/senders';
	$params = array(
		'apikey' => $apikey,	
		'emailaddress' => 'example@example.com'
	);
	# Convert parameters into an HTTP query form, delimeted by &
	# Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example@example.com
	$contents = http_build_query($params, '', '&');
	# Make the web request
	$result = apiRequest($uri, 'POST', $contents);	
	# Throw an error message if API command is not successful
	if ($result->status != 'success') {
		var_dump($result);
	}
	else {
		var_dump($result);
	}
	return;
}

#####POST#####
# Add to the list of approved recipients
function addRecipients() {
	# Specify API resource URI and parameters
	global $apikey;
	$uri = 'http://emailapi.dynect.net/rest/json/recipients/activate';
	$params = array(
		'apikey' => $apikey,	
		'emailaddress' => 'example@example.com'
	);
	# Convert parameters into an HTTP query form, delimeted by &
	# Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example@example.com
	$contents = http_build_query($params, '', '&');
	# Make the web request
	$result = apiRequest($uri, 'POST', $contents);	
	# Throw an error message if API command is not successful
	if ($result->status != 'success') {
		var_dump($result);
	}
	else {
		var_dump($result);
	}
	return;
}

#####GET#####
# Return number of successfully delivered emails
function reportDelivered() {
	# Specify API resource URI and parameters
	global $apikey;
	$uri = 'http://emailapi.dynect.net/rest/json/reports/sent/count?apikey=' . $apikey;
 	$params = array(''=>'');
 	
 	# Make the web request
 	$result = apiRequest($uri, 'GET', $params);	
	# Throw an error message if logout is not successful
	if ($result->response->status != 200) {
		print "API Error:\n";
		print "Status: " . $result->response->status . "\n";
		print "Message: " . $result->response->message . "\n";
	}
	else {
		var_dump($result);
	}
}

#####GET#####
# Return a report of bounced emails
function reportBounced() {
	# Specify API resource URI and parameters
	global $apikey;
	$uri = 'http://emailapi.dynect.net/rest/json/reports/bounces/count?apikey=' . $apikey;
	$params = array(''=>'');

	# Make the web request
 	$result = apiRequest($uri, 'GET', $params);	
	# Throw an error message if logout is not successful
	if ($result->response->status != 200) {
		print "API Error:\n";
		print "Status: " . $result->response->status . "\n";
		print "Message: " . $result->response->message . "\n";
	}
	else {
		var_dump($result);
	}
}

#####POST#####
# Send email with the Dyn Message Manager API
function sendEmail() {
	# Specify API resource URI and parameters
	global $apikey;
	$uri = 'http://emailapi.dynect.net/rest/json/send';
	$params = array(
		'apikey' => $apikey,	
		'from' => '',
		'to' => '',
		'subject' => '',
		'bodytext' => ''
	);
	# Convert parameters into an HTTP query form, delimeted by &
	# Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example@example.com
	$contents = http_build_query($params, '', '&');
	# Make the web request
	$result = apiRequest($uri, 'POST', $contents);	
	# Throw an error message if API command is not successful
	if ($result->status != 'success') {
		var_dump($result);
	}
	else {
		var_dump($result);
	}
	return;
}

?>
