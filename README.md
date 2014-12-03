Narwhal
=======

Narwhal is a worker server designed to take advantage of features in \*nix kernels, inspired by Unicorn


TODO
----

* INT/TERM - quick shutdown, kills all workers immediately
* QUIT - graceful shutdown, waits for workers to finish their current request before finishing
* -n should specify number of workers to start
* Should load app on startup
* Should use ActiveJob to load jobs
* Should use adapter to fetch and perform jobs
* Adapter: resque


References
----------

* Unicorn
* Foreman
* http://blog.rubybestpractices.com/posts/ewong/016-Implementing-Signal-Handlers.html
* http://cr.yp.to/docs/selfpipe.html

License
-------

The MIT License (MIT)

Copyright (c) 2014 Brian Smith <brian.e.smith@gmail.com>
