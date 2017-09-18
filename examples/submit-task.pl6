use DRMAA;

my $remote-command = "./sleeper.sh";

DRMAA::Session.init; # Error handling is automatic

say "DRMAA library was started successfully";

given DRMAA::Job-template.new {
    .remote-command = $remote-command;
    .argv = <5>;

    # If you need more flexibility, just combine .run and a Seq
    my @submission = .run-bulk(1, 30, 2);

    say 'The following job tasks have been sumbitted: ', @submission.map: *.job-id;
}

DRMAA::Session.exit;
