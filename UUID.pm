##
##  CGI::Session::ID::UUID -- UUID based CGI Session Identifiers
##  Copyright (c) 2005 Ralf S. Engelschall <rse@engelschall.com>
##
##  This program is free software; you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation; either version 2 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
##  General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program; if not, write to the Free Software
##  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
##  USA, or contact Ralf S. Engelschall <rse@engelschall.com>.
##
##  UUID.pm: Module Implementation
##

package CGI::Session::ID::UUID;

require 5.006;
use strict;

our $VERSION = '0.01';

#   determine available UUID generator
our $generator;
foreach my $module (qw(OSSP::uuid Data::UUID)) {
    { no strict; no warnings; local $SIG{__DIE__} = 'IGNORE'; 
      eval "use $module"; }
    if (not $@) {
        $generator = $module;
        last;
    }
}
if (not defined($generator)) {
    die "no UUID generator available " .
        "(require OSSP::uuid or Data::UUID)";
}

#   the id generation method
sub generate_id {
    my ($self) = @_;

    my $id;
    if ($generator eq 'OSSP::uuid') {
        #   use OSSP::uuid (preference)
        my $uuid = new OSSP::uuid();
        $uuid->make("v1");
        $id = $uuid->export("str");
        undef $uuid;
    }
    elsif ($generator eq 'Data::UUID') {
        #   use Data::UUID (alternative)
        my $uuid = new Data::UUID();
        $id = $uuid->create_str();
        undef $uuid;
    }

    return $id;
}

1;

=pod

=head1 NAME

CGI::Session::ID::UUID - UUID based CGI Session Identifiers

=head1 SYNOPSIS

use CGI::Session;

$session = new CGI::Session("...;B<id:UUID>", ...);

=head1 DESCRIPTION

CGI::Session::ID::UUID is a CGI::Session driver to generate identifiers
based on DCE 1.1 and ISO/IEC 11578:1996 compliant Universally Unique
Identifiers (UUID). This module requires a reasonable UUID generator.
For this it either requires the OSSP::uuid (preference) or Data::UUID
(alternative) modules to be installed.

=head1 AUTHOR

Ralf S. Engelschall <rse@engelschall.com>

=head1 SEE ALSO

L<CGI::Session|CGI::Session>

L<OSSP::uuid|OSSP::uuid>, http://www.ossp.org/pkg/lib/uuid/

L<Data::UUID|Data::UUID>, http://www.cpan.org/modules/by-module/Data/

=cut

