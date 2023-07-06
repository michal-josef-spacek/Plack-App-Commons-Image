package Plack::App::Commons::Image;

use base qw(Plack::Component::Tags::HTML);
use strict;
use warnings;

use Commons::Link;
use Data::Commons::Image;
use Data::HTML::Button;
use Data::HTML::Form;
use Data::HTML::Form::Input;
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

	if ($self->{'_page'} eq 'image_form') {
		$self->{'_html_form'}->process_css(@{$self->{'_form_fields'}});
	} elsif ($self->{'_page'} eq 'image') {
		$self->{'_html_image'}->process_css;
	}

	return;
}

sub _prepare_app {
	my $self = shift;

	# Inherite defaults.
	$self->SUPER::_prepare_app;

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
		'form' => Data::HTML::Form->new(
			'css_class' => 'form',
			'label' => 'Wikimedia Commons image form',
		),
		'submit' => Data::HTML::Button->new(
			'data' => 'View image',
			'name' => 'page',
			'type' => 'submit',
			'value' => 'image',
		),
	);
	$self->{'_html_image'} = Tags::HTML::Image->new(
		%p,
		'img_src_cb' => sub {
			my $image = shift;
			return $self->{'_link'}->thumb_link($image->commons_name, $self->image_width);
		},
	);

	$self->{'_form_fields'} = [
		Data::HTML::Form::Input->new(
			'autofocus' => 1,
			'id' => 'image',
			'label' => 'Commons Image',
			'type' => 'text',
		),
	];

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
		$self->{'_html_image'}->init(
			Data::Commons::Image->new(
				'commons_name' => $self->image,
			),
		);
	}

	return;
}

sub _tags_middle {
	my $self = shift;

	# Image form.
	if ($self->{'_page'} eq 'image_form') {
		$self->{'_html_form'}->process(@{$self->{'_form_fields'}});

	# Image view.
	} elsif ($self->{'_page'} eq 'image') {
		$self->{'_html_image'}->process;
	}

	return;
}

1;

__END__
