NAME
====

Scheduler::DRMAA - Bindings for the DRMAA cluster library

SYNOPSIS
========

    use DRMAA;             # Loads the high-level bindings
    use DRMAA::NativeCall; # Loads the C binings

DESCRIPTION
===========

Scheduler::DRMAA are the Perl 6 bindings for the DRMAA library. You can use them in order to submit pipelines of work to a supercomputer. We provide two different interfaces:

  * the DRMAA C library, it can be used through the `DRMAA::NativeCall` module and it is made to be as easy to use as the original one, through the use of `NativeHelpers::CBuffer` module. Documentation can be found online.

  * the object interface, provided by the `DRMAA` module. It supports all the C library functionalities but also an asynchronous event-based mechanism to keep track of job events and a pluggable job-dependency pipeline genearator.

First thing, in order to initialize and close the DRMAA session use the following commands:

    DRMAA::Session.init;

    # code goes here

    DRMAA::Session.exit;

OBJECTS
-------

AUTHOR
======

Vittore F. Scolari <vittore.scolari@pasteur.fr>

COPYRIGHT AND LICENSE
=====================

Copyright 2017 Institut Pasteur

This library is free software; you can redistribute it and/or modify it under the GPL License 3.0.
