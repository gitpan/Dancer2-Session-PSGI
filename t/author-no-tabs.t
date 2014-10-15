
BEGIN {
  unless ($ENV{AUTHOR_TESTING}) {
    require Test::More;
    Test::More::plan(skip_all => 'these tests are for testing by the author');
  }
}

use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::NoTabs 0.09

use Test::More 0.88;
use Test::NoTabs;

my @files = (
    'lib/Dancer2/Session/PSGI.pm',
    't/00-compile.t',
    't/author-critic.t',
    't/author-no-tabs.t',
    't/lifecycle.t',
    't/release-check-changes.t',
    't/release-cpan-changes.t',
    't/release-distmeta.t',
    't/release-eol.t',
    't/release-meta-json.t',
    't/release-pod-coverage.t',
    't/release-pod-syntax.t',
    't/release-portability.t',
    't/release-synopsis.t',
    't/shared.t'
);

notabs_ok($_) foreach @files;
done_testing;
