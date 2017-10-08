use v6.d.PREVIEW;
unit module DRMAA::Job-template:ver<0.0.1>:auth<Vittore F Scolari (vittore.scolari@gmail.com)>;

use NativeCall :types;
use NativeHelpers::CBuffer;
use DRMAA::NativeCall;
use X::DRMAA;
use DRMAA::Submission;
use DRMAA::Session;
use DRMAA::Native-specification;


class DRMAA::Job-template {
    has drmaa_job_template_t $.jt;

    method attribute(Str:D $name) is rw {
	my $jt = $!jt;
	my $cached;
        Proxy.new(
            FETCH => method (--> Str) {
		unless defined $cached {
		    my $attri-buf = CBuffer.new($name);
		    my $value-buf = CBuffer.new(DRMAA_ATTR_BUFFER);
		    my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
		    LEAVE { $attri-buf.free; $value-buf.free; $error-buf.free; };

		    my $error-num = drmaa_get_attribute($jt, $attri-buf, $value-buf, DRMAA_ATTR_BUFFER, $error-buf, DRMAA_ERROR_STRING_BUFFER);
		    die X::DRMAA::from-code($error-num).new(:because($error-buf)) if ($error-num != DRMAA_ERRNO_SUCCESS);

		    $cached = $value-buf.Str;
		}
		$cached;
	    },
            STORE => method (Str $value) {
		my $attri-buf = CBuffer.new($name);
		my $value-buf = CBuffer.new($value);
		my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
		LEAVE { $attri-buf.free; $value-buf.free; $error-buf.free; };

                my $error-num = drmaa_set_attribute($jt, $attri-buf, $value-buf, $error-buf, DRMAA_ERROR_STRING_BUFFER);
                die X::DRMAA::from-code($error-num).new(:because($error-buf)) if ($error-num != DRMAA_ERRNO_SUCCESS);

		$cached = Any; # Invalidate cache
		$value
	    }
        )
    }

    method vector-attribute(Str:D $name) is rw {
	my $jt = $!jt;
	my $cached;
        Proxy.new(
            FETCH => method (--> List) {
		unless defined $cached {
		    my $attri-buf = CBuffer.new($name);
		    my $values = Pointer[drmaa_attr_values_t].new;
		    my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
		    LEAVE { $attri-buf.free; drmaa_release_attr_values($values.deref);
		     	    $error-buf.free; };

		    my $error-num = drmaa_get_vector_attribute($jt, $attri-buf, $values, $error-buf, DRMAA_ERROR_STRING_BUFFER);
		    die X::DRMAA::from-code($error-num).new(:because($error-buf)) if ($error-num != DRMAA_ERRNO_SUCCESS);

		    $cached = (Seq.new($values.deref).map: { LEAVE { .free }; .Str; }).list.eager;
		}
		$cached;
	    },
            STORE => method ($value) {
		my $attri-buf = CBuffer.new($name);
		my $value-arr = CArray[CBuffer].new(|($value.map: { CBuffer.new($_.Str) }), CBuffer);
		my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
		LEAVE { $attri-buf.free; .free for $value-arr.Seq; $error-buf.free; };

                my $error-num = drmaa_set_vector_attribute($jt, $attri-buf, $value-arr, $error-buf, DRMAA_ERROR_STRING_BUFFER);
                die X::DRMAA::from-code($error-num).new(:because($error-buf)) if ($error-num != DRMAA_ERRNO_SUCCESS);

		$cached = Any; # Invalidate cache
		$value
	    }
        )
    };

    method block-email()          is rw { given (DRMAA_BLOCK_EMAIL) { LEAVE { .free }; self.attribute($_.Str) } }
    method deadline-time()        is rw { given (DRMAA_DEADLINE_TIME) { LEAVE { .free }; self.attribute($_.Str) } }
    method duration-hlimit()      is rw { given (DRMAA_DURATION_HLIMIT) { LEAVE { .free }; self.attribute($_.Str) } }
    method duration-slimit()      is rw { given (DRMAA_DURATION_SLIMIT) { LEAVE { .free }; self.attribute($_.Str) } }
    method error-path()           is rw { given (DRMAA_ERROR_PATH) { LEAVE { .free }; self.attribute($_.Str) } }
    method input-path()           is rw { given (DRMAA_INPUT_PATH) { LEAVE { .free }; self.attribute($_.Str) } }
    method job-category()         is rw { given (DRMAA_JOB_CATEGORY) { LEAVE { .free }; self.attribute($_.Str) } }
    method job-name()             is rw { given (DRMAA_JOB_NAME) { LEAVE { .free }; self.attribute($_.Str) } }
    method join-files()           is rw { given (DRMAA_JOIN_FILES) { LEAVE { .free }; self.attribute($_.Str) } }
    method js-state()             is rw { given (DRMAA_JS_STATE) { LEAVE { .free }; self.attribute($_.Str) } }
    method native-specification() is rw { given (DRMAA_NATIVE_SPECIFICATION) { LEAVE { .free }; self.attribute($_.Str) } }
    method output-path()          is rw { given (DRMAA_OUTPUT_PATH) { LEAVE { .free }; self.attribute($_.Str) } }
    method remote-command()       is rw { given (DRMAA_REMOTE_COMMAND) { LEAVE { .free }; self.attribute($_.Str) } }
    method start-time()           is rw { given (DRMAA_START_TIME) { LEAVE { .free }; self.attribute($_.Str) } }
    method transfer-files()       is rw { given (DRMAA_TRANSFER_FILES) { LEAVE { .free }; self.attribute($_.Str) } }
    method argv()                 is rw { given (DRMAA_V_ARGV) { LEAVE { .free }; self.vector-attribute($_.Str) } }
    method email()                is rw { given (DRMAA_V_EMAIL) { LEAVE { .free }; self.vector-attribute($_.Str) } }
    method env()                  is rw { given (DRMAA_V_ENV) { LEAVE { .free }; self.vector-attribute($_.Str) } }
    method wct-hlimit()           is rw { given (DRMAA_WCT_HLIMIT) { LEAVE { .free }; self.attribute($_.Str) } }
    method wct-slimit()           is rw { given (DRMAA_WCT_SLIMIT) { LEAVE { .free }; self.attribute($_.Str) } }
    method wd()                   is rw { given (DRMAA_WD) { LEAVE { .free }; self.attribute($_.Str) } }

    method after is rw {
	die X::NYI.new(:feature('Dependencies in ' ~ DRMAA::Session.native-specification.^name))
	unless Dependencies ∈ DRMAA::Session.native-specification.provides;

	my $job-template = self;
	Proxy.new(
	    FETCH => method {
		die "after is writeonly"
	    },
	    STORE => method ($after) {
		for @$after -> $job { die X::TypeCheck.new(:got($job), :expected(DRMAA::Submission), :operation("binding"))
				      unless $job ~~ DRMAA::Submission };
		DRMAA::Session.native-specification.job-template-after($job-template, $after);
	    }
	)
    }
    method afterend is rw {
        die X::NYI.new(:feature('Dependencies in ' ~ DRMAA::Session.native-specification.^name))
	unless Dependencies ∈ DRMAA::Session.native-specification.provides;

	my $job-template = self;
	Proxy.new(
	    FETCH => method {
		die "afterany is writeonly"
	    },
	    STORE => method ($after) {
		for @$after -> $job { die X::TypeCheck.new(:got($job), :expected(DRMAA::Submission), :operation("binding"))
				      unless $job ~~ DRMAA::Submission };
		DRMAA::Session.native-specification.job-template-afterany($job-template, $after);
	    }
	)
    }
    method afternotok is rw {
        die X::NYI.new(:feature('Dependencies in ' ~ DRMAA::Session.native-specification.^name))
	unless Dependencies ∈ DRMAA::Session.native-specification.provides;

	my $job-template = self;
	Proxy.new(
	    FETCH => method {
		die "afternotok is writeonly"
	    },
	    STORE => method ($after) {
		for @$after -> $job { die X::TypeCheck.new(:got($job), :expected(DRMAA::Submission), :operation("binding"))
				      unless $job ~~ DRMAA::Submission };
		DRMAA::Session.native-specification.job-template-aftenotok($job-template, $after);
	    }
	)
    }
    method afterok is rw {
        die X::NYI.new(:feature('Dependencies in ' ~ DRMAA::Session.native-specification.^name))
	unless Dependencies ∈ DRMAA::Session.native-specification.provides;
	
	my $job-template = self;
	Proxy.new(
	    FETCH => method {
		die "afterok is writeonly"
	    },
	    STORE => method ($after) {
		for @$after -> $job { die X::TypeCheck.new(:got($job), :expected(DRMAA::Submission), :operation("binding"))
				      unless $job ~~ DRMAA::Submission };
		DRMAA::Session.native-specification.job-template-afterok($job-template, $after);
	    }
	)
    }    
    
    submethod BUILD(*%all) {
	if defined(%all<jt>) {
	    $!jt = %all<jt>;
	} else {
	    my $temp = Pointer[drmaa_job_template_t].new;
	    $!jt = drmaa_job_template_t.new;

	    my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
	    LEAVE { $error-buf.free; }

	    my $error-num = drmaa_allocate_job_template($temp, $error-buf, DRMAA_ERROR_STRING_BUFFER);

	    die X::DRMAA::from-code($error-num).new(:because($error-buf)) if ($error-num != DRMAA_ERRNO_SUCCESS);

	    $!jt = $temp.deref;
	}

	for %all.kv -> $name, $value {
	    next if $name eq "jt";
	    self."$name"() = $value;
	}

	True;
    }

    submethod DESTROY {
	my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
	LEAVE { $error-buf.free; }

	my $error-num = drmaa_delete_job_template($!jt, $error-buf, DRMAA_ERROR_STRING_BUFFER);

	die X::DRMAA::from-code($error-num).new(:because($error-buf)) if ($error-num != DRMAA_ERRNO_SUCCESS);
	True
    }

    method run(--> DRMAA::Submission) {
	my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
	my $jobid-buf = CBuffer.new(DRMAA_JOBNAME_BUFFER);
	LEAVE { $error-buf.free; $jobid-buf.free; }

	my $error-num = drmaa_run_job($jobid-buf, DRMAA_JOBNAME_BUFFER, $.jt,
				      $error-buf, DRMAA_ERROR_STRING_BUFFER);

	die X::DRMAA::from-code($error-num).new(:because($error-buf)) if ($error-num != DRMAA_ERRNO_SUCCESS);

	DRMAA::Submission.new(job-id => $jobid-buf.Str)
    };

    multi method run-bulk(Int:D $start, Int:D $end, Int :$by --> List) {
	my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
	my $jobid-ptr = Pointer[drmaa_job_ids_t].new;
	LEAVE { $error-buf.free; drmaa_release_job_ids($jobid-ptr.deref) }

	my $error-num = drmaa_run_bulk_jobs($jobid-ptr, $.jt, $start, $end, defined($by) ?? $by !! 1,
					    $error-buf, DRMAA_ERROR_STRING_BUFFER);

	die X::DRMAA::from-code($error-num).new(:because($error-buf)) if ($error-num != DRMAA_ERRNO_SUCCESS);

	(Seq.new($jobid-ptr.deref).map: { LEAVE { .free }; DRMAA::Submission.new(job-id => .Str) }).list.eager
    };

    multi method run-bulk(Range:D $range, Int :$by --> List) {
	die "Not going to submit an infinite number of jobs" if $range.inifinte;
	my ($start, $end) = $range.minmax;
        self.run-bulk($start, $end, :$by);
    }

    multi method run-bulk(Int:D $size --> List) {
	self.run-bulk(1, $size, 1);
    }
}
