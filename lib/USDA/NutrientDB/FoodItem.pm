package USDA::NutrientDB::FoodItem;
# ABSTRACT: a food item from the USDA National Nutrient Database

=head1 SYNOPSIS

    use USDA::NutrientDB;

    my $ndb = USDA::NutrientDB->create('REST', api_key => 'foo');
    my $search = $ndb->search('cheddar');

    while (my $item = $search->next) {
        say $item->kcal,
            $item->protein,
            $item->fat;
    }

=head1 DESCRIPTION

This module provides an object-oriented interface to food items from the USDA
National Nutrient Database. There are methods to access basic nutrient
quantities, like protein, fat, energy, and water content, as well as quantities
of various vitamins and minerals.

=head1 METHODS

=head2 C<new(ndbo => $ndbno, name => $name, food_group => $food_group)>

Returns a new C<USDA::NutrientDB::FoodItem> object. Note that you should not
call this method directly; instead, use the C<search> method from
L<USDA::NutrientDB> to find matching food items in the database.

=head2 C<energy()>

=head2 C<kcal()>

Amount of energy in the edible portion of the food item, in kilocalories.
(Kilocalories are the correct term for what diet books and non-scientists
typically refer to as simply "calories.")

=head2 C<protein()>

Amount of protein in grams.

=head2 C<fat()>

Amount of fat in grams.

=head2 C<carbohydrate()>

Amount of carbohydrate in grams.

=head2 C<fiber()>

Amount of dietary fiber in grams.

=head2 C<sugar()>

Amount of sugar in grams.

=head2 C<water()>

Amount of water in grams.

=head1 SEE ALSO

=over 4

=item *

L<USDA National Nutrient Database homepage|http://ndb.nal.usda.gov/>

=item *

L<USDA::NutrientDB>

=back

=cut
use namespace::autoclean;

use Moose;

has 'ndbno' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has 'name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has 'food_group' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has 'quantity' => (
    is       => 'ro',
    isa      => 'Num',
    required => 1
);

has 'units' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has 'grams' => (
    is       => 'ro',
    isa      => 'Num',
    required => 1
);

has 'energy' => (
    is       => 'ro',
    isa      => 'Num',
    init_arg => undef
);

has 'kcal' => (
    is       => 'ro',
    isa      => 'Num',
    init_arg => undef
);

has 'protein' => (
    is       => 'ro',
    isa      => 'Num',
    init_arg => undef
);

has 'fat' => (
    is       => 'ro',
    isa      => 'Num',
    init_arg => undef
);

has 'carbohydrate' => (
    is       => 'ro',
    isa      => 'Num',
    init_arg => undef
);

has 'fiber' => (
    is       => 'ro',
    isa      => 'Num',
    init_arg => undef
);

has 'sugar' => (
    is       => 'ro',
    isa      => 'Num',
    init_arg => undef
);

has 'water' => (
    is       => 'ro',
    isa      => 'Num',
    init_arg => undef
);

__PACKAGE__->meta->make_immutable;
