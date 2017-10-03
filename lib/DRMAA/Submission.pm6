use v6.c;

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

    method gist {
	"<DRMAA|$.job-id>"
    }
}
