use v6.c;
unit module DRMAA:ver<0.0.1>:auth<Vittore F Scolari (vittore.scolari@gmail.com)>;

# see Scheduler::DRMAA for the documentation

use DRMAA::NativeCall;
use NativeHelpers::CBuffer;

my constant DN = DRMAA::NativeCall;

enum drmaa_attributes (
    BLOCK_EMAIL                => "drmaa_block_email",
    DEADLINE_TIME              => "drmaa_deadline_time",
    DURATION_HLIMIT            => "drmaa_duration_hlimit",
    DURATION_SLIMIT            => "drmaa_duration_slimit",
    ERROR_PATH                 => "drmaa_error_path",
    INPUT_PATH                 => "drmaa_input_path",
    JOB_CATEGORY               => "drmaa_job_category",
    JOB_NAME                   => "drmaa_job_name",
    JOIN_FILES                 => "drmaa_join_files",
    JS_STATE                   => "drmaa_js_state",
    NATIVE_SPECIFICATION       => "drmaa_native_specification",
    OUTPUT_PATH                => "drmaa_output_path",
    REMOTE_COMMAND             => "drmaa_remote_command",
    START_TIME                 => "drmaa_start_time",
    TRANSFER_FILES             => "drmaa_transfer_files",
    V_ARGV                     => "drmaa_v_argv",
    V_EMAIL                    => "drmaa_v_email",
    V_ENV                      => "drmaa_v_env",
    WCT_HLIMIT                 => "drmaa_wct_hlimit",
    WCT_SLIMIT                 => "drmaa_wct_slimit",
    WD                         => "drmaa_wd"
);

constant TIMEOUT_NO_WAIT       =  0;
constant TIMEOUT_WAIT_FOREVER  = -1;
constant JOB_IDS_SESSION_ALL   = "DRMAA_JOB_IDS_SESSION_ALL";
constant JOB_IDS_SESSION_ANY   = "DRMAA_JOB_IDS_SESSION_ANY";

our sub init(Str $contact --> int32) {
  my $contact_buf = CBuffer.new(DRMAA_CONTACT_BUFFER, :init($contact));
  my $error_buf   = CBuffer.new(DRMAA_ERROR_STRING_BUFFER);

  my $ret = drmaa_init($contact_buf, $error_buf, DRMAA_ERROR_STRING_BUFFER);

  if ($ret != DRMAA_ERRNO_SUCCESS) {
#    drmaa_dispatch_error($ret, $error_buf);
  }

  $contact_buf.free;
  $error_buf.free;

  $ret
};
