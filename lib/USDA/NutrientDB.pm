package USDA::NutrientDB;
# ABSTRACT: query the USDA National Nutrient Database

=head1 SYNOPSIS

    use USDA::NutrientDB;

    my $ndb = USDA::NutrientDB->create(api_key => 'foo');
    my @results = $ndb->search('cheddar');

    foreach my $food (@results) {
        say $food->kcal;
    }

=head1 DESCRIPTION

This module provides an interface for querying the USDA National Nutrient
Database. It can be accessed via the public REST API (requires a free API key)
or a local copy of the database.

=head1 METHODS

=head2 C<create(api_key => $key)>

Returns a connection to the public REST API, or undef if C<$key> is not a valid
API key.

=head1 SEE ALSO

=over 4

=item *

USDA National Nutrient Database homepage: http://ndb.nal.usda.gov/

=back

=cut

use namespace::autoclean;

use MooseX::AbstractFactory;

implementation_does [ 'USDA::NutrientDB::Implementation::Requires' ];
implementation_class_via sub { 'USDA::NutrientDB::Implementation::' . shift };

__PACKAGE__->meta->make_immutable;
