use v6.d.PREVIEW;
use DRMAA;

DRMAA::Session.init;

say "DRMAA library was started successfully";

my @submission = DRMAA::Job-template.new(
                    :remote-command<./sleeper.sh>, :argv<5>
                 ).run-bulk(1, 30, :by(2));

say 'The following job tasks have been sumbitted: ', @submission.map: *.job-id;

say 'Waiting for job to finish';

my atomicint $i;
DRMAA::Session.events.tap: { $i⚛++; say $i, "/15 finished"; };

my @results;
{
    @results = await @submission;

    CATCH {
      when X::DRMAA::Submission::Status::Aborted {
	say 'Job ',          .id, ' aborted!';
	say '  exited:    ', .exited;
	say '  exit-code: ', .exit-code;
	say '  signal:    ', .signal;
	say 'Usage statistics:';
	say                  .usage;
      }
      default {
        .throw;
      }
    }
}

for @results {
    say 'Job ',          .id, ' ended correctly!';
    say '  exited:    ', .exited;
    say '  exit-code: ', .exit-code;
    say '  signal:    ', .signal;
    say 'Usage statistics:';
    say                  .usage;
}


DRMAA::Session.exit;
