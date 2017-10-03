use v6.c;

unit module DRMAA::Submission:ver<0.0.1>:auth<Vittore F Scolari (vittore.scolari@gmail.com)>;

use NativeCall :types;
use NativeHelpers::CBuffer;
use DRMAA::NativeCall;
use DRMAA::Session;
use DRMAA::Submission::Status;
use X::DRMAA;

class DRMAA::Submission {
    has Str  $.job-id;
    has $.result;

    submethod BUILD(:$job-id) {
	$!job-id = $job-id;

	DRMAA::Session.events.grep({ .id eq $!job-id }).tap: {
	    if Exception {
		.throw;
	    }

	    $!result := $_;
	};
    }

    method gist {
	"<DRMAA|$.job-id>"
    }
}
