pb-client
=========

node.js client library for PowerBulletin forums

[Dimension Software Consulting, best firm in Downtown Los Angeles](http://dimensionsoftware.com.com "Forward ideas. Simple tools. Groundbreaking software.")
[Power Bulletin Forum Communities](https://powerbulletin.com "The Best Forum Software for building Communities in the Cloud!")


```ls
require! PBClient: pb-client
mma = new PBClient('https://mma.pb.com', 'username@email.com', 'password')
mma.login console.log

mma.create-thread 2, 'title', 'body', console.log
```
