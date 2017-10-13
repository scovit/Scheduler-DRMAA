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
them in order to submit pipelines of work to a supercomputer.  We provide
two different interfaces:

=item  the DRMAA C library,
       it can be used through the C<DRMAA::NativeCall> module and
       it is made to be as easy to use as the original one,
       through the use of C<NativeHelpers::CBuffer> module. Documentation
       can be found online.
=item  the object interface, provided by the C<DRMAA> module. It supports
       all the C library functionalities but also an asynchronous event-based
       mechanism to keep track of job events and a pluggable job-dependency
       pipeline genearator.
       
First thing, in order to initialize and close the DRMAA session
use the following commands:

  DRMAA::Session.init;

  # code goes here

  DRMAA::Session.exit;

=head2 OBJECTS

=head1 AUTHOR

Vittore F. Scolari <vittore.scolari@pasteur.fr>

=head1 COPYRIGHT AND LICENSE

Copyright 2017 Institut Pasteur

This library is free software; you can redistribute it and/or modify it under the GPL License 3.0.

=end pod
