#!/usr/bin/env lsc

require! {
  PBClient: \../index
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
  .option '-d, --dst [PB_URL]', 'Thread or Forum URL of PowerBulletin Site to post content to'
  .option '-e, --email [PB_LOGIN_EMAIL]', 'Login Email for PowerBulletin'
  .option '-p, --password [PB_PASSWORD]', 'Password for PowerBulletin'
  .option '-f, --feed-db [LEVEL_DB_PATH]', "Path to LevelDB file (default: '#{defaults.feed-db}')", id, defaults.feed-db
  .option '-w, --watch', 'Watch --src for changes'

program.parse process.argv

have-required-params = all id, [program.src, program.dst, program.email, program.password]

unless have-required-params
  console.warn """
  Error:  --src, --dst, --email, and --password must be provided
  """
  console.warn program.output-help!
  process.exit 1

purl = url.parse program.dst
site = "#{purl.protocol}//#{purl.hostname}"
dst = new PBClient site, program.email, program.password
err <- dst.login
if err
  console.error "login failed"
  console.error err
  process.exit 1

src = new RSSEmitter program.feed-db

src.on \item:new, (guid, item) ->
  body = if item.categories
    item.description + "\n\n #{item.categories |> map (-> '#' + it) |> join ' '}"
  else
    item.description
  # if dst is a thread url, add item to thread
  # if dst is a forum url, create a new thread for each item
  err <- dst.create-post purl.pathname, item.title, body
  console.log item
  console.log "----------------------------------------------------------------------------------------"

src.on \item:skipped, (guid) ->
  console.log \skipping, guid

src.import program.src

if program.watch
  <- set-interval _, 60000ms
  src.import program.src
