require! {
  request
}

module.exports = class PBClient
  (@hostname, @username, @password) ->
    @request = request.defaults jar: true, strict-SSL: false

  R: (path) ->
    "#{@hostname}#path"

  user: (cb) ->
    err, res, body <~ @request.get @R('/auth/user')
    if err then return cb err
    try
      u = JSON.parse body
      cb null, u
    catch
      cb e

  login: (cb) ->
    err, res, body <~ @request.post @R('/auth/login'), form: { @username, @password }
    if err then return cb err
    try
      r = JSON.parse body
      if r.success
        err, u <~ @user
        if err then return cb err
        @u = u
        cb null, u
    catch
      cb e

  logout: (cb) ->
    @request.get @R('/auth/logout'), cb

  create-thread: (forum_id, title, body, cb) ->
    # TODO - take a forum path instead and figure out forum_id for them
    err, res, body <~ @request.post @R('/resources/posts'), form: { forum_id, title, body }
    if err then return cb err
    try
      r = JSON.parse body
      cb null, r
    catch
      cb e

  post: (forum_id, parent_id, body, cb) ->
