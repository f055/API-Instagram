#!/usr/bin/env perl

use strict;
use warnings;
use Test::MockObject::Extends; 

use JSON;
use API::Instagram;
use Test::More tests => 23;

my $api = Test::MockObject::Extends->new(
	API::Instagram->new({
			client_id     => '123',
			client_secret => '456',
			redirect_uri  => 'http://localhost',
	})
);

my $data = decode_json join '', <DATA>;
$api->mock('_request', sub { $data });
$api->mock('_get_list', sub { [] });

my $user = $api->user("1574083");
isa_ok( $user, 'API::Instagram::User' );

is( $user->id, 1574083, 'user_id' );
is( $user->username, 'snoopdogg', 'user_username' );
is( $user->full_name, 'Snoop Dogg', 'user_fullname' );
is( $user->bio, 'This is my bio', 'user_bio' );
is( $user->website, 'http://snoopdogg.com', 'user_website' );

is( $user->media, 1320, 'user_media' );
is( $user->follows, 420, 'user_follows' );
is( $user->followed_by, 3410, 'user_followed_by' );

is( $user->media(1), 1320, 'user_media' );
is( $user->follows(1), 420, 'user_follows' );
is( $user->followed_by(1), 3410, 'user_followed_by' );

is( ref $user->get_follows, 'ARRAY', 'user_get_follows' );
is( ref $user->get_followers, 'ARRAY', 'user_get_followers' );
is( ref $user->recent_medias, 'ARRAY', 'user_recent_medias' );

is( $user->feed, undef, 'user_feed' );
is( $user->liked_media, undef, 'user_liked_media' );
is( $user->requested_by, undef, 'user_requested_by' );

$data->{data}->{id} = 'self';
my $user2 = $api->user( $data->{data} );
isa_ok( $user2, 'API::Instagram::User' );

is( $user2->id, 'self', 'user2_id' );
is( ref $user2->feed, 'ARRAY', 'user2_feed' );
is( ref $user2->liked_media, 'ARRAY', 'user2_liked_media' );
is( ref $user2->requested_by, 'ARRAY', 'user2_requested_by' );

__DATA__
{
    "data": {
        "id": "1574083",
        "username": "snoopdogg",
        "full_name": "Snoop Dogg",
        "profile_picture": "http://distillery.s3.amazonaws.com/profiles/profile_1574083_75sq_1295469061.jpg",
        "bio": "This is my bio",
        "website": "http://snoopdogg.com",
        "counts": {
            "media": 1320,
            "follows": 420,
            "followed_by": 3410
        }
    }
}