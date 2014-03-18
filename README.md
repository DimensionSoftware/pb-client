pb-client
=========

node.js client library for PowerBulletin forums


```ls
require! PBClient: pb-client
mma = new PBClient(\https://mma.pb.com, \beppu@powerbulletin.com, \xxx)
mma.login console.log

mma.create-thread 2, \title, \body, console.log
```
