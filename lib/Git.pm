# $Id$
package Module::Release::Git;

use strict;
use warnings;
use base qw(Exporter);

our @EXPORT = qw(check_cvs cvs_tag make_cvs_tag);

our $VERSION = '0.10_03';

=head1 NAME

Module::Release::Git - Use Git with Module::Release

=head1 SYNOPSIS

The release script automatically loads this module if it sees a 
F<.git> directory. The module exports check_cvs, cvs_tag, and make_cvs_tag.

=head1 DESCRIPTION

Module::Release::Git subclasses Module::Release, and provides
its own implementations of the C<check_cvs()> and C<cvs_tag()> methods
that are suitable for use with a Subversion repository rather than a
CVS repository.

These methods are B<automatically> exported in to the callers namespace
using Exporter.

This module depends on the external git binary (so far).

=over 4

=item check_cvs()

Check the state of the Git repository.

=cut

sub check_cvs 
	{
	my $self = shift;
	
	$self->_print( "Checking state of Git... " );
	
	my $git_status = $self->run('git status 2>&1');
		
	no warnings 'uninitialized';

	my $branch = $git_status =~ /^# On branch (\w+)/;
	
	my $up_to_date = $git_status =~ /^nothing to commit \(working directory clean\)/m;
	
	$self->_die( "\nERROR: Git is not up-to-date: Can't release files\n\n$git_status\n" )
		unless $up_to_date;
	
	$self->_print( "Git up-to-date on branch $branch\n" );
	
	return 1;
	}

=item cvs_tag(TAG)

Tag the release in local Git.

=cut

sub cvs_tag 
	{
	my( $self, $tag ) = @_;
	
	$tag ||= $self->make_cvs_tag;
	
	$self->_print( "Tagging release with $tag\n" );

	$self->run( 'git tag $tag' );

	return 1;
	}

=item make_cvs_tag

By default, examines the name of the remote file
(i.e. F<Foo-Bar-0.04.tar.gz>) and constructs a tag string like
C<RELEASE_0_04> from it.  Override this method if you want to use a
different tagging scheme, or don't even call it.

=cut

sub make_cvs_tag
	{
	my $self = shift;
	my( $major, $minor ) = $self->{remote}
		=~ /(\d+) \. (\d+(?:_\d+)?) (?:\. tar \. gz)? $/xg;

	return "RELEASE_${major}_${minor}";
	}

=back
	
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

Copyright (c) 2007-2008, brian d foy, All Rights Reserved.

You may redistribute this under the same terms as Perl itself.

=cut

1;
