use v6.d.PREVIEW;
unit class Scheduler::DRMAA:ver<0.0.1>;


=begin pod

=head1 NAME

Scheduler::DRMAA - Bindings for the DRMAA cluster library

=head1 SYNOPSIS

  use DRMAA;             # Loads the high-level bindings
  use DRMAA::NativeCall; # Loads the C binings

=head1 DESCRIPTION

Scheduler::DRMAA are the Perl 6 bindings for the DRMAA library. You can use
them in order to submit pipelines of work to a supercomputer. We provide
two different interfaces:

=item  the DRMAA C library,
       it can be used through the C<DRMAA::NativeCall> module, it uses
       C<NativeCall> and C<NativeHelpers::CBuffer> modules
=item  the object interface, provided by the C<DRMAA> module. It requires
       C<v6.d.PREVIEW> and supports
       all the C library functionalities but also an asynchronous event-based
       mechanism to keep track of job events and a pluggable job-dependency
       pipeline genearator, reminescent of the C<Promise> API.

The library has been tested on a SLURM DRMAA implementation and does not provide
any warrant or guarantee to work. First thing, in order to
initialize and close the DRMAA session
use the following commands:

  DRMAA::Session.init;

  # code goes here

  DRMAA::Session.exit;

=head2 OBJECTS

=head3 DRMAA::Session

The DRMAA session is a singleton and represent the session level API.
Upon initialization it also takes care of the event loop. It provides the
following methods:

  method init(Str :$contact, DRMAA::Native-specification :native-specification(:$ns));

initializes the session, optional arguments are the contact code, and the Native-specification
plugin: if not provided explicitly it gets autodetected through a reasonable euristics.

  method exit()

closes the session.

  method native-specification(--> DRMAA::Native-specification)

returns the native-specification plugin.

  method events(--> Supply)

returns a Supply to the DRMAA events, mostly Job terminations events or failures

Other methods:

  method attribute-names(--> List)
  method vector-attribute-names(--> List)
  method contact(--> Str)
  method DRM-system(--> Str)
  method implementation(--> Str)
  method version(--> Version)

=head3 DRMAA::Job-template

Represents a Job template, must be constructed in order to launch one, or more jobs

  submethod BUILD(*%all)

Construct the object, use it as C<DRMAA::Job-template.new>, named parameters corresponds
to attributes and/or methods, making it straightforward to create a submission, a simple
example:

  my $template = DRMAA::Job-template.new(
     :remote-command<sleep> :argv<5>
  );

creates a job template for something which will just sleep 5 seconds; an alternative way to do it
uses heredocs:

  my $template = DRMAA::Job-template.new(:script(q:to/⬅ 完/));
     sleep 5;
     say "Slept 5 seconds";
     ⬅ 完

will run the Perl 6 script, the library will exploit the following dynamic variables:
C<$*EXECUTABLE>, C<@*ARGS> and C<%*ENV>. For instance, to submit a shell script do the following:

  my $*EXECUTABLE = "/bin/sh";
  my @*ARGS = <5>;
  my $template = DRMAA::Job-template.new(:script(q:to/⬅ 完/));
     sleep $1
     echo "Slept $1 seconds";
     ⬅ 完

Easy, isn't it?

To run a template, use one of the following methods:

  method run(--> DRMAA::Submission) 
  multi method run-bulk(Int:D $start, Int:D $end, Int :$by --> List)
  multi method run-bulk(Range:D $range, Int :$by --> List)
  multi method run-bulk(Int:D $size --> List)

C<run-bulk> methods are discouraged, seriously, just use C<@list.map: DRMAA::Job-template.new>...

To resume, the most important attributes, which are also building parameters, are:

  remote-command        (scalar)
  argv                  (list)
  env                   (list)

The following are other available attributes, which are also building parameters

  block-email           (scalar)
  email                 (list)
  start-time            (scalar)
  deadline-time         (scalar)
  duration-hlimit       (scalar)
  duration-slimit       (scalar)
  wct-hlimit            (scalar)
  wct-slimit            (scalar)
  error-path            (scalar)
  input-path            (scalar)
  output-path           (scalar)
  job-category          (scalar)
  job-name              (scalar)
  join-files            (scalar)
  transfer-files        (scalar)
  js-state              (scalar)
  native-specification  (scalar)
  wd                    (scalar)

The following extra attributes are available if the Native-plugin implement the
required functionality:

  after                 (list)
  afterend              (list)
  afterok               (list)
  afternotok            (list)

Queue after the start/end/success/failure of the values: which shoud be a list of C<DRMAA::Submission>.
To create a C<DRMAA::Submission> out of a job name, in case it doesn't come out of a C<run> method
just do like this: C<DRMAA::Submission.new(:job-id("123456"))>.

=head3 DRMAA::Submission

First of all: a submission is an Awaitable:

  my $submission = $template.run;
  my $result = await $submission;

It can be created either by the C<run> method of a C<DRMAA::Job-schedule> or from a job id:

  DRMAA::Submission.new(job-id => "123456");

It provides the following methods

  method suspend
  method resume
  method hold
  method release
  method terminate

  method status

Retuns the one of the following status objects:

  DRMAA::Submission::Status::Undetermined
  DRMAA::Submission::Status::Queued-active
  DRMAA::Submission::Status::System-on-hold
  DRMAA::Submission::Status::User-on-hold
  DRMAA::Submission::Status::User-system-on-hold
  DRMAA::Submission::Status::Running
  DRMAA::Submission::Status::System-suspended
  DRMAA::Submission::Status::User-suspended
  DRMAA::Submission::Status::User-system-suspended
  DRMAA::Submission::Status::Done
  DRMAA::Submission::Status::Failed
  DRMAA::Submission::Status::Unimplemented

  method events(--> Supply)

Returns a Supply with all events regarding the Submission

  method done(--> Promise)

Returns a Promise which will be kept when the job is over. The result of the promise
will contain one of the following:

  class X::DRMAA::Submission::Status::Aborted is Exception {
     has Str  $.id;
     has Bool $.exited;
     has Int  $.exit-code;
     has Str  $.signal;
     has Str  $.usage;

     method message(--> Str:D) {
         "Job $.id aborted";
     }
  }

  class DRMAA::Submission::Status::Succeded {
     has Str  $.id;
     has Bool $.exited;
     has Int  $.exit-code;
     has Str  $.signal;
     has Str  $.usage;
  }

The result can also be accessed through:

  method result

or

  await

Another handy method:

  method then(DRMAA::Job-template $what)

chain the jobs, same as specify the attribute C<afterend> to C<$what>, and then C<run>; an example:

  DRMAA::Job-template.new( :remote-command<sleep>, :argv<20> ).run.then(
     DRMAA::Job-template.new( :remote-command<echo>, :argv<Hello world!> ));

the functionality should be implemented in the Native plugin, currently only works for SLURM.

=head1 AUTHOR

Vittore F. Scolari <vittore.scolari@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2017 Institut Pasteur

This library is free software; you can redistribute it and/or modify it under the GPL License 3.0.

=end pod
