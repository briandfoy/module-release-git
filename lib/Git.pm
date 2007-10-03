# $Id$
package Module::Release::Git;

use strict;
use warnings;
use base qw(Exporter Module::Release);

our @EXPORT = qw(check_cvs cvs_tag);

our $VERSION = '0.10';

=head1 NAME

Module::Release::Git - Use Git instead of CVS with Module::Release

=head1 SYNOPSIS

In F<.releaserc>

  release_subclass Module::Release::Git

In your subclasses of Module::Release:

  use base qw(Module::Release::Git);

=head1 DESCRIPTION

Module::Release::Git subclasses Module::Release, and provides
its own implementations of the C<check_cvs()> and C<cvs_tag()> methods
that are suitable for use with a Subversion repository rather than a
CVS repository.

These methods are B<automatically> exported in to the callers namespace
using Exporter.

=cut

=head2 C<check_cvs()>

Check the state of the Git repository.

=cut

sub check_cvs {
	my $self = shift;
	
	print "Checking state of Git... ";
	
	my $git_update = $self->run('git status 2>&1');
	
	if( $? ) 
		{
		die sprintf("\nERROR: svn failed with non-zero exit status: %d\n\n"
			. "Aborting release\n", $? >> 8);
		}
	
	my $branch = $git_update =~ /^# On branch (\w+)/;
	
	$git_update =~ s/^#.*$//smg;
	$git_update =~ s/^#\s+\(.*?\)$//mg;	
	$git_update =~ s/^#\s*$//mg;	

	my @svn_states = keys %message;
	
	my %svn_state;
	foreach my $state (@svn_states) {
	$svn_state{$state} = [ $svn_update =~ /$state\s+(.*)/gm ];
	
	}
	
	my $rule = "-" x 50;
	my $count;
	my $question_count;
	
	foreach my $key (sort keys %svn_state) {
	my $list = $svn_state{$key};
	next unless @$list;
	$count += @$list unless $key eq qr/^\?......./;
	$question_count += @$list if $key eq qr/^\?......./;
	
	local $" = "\n\t";
	print "\n\t$message{$key}\n\t$rule\n\t@$list\n";
	}
	
	die "\nERROR: Subversion is not up-to-date ($count files): Can't release files\n"
	if $count;
	
	if($question_count) {
	print "\nWARNING: Subversion is not up-to-date ($question_count files unknown); ",
	  "continue anwyay? [Ny] " ;
	die "Exiting\n" unless <> =~ /^[yY]/;
	}
	
	print "Subversion up-to-date\n";
	}




=head1 TO DO


=head1 SEE ALSO


=head1 SOURCE AVAILABILITY

This source is part of a SourceForge project which always has the
latest sources in CVS, as well as all of the previous releases.

	http://sourceforge.net/projects/brian-d-foy/

If, for some reason, I disappear from the world, one of the other
members of the project can shepherd this module appropriately.

=head1 AUTHOR

brian d foy, C<< <bdfoy@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2007, brian d foy, All Rights Reserved.

You may redistribute this under the same terms as Perl itself.

=cut

1;
