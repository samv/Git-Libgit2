package Git::Libgit2;

use 5.008007;
use strict;
use warnings;

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('Git::Libgit2', $VERSION);

# selective cut & paste from Git::PurePerl 0.47 begins.
use Moose;
use MooseX::StrictConstructor;
use MooseX::Types::Path::Class;
use Path::Class;
use namespace::autoclean;

has 'directory' => (
    is       => 'ro',
    isa      => 'Path::Class::Dir',
    required => 0,
    coerce   => 1
);

has 'gitdir' => (
    is       => 'ro',
    isa      => 'Path::Class::Dir',
    required => 1,
    coerce   => 1
);

# has 'loose' => (
#     is         => 'rw',
#     isa        => 'Git::PurePerl::Loose',
#     required   => 0,
#     lazy_build => 1,
# );

# has 'packs' => (
#     is         => 'rw',
#     isa        => 'ArrayRef[Git::PurePerl::Pack]',
#     required   => 0,
#     auto_deref => 1,
#     lazy_build => 1,
# );

has 'description' => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    default => sub {
        my $self = shift;
        file( $self->gitdir, 'description' )->slurp( chomp => 1 );
    }
);

# has 'config' => (
#     is      => 'ro',
#     isa     => 'Git::PurePerl::Config',
#     lazy    => 1,
#     default => sub {
#         my $self = shift;
#         Git::PurePerl::Config->new(git => $self);
#     }
# );

has '__C' => (
	is => 'ro',
	isa => "Git::Libgit2::repo",
	lazy => 1,
	predicate => "__has_C",
	default => sub {
		my $self = shift;
		# could do git_repository_open2 if they passed in
		# both gitdir and directory/workdir
		git_repository_open($self->gitdir);
	}
);

sub DESTROY {
	my $self = shift;
	if ( $self->__has_C ) {
		git_repository_free($self->__C);
	}
}

__PACKAGE__->meta->make_immutable;

sub BUILDARGS {
    my $class  = shift;
    my $params = $class->SUPER::BUILDARGS(@_);

    $params->{'gitdir'} ||= dir( $params->{'directory'}, '.git' );
    return $params;
}

sub BUILD {
    my $self = shift;

    unless ( -d $self->gitdir ) {
        confess $self->gitdir . ' is not a directory';
    }
    unless ( not defined $self->directory or -d $self->directory ) {
        confess $self->directory . ' is not a directory';
    }
}

# sub _build_loose {
#     my $self = shift;
#     my $loose_dir = dir( $self->gitdir, 'objects' );
#     return Git::PurePerl::Loose->new( directory => $loose_dir );
# }

# sub _build_packs {
#     my $self = shift;
#     my $pack_dir = dir( $self->gitdir, 'objects', 'pack' );
#     my @packs;
#     foreach my $filename ( $pack_dir->children ) {
#         next unless $filename =~ /\.pack$/;
#         push @packs,
#             Git::PurePerl::Pack::WithIndex->new( filename => $filename );
#     }
#     return \@packs;
# }


1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Git::Libgit2 - Perl extension for libgit2

=head1 SYNOPSIS

  use Git::Libgit2;
  my $git = Git::Libgit2->new(
      directory => '/path/to/git'
  );
  $git->master->committer;
  $git->master->comment;
  $git->get_object($git->master->tree);

=head1 DESCRIPTION

This is a port of Git::PurePerl, which does all its work via the
C<libgit2> library which is linked via XS.

=head1 MODULE MAP

The following structures/classes are charted:

  Git::PurePerl class  |     grit class        |   libgit2 struct
 ----------------------+-----------------------+------------------
  Git::PurePerl        | Grit::Repo            | git_repository


=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Sam Vilain, E<lt>samv@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Sam Vilain

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.


=cut
