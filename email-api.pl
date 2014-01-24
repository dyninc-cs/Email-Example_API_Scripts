#!/usr/bin/perl
# Credentials are read in from a configuration file in the same directory. 
# The file is named config.cfg and takes the following format:
#
# customer: [customer]
# username: [username]
# password: [password]
#

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
my $apiKey = $configOptions{'apikey'} or do {
	print "API key required in config.cfg for API login\n";
	exit;
};
# Optioanl: read in username from config.cfg
my $username = $configOptions{'username'};
# Optional: read in password from config.cfg
my $password = $configOptions{'password'};

#####POST#####
# Create or modify an account
sub createEditAccount {
	# Specify API resource URI and parameters
	my $uri = 'https://emailapi.dynect.net/rest/json/accounts';
	my %params = (
		'apikey' => $apiKey,
		'username' => $username,
		'password' => $password,
		'companyname' => 'Test Inc.',
		'phone' => '555-555-5555'
	);
	
	# Convert parameters into an HTTP query form, delimeted by &
	# Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example%40example.com
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
	
	# Print results
	if ($decode->{'response'}->{'status'} == 200) {
		print "Account succesfully created or modified.";
	}
	# Throw an error message if request is not successful
	else {
		print "API Error:\n";
		print "Status: " . $decode->{'response'}->{'status'} . "\n";
		print "Message: " . $decode->{'response'}->{'message'} . "\n";
	}
	return;
}

#####POST#####
# Add to the list of approved senders
sub addSenders {
	# Specify API resource URI and parameters	
	my $uri = 'http://emailapi.dynect.net/rest/json/senders';
	my %params = (
		'apikey' => $apiKey,	
		'emailaddress' => 'example@example.com'
	);
	
	# Convert parameters into an HTTP query form, delimeted by &
	# Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example%40example.com
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
	
	# Print results
	if ($decode->{'response'}->{'status'} == '200') {
		print "Sender added succesfully.\n";
	}
	# Throw an error message if request is not successful
	else {
		print "API Error:\n";
		print "Status: " . $decode->{'response'}->{'status'} . "\n";
		print "Message: " . $decode->{'response'}->{'message'} . "\n";
	}
	return;
}

#####POST#####
# Add to the list of approved recipients
sub addRecipients {
	# Specify API resource URI and parameters
	my $uri = 'http://emailapi.dynect.net/rest/json/recipients/activate';
	my %params = (
		'apikey' => $apiKey,	
		'emailaddress' => 'example@example.com'
	);
	
	# Convert parameters into an HTTP query form, delimeted by &
	# Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example%40example.com
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
	
	# Print results
	if ($decode->{'response'}->{'status'} == 200) {
		print "Recipient added succesfully.\n";
	}
	# Throw an error message if request is not successful
	else {
		print "API Error:\n";
		print "Status: " . $decode->{'response'}->{'status'} . "\n";
		print "Message: " . $decode->{'response'}->{'message'} . "\n";
	}
	return;
}

#####GET#####
# Return number of successfully delivered emails
sub reportDelivered {
	#####Need to add a starttime and endtime#####
 	# Specify parameters for API request
 	my %params = (
 		'apikey' => $apiKey,
 		'starttime' => '2013-12-01',
 		'endtime' => '2014-01-31'
 	);
 	
 	# Convert parameters into an HTTP query form, delimeted by &
	# Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example%40example.com
	my $uriQuery = URI->new(" ", "http");
	$uriQuery->query_form_hash(\%params);
	my $contents = $uriQuery->query;
 	
 	# Append HTTP query form info to the URI
	my $uri = 'http://emailapi.dynect.net/rest/json/reports/sent/count?' . $contents;
 
	# Set up the HTTP request
	my $request = HTTP::Request->new(GET => $uri);
	$request->header('content-type' => 'application/json');
 	
 	# Make the web request
 	my $lwp = LWP::UserAgent->new;
	my $response = $lwp->request($request);
	my $decode = decode_json($response->content);
	
	# Print results
	if ($decode->{'response'}->{'status'} == 200) {
		print "Messages delivered successfully: " . $decode->{'response'}->{'data'}->{'count'} . "\n";
	}
	# Throw an error message if request is not successful
	else {
		print "API Error:\n";
		print "Status: " . $decode->{'response'}->{'status'} . "\n";
		print "Message: " . $decode->{'response'}->{'message'} . "\n";
	}
	return;
}

#####GET#####
# Return a report of bounced emails
# Expects start index argument
# First record can be found at 0
sub reportBounced {
	my $startIndex = @_;
	# Specify parameters for API request
 	my %params = (
 		'apikey' => $apiKey,
 		'starttime' => '2013-11-01',
 		'endtime' => '2014-01-31',
 		'startindex' => $startIndex
 	);
 	
 	# Convert parameters into an HTTP query form, delimeted by &
	# Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example%40example.com
	my $uriQuery = URI->new(" ", "http");
	$uriQuery->query_form_hash(\%params);
	my $contents = $uriQuery->query;
 	
 	# Append HTTP query form info to the URI
	my $uri = 'http://emailapi.dynect.net/rest/json/reports/bounces?' . $contents;
	
	# Set up the HTTP request
	my $request = HTTP::Request->new(GET => $uri);
	$request->header('content-type' => 'application/json');
 	
 	# Make the web request
 	my $lwp = LWP::UserAgent->new;
	my $response = $lwp->request($request);
	my $decode = decode_json($response->content);

	my $count = 0;
	if ($decode->{'response'}->{'status'} == 200) {
		foreach my $bounce ($decode->{'response'}->{'data'}->{'bounces'}[0]) {
			# Print up to 500 bounce records on success
			if ($count < 500) {
				print "Bounce type: " . $bounce->{'bouncetype'} . "\n";
				print "Bounce rule: " . $bounce->{'bouncerule'} . "\n";
				print "Sender address: " . $bounce->{'emailaddress'} . "\n";
				print "Bounce time: " . $bounce->{'bouncetime'} . "\n";
			}
			else {
				reportBounced($startIndex + 500);
				return;
			}
		}
	}
	# Throw an error message if request is not successful
	else {
		print "API Error:\n";
		print "Status: " . $decode->{'response'}->{'status'} . "\n";
		print "Message: " . $decode->{'response'}->{'message'} . "\n";
	}
	return;
}

#####POST#####
# Send email with the Dyn Message Manager API
sub sendEmail {
	# Specify API resource URI and parameters
	my $uri = 'http://emailapi.dynect.net/rest/json/send';
	my %params = (
		'apikey' => $apiKey,	
		'from' => 'example@example.com',
		'to' => 'example2@example.com',
		'subject' => 'Test',
		'bodytext' => 'Test test test test.'
	);
	
	# Convert parameters into an HTTP query form, delimeted by &
	# Example: apikey=dnhtir34ty98uyghdfknfh3&emailaddress=example%40example.com
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
	
	# Print results
	if ($decode->{'response'}->{'status'} == 200) {
		print "Mail sent successfully.\n";
	}
	# Throw an error message if request is not successful
	else {
		print "API Error:\n";
		print "Status: " . $decode->{'response'}->{'status'} . "\n";
		print "Message: " . $decode->{'response'}->{'message'} . "\n";
	}
	return;
}
