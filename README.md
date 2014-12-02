Narwhal
=======

Narwhal is a worker server designed to take advantage of features in \*nix kernels, inspired by Unicorn


TODO
----

* INT/TERM - quick shutdown, kills all workers immediately
* QUIT - graceful shutdown, waits for workers to finish their current request before finishing
* Should load app on startup
* Should use ActiveJob to load jobs
* Should use adapter to fetch and perform jobs
* Adapter: resque


License
-------

The MIT License (MIT)

Copyright (c) 2014 Brian Smith <brian.e.smith@gmail.com>
