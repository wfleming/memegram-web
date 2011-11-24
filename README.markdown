Memegram
========

## Requirements:

The usual. RVM. etc.

Use pow for local dev - it'll make your life easier. Map it to http://memegram.dev.

## HEY, LISTEN.

There are two major downsides to pow right now, at least on the current release (0.3.2)

1. Pow has issues with file uploads. Big issues. As in it'll just start crashing sometimes, and when it does you generally need to just
keep killing/restarting the process until it decides to work again for a while. As of writing, this will supposedly be fixed in the next release
Until then, checkout the `rewrite-pause-stream` branch from git://github.com/mitio/pow.git, and use that.
Go to https://github.com/37signals/pow/issues/125#issuecomment-2542944 to see more context & instructions.

2. Pow's DNS resolution does not extend past localhost, which makes testing the client on an actual device very tough.
There's a fork at https://github.com/sj26/pow: it gives mdns recognition making local iOS testing much easier
(you can then set your iOS build to look for http://memegram.dev.MYMACHINENAME.local). I ran into issues running this
fork, but maybe you'll have better luck. ALSO, so far it's seemed better to me to fix problem 1 above and do device testing
against the prod web server.


We're using Heroku for production as an experiment. Have fun.