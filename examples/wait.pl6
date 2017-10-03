use DRMAA;

my $remote-command = "./sleeper.sh";

DRMAA::Session.init; # Error handling is automatic

say "DRMAA library was started successfully";

my $submission = do given DRMAA::Job-template.new {
    .remote-command = $remote-command;
    .argv = <5>;

    .run;
}

say 'Your job has been submitted with id: ', $submission.job-id;

my $results = await $submission;
say $results;

CATCH {
    # Handle the broken promise (job aborted)
    say $_.^name;
}

DRMAA::Session.exit;
