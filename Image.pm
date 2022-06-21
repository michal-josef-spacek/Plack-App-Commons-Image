package Plack::App::Commons::Image;

use base qw(Plack::Component::Tags::HTML);
use strict;
use warnings;

use Commons::Link;
use Data::Commons::Image;
use Plack::Request;
use Plack::Util::Accessor qw(image image_width page);
use Readonly;
use Tags::HTML::Form;
use Tags::HTML::Image;
use URL::Encode qw(url_decode_utf8);

Readonly::Scalar our $IMAGE_WIDTH => 800;

our $VERSION = 0.01;

sub _css {
	my $self = shift;

	if ($self->{'_page'} eq 'image') {
		$self->{'_html_image'}->process_css;
	}

	return;
}

sub _prepare_app {
	my $self = shift;

	# Default value for image width.
	if (! defined $self->image_width) {
		$self->image_width($IMAGE_WIDTH);
	}

	# Wikimedia Commons link object.
	$self->{'_link'} = Commons::Link->new;

	my %p = (
		'css' => $self->css,
		'tags' => $self->tags,
	);
	$self->{'_html_form'} = Tags::HTML::Form->new(
		%p,
		'fields' => [{
			'id' => 'image',
			'text' => 'Commons Image',
			'type' => 'text',
		}],
		'submit' => 'View image',
		'submit_name' => 'page',
		'submit_value' => 'image',
		'title' => 'Wikimedia Commons image form',
	);
	$self->{'_html_image'} = Tags::HTML::Image->new(
		%p,
		'img_src_cb' => sub {
			my $image = shift;
			return $self->{'_link'}->thumb_link($image->image, $self->image_width);
		},
	);

	return;
}

sub _process_actions {
	my ($self, $env) = @_;

	my $req = Plack::Request->new($env);

	# Process which on which page we are.
	if ($req->parameters->{'page'}) {
		$self->{'_page'} = $req->parameters->{'page'};
	} elsif (defined $self->page) {
		$self->{'_page'} = $self->page;
	} else {
		$self->{'_page'} = 'image_form';
	}

	# Image page.
	if ($self->{'_page'} eq 'image') {
		if ($req->parameters->{'image'}) {
			$self->image(url_decode_utf8($req->parameters->{'image'}));
		}
		$self->{'_image'} = Data::Commons::Image->new(
			'image' => $self->image,
		);
	}

	return;
}

sub _tags_middle {
	my $self = shift;

	# Image form.
	if ($self->{'_page'} eq 'image_form') {
		$self->{'_html_form'}->process;

	# Image view.
	} elsif ($self->{'_page'} eq 'image') {
		$self->{'_html_image'}->process($self->{'_image'});
	}

	return;
}

1;

__END__
