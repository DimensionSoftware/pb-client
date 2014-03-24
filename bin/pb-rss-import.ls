#!/usr/bin/env lsc

require! {
  PBClient: \pb-client
  RSSEmitter: \rss-emitter
  program: commander
  \prelude-ls
  url
}

global <<< prelude-ls

defaults =
  feed-db: './feed.db'

program
  .option '-s, --src [RSS_URL]', 'URL of RSS/Atom Feed to pull content from'
  .option '-d, --dst [PB_URL]', 'URL of PowerBulletin Site to post content to'
  .option '-e, --email [PB_LOGIN_EMAIL]', 'Login Email for PowerBulletin'
  .option '-p, --password [PB_PASSWORD]', 'Password for PowerBulletin'
  .option '-f, --feed-db [LEVEL_DB_PATH]', "Path to LevelDB file (default: '#{defaults.feed-db}')", id, defaults.feed-db
  .option '-w, --watch', 'Watch --src for changes'

program.parse process.argv

purl = url.parse program.dst
dst = new PBClient purl.href, program.email, program.password
err <- dst.login
if err then console.error err

src = new RSSEmitter program.feed-db

src.on \item:new, (guid, item) ->
  dst.create-post 

src.on \item:skipped, (guid) ->
  console.log \skipping, guid

src.import program.src

if program.watch
  <- set-interval _, 60000ms
  src.import program.src
