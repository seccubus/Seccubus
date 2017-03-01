# ------------------------------------------------------------------------------
# Copyright 2017 Frank Breedijk
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
package Seccubus;
use Mojo::Base 'Mojolicious';

use strict;

use Seccubus::Controller;
use lib "..";
use SeccubusV2;
use Data::Dumper;

# This method will run once at server start
sub startup {
	my $self = shift;

	# Set an alternative controller class to set some global headers
	$self->controller_class('Seccubus::Controller');

	# Security
	$self->secrets(['SeccubusScanSmarterNotHarder']);

	# Set up error helper
	$self->helper( error => sub {
		my ($self, $message, $status ) = @_;

		$status = 400 unless $status;
		$message = "error" unless $message;
		
		$self->render(
			json => {
				status => "Error",
				message => $message,
			},
			status => $status
		);
	});

	# Router
	my $r = $self->routes;

	# App Status 
	$r->get('/appstatus')->to('app_status#read');

	# Version
	$r->get('/version')->to('version#read');

	# Workspace
	$r->post('workspaces')->to('workspaces#create');
	$r->get('workspaces')->to('workspaces#list');
	#$r->get('workspace/:id')->to('workspaces#read');
	$r->put('workspace/:id')->to('workspaces#update');
	#$r->delete('workspace/:id')->to('workspaces#delete');

	# Scans
	$r->post('workspace/:workspace_id/scans')->to('scans#create');
	$r->get('workspace/:workspace_id/scans')->to('scans#list');
	$r->get('workspace/:workspace_id/scan/:scan_id')->to('scans#read');
	$r->put('workspace/:workspace_id/scan/:scan_id')->to('scans#update');
	$r->delete('workspace/:id/scan/:scan_id')->to('scans#delete');

	$r->get('/')->to(cb => sub {  
		my $c = shift;                                   
		$c->redirect_to('seccubus/seccubus.html')                
	}); 


	# Normal route to controller
	#$r->get('/')->to('default#welcome');
	#$r->get('/')->to(cb => sub {  
	#	my $c = shift;                                   
	#	$c->reply->static('seccubus.html')                
	#}); 
}


1;