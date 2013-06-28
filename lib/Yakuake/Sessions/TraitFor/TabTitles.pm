# @(#)Ident: TabTitles.pm 2013-06-28 13:02 pjf ;

package Yakuake::Sessions::TraitFor::TabTitles;

use namespace::sweep;
use version; our $VERSION = qv( sprintf '0.6.%d', q$Rev: 4 $ =~ /\d+/gmx );

use Class::Usul::Constants;
use Class::Usul::Functions  qw( throw );
use Cwd                     qw( getcwd );
use File::DataClass::Types  qw( NonEmptySimpleStr );
use Moo::Role;
use MooX::Options;

requires qw( config_dir extra_argv loc yakuake_sessions yakuake_tabs );

# Public methods
sub get_tab_title {
   my ($self, $sess_id) = @_;

   $sess_id ||= $self->yakuake_sessions( q(activeSessionId) );

  (my $title = $self->yakuake_tabs( q(tabTitle), $sess_id ))
      =~ s{ \A \d+ \s+ }{}mx;

   return $title;
}

sub set_tab_title : method {
   my ($self, $sess_id, $title, $tty_num) = @_;

   $sess_id ||= $self->yakuake_sessions( 'activeSessionId' );
   $title   ||= shift @{ $self->extra_argv } || $self->config->tab_title;
   $tty_num ||= $ENV{TTY};

   $self->yakuake_tabs( 'setTabTitle', $sess_id, "${tty_num} ${title}" );
   return OK;
}

sub set_tab_title_for_project : method {
   my $self = shift; my $title = shift @{ $self->extra_argv };

   $title or throw $self->loc( 'No tab title' );
   $self->set_tab_title( undef, $title );

   my $appbase = shift @{ $self->extra_argv } || getcwd;

   $self->config_dir->catfile( 'project_'.$ENV{TTY} )->println( $appbase );
   return OK;
}

1;

__END__

=pod

=encoding utf8

=head1 Name

Yakuake::Sessions::TraitFor::TabTitles - Displays the tab title text

=head1 Synopsis

   use Moo;

   extends 'Yakuake::Sessions::Base';
   with    'Yakuake::Sessions::TraitFor::TabTitles';

=head1 Version

This documents version v0.6.$Rev: 4 $ of
L<Yakuake::Sessions::TraitFor::TabTitles>

=head1 Description

Methods to set the tab title text

=head1 Configuration and Environment

Requires these attribute; C<config_dir>, C<yakuake_sessions>, and
C<yakuake_tabs>

Defines the following attributes;

=over 3

=item C<tab_title>

Default title to apply to tabs. Defaults to the config class value;
C<Shell>

=back

=head1 Subroutines/Methods

=head2 set_tab_title

   $exit_code = $self->set_tab_title;

Sets the current tabs title text to the specified value. Defaults to the
vale supplied in the configuration

=head2 set_tab_title_for_project

   $exit_code = $self->set_tab_title_for_project;

Set the current tabs title text to the specified value. Must supply a
title text. Will save the project name for use by
C<yakuake_session_tt_cd>

=head1 Diagnostics

None

=head1 Dependencies

=over 3

=item L<Class::Usul>

=item L<File::DataClass>

=item L<Moo::Role>

=back

=head1 Incompatibilities

There are no known incompatibilities in this module

=head1 Bugs and Limitations

There are no known bugs in this module.
Please report problems to the address below.
Patches are welcome

=head1 Acknowledgements

Larry Wall - For the Perl programming language

=head1 Author

Peter Flanigan, C<< <pjfl@cpan.org> >>

=head1 License and Copyright

Copyright (c) 2013 Peter Flanigan. All rights reserved

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. See L<perlartistic>

This program is distributed in the hope that it will be useful,
but WITHOUT WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE

=cut

# Local Variables:
# mode: perl
# tab-width: 3
# End:
