use v6.c;
unit module DRMAA::Job-template:ver<0.0.1>:auth<Vittore F Scolari (vittore.scolari@gmail.com)>;

use NativeCall :types;
use NativeHelpers::CBuffer;
use DRMAA::NativeCall;
use X::DRMAA;
use DRMAA::Submission;


class DRMAA::Job-template {
    has $.jt;

    method attribute(Str $name) is rw {
	my $jt = self.jt.deref;
	my $cached;
        Proxy.new(
            FETCH => method (--> Str) {
		unless defined $cached {
		    my $attri-buf = CBuffer.new($name);
		    my $value-buf = CBuffer.new(DRMAA_ATTR_BUFFER);
		    my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
		    LEAVE { $attri-buf.free; $value-buf.free; $error-buf.free; };

		    my $error-num = drmaa_get_attribute($jt, $attri-buf, $value-buf, DRMAA_ATTR_BUFFER, $error-buf, DRMAA_ERROR_STRING_BUFFER);
		    X::DRMAA::from-code($error-num).new(:because($error-buf)).throw if ($error-num != DRMAA_ERRNO_SUCCESS);

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
                X::DRMAA::from-code($error-num).new(:because($error-buf)).throw if ($error-num != DRMAA_ERRNO_SUCCESS);

		$cached = Any; # Invalidate cache
		$value
	    }
        )
    }

    method vector-attribute(Str $name) is rw {
	my $jt = self.jt.deref;
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
		    X::DRMAA::from-code($error-num).new(:because($error-buf)).throw if ($error-num != DRMAA_ERRNO_SUCCESS);

		    $cached = (Seq.new($values.deref).map: { LEAVE { .free }; .Str; }).list.eager;
		}
		$cached;
	    },
            STORE => method (List $value) {
		my $attri-buf = CBuffer.new($name);
		my $value-arr = CArray[CBuffer].new(|($value.map: { CBuffer.new($_) }), CBuffer);
		my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
		LEAVE { $attri-buf.free; .free for $value-arr.Seq; $error-buf.free; };

                my $error-num = drmaa_set_vector_attribute($jt, $attri-buf, $value-arr, $error-buf, DRMAA_ERROR_STRING_BUFFER);
                X::DRMAA::from-code($error-num).new(:because($error-buf)).throw if ($error-num != DRMAA_ERRNO_SUCCESS);

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
    method v-argv()               is rw { given (DRMAA_V_ARGV) { LEAVE { .free }; self.vector-attribute($_.Str) } }
    method v-email()              is rw { given (DRMAA_V_EMAIL) { LEAVE { .free }; self.vector-attribute($_.Str) } }
    method v-env()                is rw { given (DRMAA_V_ENV) { LEAVE { .free }; self.vector-attribute($_.Str) } }
    method wct-hlimit()           is rw { given (DRMAA_WCT_HLIMIT) { LEAVE { .free }; self.attribute($_.Str) } }
    method wct-slimit()           is rw { given (DRMAA_WCT_SLIMIT) { LEAVE { .free }; self.attribute($_.Str) } }
    method wd()                   is rw { given (DRMAA_WD) { LEAVE { .free }; self.attribute($_.Str) } }

    submethod BUILD(:jt(:$given)) {
	if defined($given) {
	    $!jt = $given;
	} else {
	    $!jt = Pointer[drmaa_job_template_t].new;
	    my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
	    LEAVE { $error-buf.free; }

	    my $error-num = drmaa_allocate_job_template($!jt, $error-buf, DRMAA_ERROR_STRING_BUFFER);

	    X::DRMAA::from-code($error-num).new(:because($error-buf)).throw if ($error-num != DRMAA_ERRNO_SUCCESS);
	    True
	}
    }

    submethod DESTROY {
	my $error-buf = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);
	LEAVE { $error-buf.free; }

	my $error-num = drmaa_delete_job_template($!jt.deref, $error-buf, DRMAA_ERROR_STRING_BUFFER);

	X::DRMAA::from-code($error-num).new(:because($error-buf)).throw if ($error-num != DRMAA_ERRNO_SUCCESS);
	True
    }

    method run(--> DRMAA::Submission) { };
}