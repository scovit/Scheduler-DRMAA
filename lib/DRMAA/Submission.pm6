use v6.c;
unit module DRMAA::Submission:ver<0.0.1>:auth<Vittore F Scolari (vittore.scolari@gmail.com)>;

use NativeCall :types;
use NativeHelpers::CBuffer;
use DRMAA::NativeCall;
use X::DRMAA;

class DRMAA::Submission is Promise {
    has Str $.job-id;

    submethod BUILD(:$job-id) {
	$!job-id = $job-id;
    }

    method gist {
	"<DRMAA|$.job-id>"
    }
}
