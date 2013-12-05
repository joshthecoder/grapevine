Grapevine
=========
Search and track popular tweets people are retweeting!

How it works
------------
When an user types in a new query and hits search a new
"feed" record is created which describes the "keywords" to
search for on Twitter. The client then starts polling the server
for new results and re-renders the list.

In the background there's a process which connects to the Twitter
streaming API, queries all active feeds to produce the list of keywords
to track, and start consuming incoming statuses. When a status arrives
the feeder stores them into MongoDB. The feeder also runs a timer to
recheck the feeds and re-connect if new "keywords" are added to the
database.

Whenever a client polls for new feed results the Rails app queries
MongoDB for the top 10 retweets that match the keywords for that query.

Limitations / Improvements
--------------------------
There is a slight delay after entering a new query before results
appear. This is due to the delay of the background worker reconnecting.
We can't really reduce this delay in the background w/o getting banned
by Twitter for reconnecting too often. One solution would be to prefetch
results via the REST API (ex: search).

Reduce client polling overhead by integrating WebSockets for pushing new
results. A thirdparty service could be used or extend the rails app to
support it.

Launching Feeder
----------------
The feeder is the background process that consumes the
Twitter streaming API and produces new results.

To start it just execute the rake task "feed_streamer:start".

