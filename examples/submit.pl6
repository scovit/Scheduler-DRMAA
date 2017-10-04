use DRMAA;

DRMAA::Session.init; # Error handling is automatic

say "DRMAA library was started successfully";

my $submission = DRMAA::Job-template.new(
                    :remote-command<./sleeper.sh>, :argv<5>
                 ).run;

say 'Your job has been submitted with id: ', $submission.job-id;

DRMAA::Session.exit;
