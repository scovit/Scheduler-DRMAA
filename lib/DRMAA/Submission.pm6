use v6.d.PREVIEW;

unit module DRMAA::Submission:ver<0.0.1>:auth<Vittore F Scolari (vittore.scolari@gmail.com)>;

use NativeCall :types;
use NativeHelpers::CBuffer;
use DRMAA::NativeCall;
use DRMAA::Session;
use DRMAA::Submission::Status;
use X::DRMAA;

class DRMAA::Submission does Awaitable {
    has Str  $.job-id;
    has Supply $.events;
    has Promise $!done;

    submethod BUILD(:$job-id) {
	$!job-id = $job-id;

	$!events = DRMAA::Session.events.grep: { .id eq $!job-id };
	$!done   = $!events.head(1).Promise; # If there would be more than one event x job,
	                                     # this would have been just slightly more complex
    }

    method result {
	$!done.result;
    }

    method get-await-handle(--> Awaitable::Handle) {
	$!done.get-await-handle;
    }

    method status() {
	my int32 $status = 0;
	my $jobid-buf = CBuffer.new($.job-id);
	my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
	LEAVE { $jobid-buf.free; $error-buf.free; };

	my $error-num = drmaa_job_ps($jobid-buf, $status,
				     $error-buf, DRMAA_ERROR_STRING_BUFFER);

	die X::DRMAA::from-code($error-num).new(:because($error-buf)) if ($error-num != DRMAA_ERRNO_SUCCESS);

	DRMAA::Submission::Status::from-code($status);
    }

    method gist {
	"<DRMAA|$.job-id>"
    }
}
