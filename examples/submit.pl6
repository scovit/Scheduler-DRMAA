use DRMAA;

my $remote-command = "./sleeper.sh";

DRMAA::Session.init; # Error handling is automatic

say "DRMAA library was started successfully";

given DRMAA::Job-template.new {
    .remote-command = $remote-command;
    .argv = <5>;

    my $submission = .run;
    say 'Your job has been submitted with id: ', $submission.job-id;
}


DRMAA::Session.exit;
