pb-client
=========

node.js client library for PowerBulletin forums


```ls
require! PBClient: pb-client
mma = new PBClient('https://mma.pb.com', 'username@email.com', 'password')
mma.login console.log

mma.create-thread 2, 'title', 'body', console.log
```
