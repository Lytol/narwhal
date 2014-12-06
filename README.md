Narwhal
=======

Narwhal is a Ruby prefork worker designed to be broker agnostic and take advantage of features in \*nix kernels


Architecture
------------

- Require ActiveJob
- Require Ruby 2.x (copy-on-write)
- Require \*nix (select and signals)
- Don't support daemonize or logfile, use deamontools, upstart, systemd, etc!

Adapters
  * Redis
  * Kafka
  * RabbitMQ
  * Beanstalkd


Master
  * state: `wait_client` is all clients are busy but messages are ready
    - `select(clients, sigqueue)` to efficiently wait for next client to be ready (or signal handler)
  * state: `wait_message` is no messages are ready but clients are ready
    - `select(mq, sigqueue)` to efficiently wait for next message to be ready (or signal handler)
  * state: `running` is clients are ready and messages are ready
    - fetch message, pass to next client

Worker
  * state: `ready` is waiting for next message
      - `select(message, sigqueue)`
  * state: `processing` is handling a job


Notes
-----

* Master init:
  - spawn workers (prefork)
  - all workers should start in ready state

* Master tick:
  - did we receive a signal? handle
  - no clients available? select(clients, sigqueue)
  - clients available but no messages? select(mq, sigqueue)
  - clients available and messages? fetch next message and send to available client

* Worker tick:
  - select(message, sigqueue)

* ActiveJob adapter for Narwhal
* MQ adapter to Redis
* MQ adapter for Kafka
* INT/TERM - quick shutdown, kills all workers immediately
* Should load app on startup
* Should use ActiveJob to load jobs
* REFACTOR: `_after_fork` and `_before_fork` for both master and worker internally
* Add rails generator for configuring Narwhal


References
----------

* [Unicorn](http://unicorn.bogomips.org/)
* [Foreman](http://ddollar.github.io/foreman/)
* [ActiveJob](http://edgeguides.rubyonrails.org/active_job_basics.html)
* [Advanced Programming in the Unix Environment](http://www.amazon.com/Advanced-Programming-UNIX-Environment-Edition/dp/0321637739)
* http://blog.rubybestpractices.com/posts/ewong/016-Implementing-Signal-Handlers.html
* http://cr.yp.to/docs/selfpipe.html
* http://unicorn.bogomips.org/DESIGN.html
* http://thorstenball.com/blog/2014/11/20/unicorn-unix-magic-tricks/
* http://tomayko.com/writings/unicorn-is-unix


License
-------

The MIT License (MIT)

Copyright (c) 2014 Brian Smith <brian.e.smith@gmail.com>
