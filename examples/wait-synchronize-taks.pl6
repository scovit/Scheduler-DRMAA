use v6.d.PREVIEW;
use DRMAA;

DRMAA::Session.init;

say "DRMAA library was started successfully";

DRMAA::Session.events.tap: {
    when DRMAA::Submission::Status::Succeded {
        say 'Job ',          .id, ' ended correctly!';
        say '  exited:    ', .exited;
        say '  exit-code: ', .exit-code;
        say '  signal:    ', .signal;
        say 'Usage statistics:';
        say                  .usage;
    }
    default { # X::DRMAA::Submission::Status::Aborted is an exception
        say 'Job ',          $!.id, ' aborted!';
        say '  exited:    ', $!.exited;
	say '  exit-code: ', $!.exit-code;
	say '  signal:    ', $!.signal;
	say 'Usage statistics:';
	say                  $!.usage;
    }
}

my @submission = DRMAA::Job-template.new(
                    :remote-command<./sleeper.sh>, :argv<5>
                 ).run-bulk(1, 30, :by(2));

say 'The following job tasks have been sumbitted: ', @submission.map: *.job-id;

try await @submission;

DRMAA::Session.exit;
