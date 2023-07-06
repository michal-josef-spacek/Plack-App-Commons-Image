use lib '.';
use strict;
use warnings;

use inc::Module::Install;

# Definition.
abstract 'Plack application for Wikimedia Commons image view.';
author 'Michal Josef Spacek <skim@cpan.org>';
author_requires 'English' => 0;
author_requires 'File::Object' => 0;
author_requires 'Test::More' => 0;
author_requires 'Test::NoWarnings' => 0;
author_requires 'Test::Pod' => 0;
author_requires 'Test::Pod::Coverage' => 0;
license 'bsd';
name 'Plack-App-Commons-Image';
perl_version 5.008;
readme_from 'Image.pm';
recursive_author_tests('xt');
requires 'Commons::Link' => 0.07;
requires 'Data::Commons::Image' => 0.06;
requires 'Data::HTML::Button' => 0.04;
requires 'Data::HTML::Form' => 0.04;
requires 'Data::HTML::Form::Input' => 0.06;
requires 'Plack::Component::Tags::HTML' => 0.15;
requires 'Plack::Request' => 0;
requires 'Plack::Util::Accessor' => 0;
requires 'Readonly' => 0;
requires 'Tags::HTML::Form' => 0.07;
requires 'Tags::HTML::Image' => 0;
requires 'URL::Encode' => 0;
resources 'bugtracker' => 'https://github.com/michal-josef-spacek/Plack-App-Commons-Image/issues';
resources 'homepage' => 'https://github.com/michal-josef-spacek/Plack-App-Commons-Image';
resources 'repository' => 'git://github.com/michal-josef-spacek/Plack-App-Commong-Image';
test_requires 'Test::More' => 0;
test_requires 'Test::NoWarnings' => 0;
tests_recursive;
version '0.01';

# Run.
WriteAll();
