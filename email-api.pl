#!/usr/bin/perl

#####Username and password usually aren't required. Make optional in config.cfg?#####

use warnings;
use strict;
use Config::Simple;
use LWP::UserAgent;
use URI;
use URI::QueryParam;
use JSON;

# Create config reader
my $config = new Config::Simple();
# Read configuration file (can fail)
$config->read('config.cfg') or die $config->error();
# Dump config variables into hash for later use
my %configOptions = $config->vars();

# Read in API key from config.cfg
my $apikey = $configOptions{'apikey'} or do {
	print "API key required in config.cfg for API login\n";
	exit;
};
# Read in username from config.cfg
my $username = $configOptions{'username'} or do {
	print "Username required in config.cfg for API login\n";
	exit;
};
# Read in password from config.cfg
my $password = $configOptions{'password'} or do {
	print "User password required in config.cfg for API login\n";
	exit;
};

#####POST#####
# Create or modify an account
sub createEditAccount() {
	# Specify API resource URI and parameters
	my $uri = 'https://emailapi.dynect.net/rest/json/accounts';
	my %params = (
		'apikey' => $apikey,
		'username' => $username,
		'password' => $password,
		'companyname' => 'Example Inc.',
		'phone' => '555-555-5555'
	);
	
	# Convert parameters into an HTTP query form, delimeted by &
	# Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example@example.com
	my $uriQuery = URI->new(" ", "http");
	$uriQuery->query_form_hash(\%params);
	my $contents = $uriQuery->query;
	# Set up the HTTP request
	my $request = HTTP::Request->new(POST => $uri);
	$request->header('content-type' => 'application/x-www-form-urlencoded');
	$request->content($contents);
	# Make the web request
	my $lwp = LWP::UserAgent->new;
	my $response = $lwp->request($request);
	my $decode = decode_json($response->content);
	# Throw an error message if request is not successful
	if (not $decode->{'response'}->{'status'} eq '200') {
		print "API Error:\n";
		print "Status: " . $decode->{'response'}->{'status'} . "\n";
		print "Message: " . $decode->{'response'}->{'message'} . "\n";
		return;
	}
	else {
		print "Account succesfully created or modified.";
		return;
	}
}

#####POST#####
# Add to the list of approved senders
sub addSenders() {
	# Specify API resource URI and parameters	
	my $uri = 'http://emailapi.dynect.net/rest/json/senders';
	my %params = (
		'apikey' => $apikey,	
		'emailaddress' => 'example@example.com'
	);
	# Convert parameters into an HTTP query form, delimeted by &
	# Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example@example.com
	my $uriQuery = URI->new(" ", "http");
	$uriQuery->query_form_hash(\%params);
	my $contents = $uriQuery->query;
	
	# Set up the HTTP request
	my $request = HTTP::Request->new(POST => $uri);
	$request->header('content-type' => 'application/x-www-form-urlencoded');
	$request->content($contents);

	# Make the web request
	my $lwp = LWP::UserAgent->new;
	my $response = $lwp->request($request);
	my $decode = decode_json($response->content);
	
	# Throw an error message if request is not successful
	if (not $decode->{'response'}->{'status'} eq '200') {
		print "API Error:\n";
		print "Status: " . $decode->{'response'}->{'status'} . "\n";
		print "Message: " . $decode->{'response'}->{'message'} . "\n";
		return;
	}
	else {
		print "Sender added succesfully.\n";
		return;
	}
}

#####POST#####
# Add to the list of approved recipients
sub addRecipients() {
	# Specify API resource URI and parameters
	my $uri = 'http://emailapi.dynect.net/rest/json/recipients/activate';
	my %params = (
		'apikey' => $apikey,	
		'emailaddress' => 'example@example.com'
	);
	# Convert parameters into an HTTP query form, delimeted by &
	# Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example@example.com
	my $uriQuery = URI->new(" ", "http");
	$uriQuery->query_form_hash(\%params);
	my $contents = $uriQuery->query;
	
	# Set up the HTTP request
	my $request = HTTP::Request->new(POST => $uri);
	$request->header('content-type' => 'application/x-www-form-urlencoded');
	$request->content($contents);

	# Make the web request
	my $lwp = LWP::UserAgent->new;
	my $response = $lwp->request($request);
	my $decode = decode_json($response->content);
	
	# Throw an error message if request is not successful
	if (not $decode->{'response'}->{'status'} eq '200') {
		print "API Error:\n";
		print "Status: " . $decode->{'response'}->{'status'} . "\n";
		print "Message: " . $decode->{'response'}->{'message'} . "\n";
		return;
	}
	else {
		print "Recipient added succesfully.\n";
		return;
	}
}

#####GET#####
# Return number of successfully delivered emails
sub reportDelivered() {
	#####Need to add a starttime and endtime#####
 	# Specify API resource URI and parameters
	my $uri = 'http://emailapi.dynect.net/rest/json/reports/sent/count?apikey=' . $apikey;
 
	# Set up the HTTP request
	my $request = HTTP::Request->new(GET => $uri);
	$request->header('content-type' => 'application/json');
 	
 	# Make the web request
 	my $lwp = LWP::UserAgent->new;
	my $response = $lwp->request($request);
	my $decode = decode_json($response->content);
	
	# Throw an error message if request is not successful
	if (not $decode->{'response'}->{'status'} eq '200') {
		print "API Error:\n";
		print "Status: " . $decode->{'response'}->{'status'} . "\n";
		print "Message: " . $decode->{'response'}->{'message'} . "\n";
		return;
	}
	else {
		print "Messages delivered: " . $decode->{'response'}->{'data'}->{'count'} . "\n";
		return;
	}
}

reportDelivered();

#####GET#####
# Return a report of bounced emails
sub reportBounced() {
	#####Need to add a starttime and endtime#####
	# Specify API resource URI and parameters
	my $uri = 'http://emailapi.dynect.net/rest/json/reports/bounces/count?apikey=' . $apikey;
 
	# Set up the HTTP request
	my $request = HTTP::Request->new(GET => $uri);
	$request->header('content-type' => 'application/json');
 	
 	# Make the web request
 	my $lwp = LWP::UserAgent->new;
	my $response = $lwp->request($request);
	my $decode = decode_json($response->content);
	
	# Throw an error message if request is not successful
	if (not $decode->{'response'}->{'status'} eq '200') {
		print "API Error:\n";
		print "Status: " . $decode->{'response'}->{'status'} . "\n";
		print "Message: " . $decode->{'response'}->{'message'} . "\n";
		return;
	}
	else {
		#####Need to cycle through sets of 500#####
		return;
	}
}

#####POST#####
# Send email with the Dyn Message Manager API
sub sendEmail() {
	# Specify API resource URI and parameters
	my $uri = 'http://emailapi.dynect.net/rest/json/send';
	my %params = (
		'apikey' => $apikey,	
		'from' => '',
		'to' => '',
		'subject' => '',
		'bodytext' => ''
	);
	# Convert parameters into an HTTP query form, delimeted by &
	# Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example@example.com
	my $uriQuery = URI->new(" ", "http");
	$uriQuery->query_form_hash(\%params);
	my $contents = $uriQuery->query;
	
	# Set up the HTTP request
	my $request = HTTP::Request->new(POST => $uri);
	$request->header('content-type' => 'application/x-www-form-urlencoded');
	$request->content($contents);

	# Make the web request
	my $lwp = LWP::UserAgent->new;
	my $response = $lwp->request($request);
	my $decode = decode_json($response->content);
	
	# Throw an error message if request is not successful
	if (not $decode->{'response'}->{'status'} eq '200') {
		print "API Error:\n";
		print "Status: " . $decode->{'response'}->{'status'} . "\n";
		print "Message: " . $decode->{'response'}->{'message'} . "\n";
		return;
	}
	else {
		print "Mail sent successfully.\n";
		return;
	}
}
