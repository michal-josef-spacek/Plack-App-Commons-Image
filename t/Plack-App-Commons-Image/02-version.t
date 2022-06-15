use strict;
use warnings;

use Plack::App::Commons::Image;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Plack::App::Commons::Image::VERSION, 0.01, 'Version.');
