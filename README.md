Narwhal
=======

Narwhal is a worker server designed to take advantage of features in \*nix kernels, inspired by Unicorn


TODO
----

* log from child to master using pipe
* use Kafka adapter to pull from any of queues in ActiveJob
* master should pull messages from queue using select
* master select should use self-pipe for signal processing
* master should hand-off messages to children using pipe and select in children
* child select should use self-pipe for signal processing

* INT/TERM - quick shutdown, kills all workers immediately
* Should load app on startup
* Should use ActiveJob to load jobs
* ActiveJob Adapter for Narwhal (Kafka)


Architecture
------------

Master Process
  * spawn workers (prefork)

  * Each tick:
    - did we receive a signal? handle
    - can we grab the next message? handle
    - if no on either of above, `select` on both


References
----------

* [Unicorn](http://unicorn.bogomips.org/)
* [Foreman](http://ddollar.github.io/foreman/)
* [ActiveJob](http://edgeguides.rubyonrails.org/active_job_basics.html)
* http://blog.rubybestpractices.com/posts/ewong/016-Implementing-Signal-Handlers.html
* http://cr.yp.to/docs/selfpipe.html

License
-------

The MIT License (MIT)

Copyright (c) 2014 Brian Smith <brian.e.smith@gmail.com>
