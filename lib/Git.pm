# $Id$
package Module::Release::Git;

use strict;
use warnings;
use base qw(Exporter Module::Release);

our @EXPORT = qw(check_cvs cvs_tag);

our $VERSION = '0.10_01';

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

This module depends on the external git binary (so far).

=cut

=head2 C<check_cvs()>

Check the state of the Git repository.

=cut

sub check_cvs 
	{
	my $self = shift;
	
	$self->_print( "Checking state of Git... " );
	
	my $git_status = $self->run('git status 2>&1');
	
	if( $? ) 
		{
		die sprintf("\nERROR: git failed with non-zero exit status: %d\n\n"
			. "Aborting release\n", $? >> 8);
		}
	
	my $branch = $git_status =~ /^# On branch (\w+)/;
	
	my $up_to_date = $git_status =~ /^nothing to commit \(working directory clean\)/m;
	
	die "\nERROR: Git is not up-to-date: Can't release files\n\n$git_status\n"
		unless $up_to_date;
	
	$self->_print( "Git up-to-date\n" );
	
	return 1;
	}

=head2 C<cvs_tag(TAG)>

Tag the release in local Git.

=cut

sub cvs_tag 
	{
	my( $self, $tag ) = @_;
	
	$self->_print( "Tagging release with $tag\n" );

	$self->run( 'git tag $tag' );

	return 1;
	}

sub _print
	{
	my $self = shift;

	print @_;
	}
	
=head1 TO DO

=over 4

=item Use Gitlib.pm whenever it exists

=item More options for tagging

=back

=head1 SEE ALSO

L<Module::Release::Subversion>, L<Module::Release>

=head1 SOURCE AVAILABILITY

So far this is in a private git repository. It's only private because I'm
lazy. I can send it to you if you like, and I promise to set up something
public Real Soon Now.

=head1 AUTHOR

brian d foy, C<< <bdfoy@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2007, brian d foy, All Rights Reserved.

You may redistribute this under the same terms as Perl itself.

=cut

1;
