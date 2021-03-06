use v6.d.PREVIEW;
use DRMAA;

DRMAA::Session.init;

say "DRMAA library was started successfully";

DRMAA::Session.events.tap: { .say };

my @submissions = DRMAA::Job-template.new(
                     :remote-command<./sleeper.sh>, :argv<20>
                  ).run-task(10);

my $submission = DRMAA::Job-template.new(
                     :remote-command<./sleeper.sh>, :argv<10>, :afterend(@submissions)
                  ).run;

say $submission;

await Promise.in(100);

DRMAA::Session.exit;
