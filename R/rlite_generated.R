## Automatically generated: do not edit by hand
rlite_generator <- R6::R6Class(
  "rlite",
  public=list(
    context=NULL,
    append=function(key, value) {
      assert_scalar(key)
      assert_scalar(value)
      self$context$run(c("APPEND", key, value))
    },
    bitcount=function(key, start=NULL, end=NULL) {
      assert_scalar(key)
      assert_scalar_or_null(start)
      assert_scalar_or_null(end)
      self$context$run(c("BITCOUNT", key, start, end))
    },
    bitop=function(operation, destkey, key) {
      assert_scalar(operation)
      assert_scalar(destkey)
      self$context$run(c("BITOP", operation, destkey, key))
    },
    bitpos=function(key, bit, start=NULL, end=NULL) {
      assert_scalar(key)
      assert_scalar(bit)
      assert_scalar_or_null(start)
      assert_scalar_or_null(end)
      self$context$run(c("BITPOS", key, bit, start, end))
    },
    dbsize=function() {
      self$context$run(c("DBSIZE"))
    },
    decr=function(key) {
      assert_scalar(key)
      self$context$run(c("DECR", key))
    },
    decrby=function(key, decrement) {
      assert_scalar(key)
      assert_scalar(decrement)
      self$context$run(c("DECRBY", key, decrement))
    },
    del=function(key) {
      self$context$run(c("DEL", key))
    },
    discard=function() {
      self$context$run(c("DISCARD"))
    },
    dump=function(key) {
      assert_scalar(key)
      self$context$run(c("DUMP", key))
    },
    echo=function(message) {
      assert_scalar(message)
      self$context$run(c("ECHO", message))
    },
    eval=function(script, numkeys, key, arg) {
      assert_scalar(script)
      assert_scalar(numkeys)
      self$context$run(c("EVAL", script, numkeys, key, arg))
    },
    evalsha=function(sha1, numkeys, key, arg) {
      assert_scalar(sha1)
      assert_scalar(numkeys)
      self$context$run(c("EVALSHA", sha1, numkeys, key, arg))
    },
    exec=function() {
      self$context$run(c("EXEC"))
    },
    exists=function(key) {
      assert_scalar(key)
      self$context$run(c("EXISTS", key))
    },
    expire=function(key, seconds) {
      assert_scalar(key)
      assert_scalar(seconds)
      self$context$run(c("EXPIRE", key, seconds))
    },
    expireat=function(key, timestamp) {
      assert_scalar(key)
      assert_scalar(timestamp)
      self$context$run(c("EXPIREAT", key, timestamp))
    },
    flushall=function() {
      self$context$run(c("FLUSHALL"))
    },
    flushdb=function() {
      self$context$run(c("FLUSHDB"))
    },
    get=function(key) {
      assert_scalar(key)
      self$context$run(c("GET", key))
    },
    getbit=function(key, offset) {
      assert_scalar(key)
      assert_scalar(offset)
      self$context$run(c("GETBIT", key, offset))
    },
    getrange=function(key, start, end) {
      assert_scalar(key)
      assert_scalar(start)
      assert_scalar(end)
      self$context$run(c("GETRANGE", key, start, end))
    },
    getset=function(key, value) {
      assert_scalar(key)
      assert_scalar(value)
      self$context$run(c("GETSET", key, value))
    },
    hdel=function(key, field) {
      assert_scalar(key)
      self$context$run(c("HDEL", key, field))
    },
    hexists=function(key, field) {
      assert_scalar(key)
      assert_scalar(field)
      self$context$run(c("HEXISTS", key, field))
    },
    hget=function(key, field) {
      assert_scalar(key)
      assert_scalar(field)
      self$context$run(c("HGET", key, field))
    },
    hgetall=function(key) {
      assert_scalar(key)
      self$context$run(c("HGETALL", key))
    },
    hincrby=function(key, field, increment) {
      assert_scalar(key)
      assert_scalar(field)
      assert_scalar(increment)
      self$context$run(c("HINCRBY", key, field, increment))
    },
    hincrbyfloat=function(key, field, increment) {
      assert_scalar(key)
      assert_scalar(field)
      assert_scalar(increment)
      self$context$run(c("HINCRBYFLOAT", key, field, increment))
    },
    hkeys=function(key) {
      assert_scalar(key)
      self$context$run(c("HKEYS", key))
    },
    hlen=function(key) {
      assert_scalar(key)
      self$context$run(c("HLEN", key))
    },
    hmget=function(key, field) {
      assert_scalar(key)
      self$context$run(c("HMGET", key, field))
    },
    hmset=function(key, field, value) {
      assert_scalar(key)
      field <- interleave(field, value)
      self$context$run(c("HMSET", key, field))
    },
    hset=function(key, field, value) {
      assert_scalar(key)
      assert_scalar(field)
      assert_scalar(value)
      self$context$run(c("HSET", key, field, value))
    },
    hsetnx=function(key, field, value) {
      assert_scalar(key)
      assert_scalar(field)
      assert_scalar(value)
      self$context$run(c("HSETNX", key, field, value))
    },
    hvals=function(key) {
      assert_scalar(key)
      self$context$run(c("HVALS", key))
    },
    incr=function(key) {
      assert_scalar(key)
      self$context$run(c("INCR", key))
    },
    incrby=function(key, increment) {
      assert_scalar(key)
      assert_scalar(increment)
      self$context$run(c("INCRBY", key, increment))
    },
    incrbyfloat=function(key, increment) {
      assert_scalar(key)
      assert_scalar(increment)
      self$context$run(c("INCRBYFLOAT", key, increment))
    },
    keys=function(pattern) {
      assert_scalar(pattern)
      self$context$run(c("KEYS", pattern))
    },
    lindex=function(key, index) {
      assert_scalar(key)
      assert_scalar(index)
      self$context$run(c("LINDEX", key, index))
    },
    linsert=function(key, where, pivot, value) {
      assert_scalar(key)
      assert_scalar(where)
      assert_scalar(pivot)
      assert_scalar(value)
      self$context$run(c("LINSERT", key, where, pivot, value))
    },
    llen=function(key) {
      assert_scalar(key)
      self$context$run(c("LLEN", key))
    },
    lpop=function(key) {
      assert_scalar(key)
      self$context$run(c("LPOP", key))
    },
    lpush=function(key, value) {
      assert_scalar(key)
      self$context$run(c("LPUSH", key, value))
    },
    lpushx=function(key, value) {
      assert_scalar(key)
      assert_scalar(value)
      self$context$run(c("LPUSHX", key, value))
    },
    lrange=function(key, start, stop) {
      assert_scalar(key)
      assert_scalar(start)
      assert_scalar(stop)
      self$context$run(c("LRANGE", key, start, stop))
    },
    lrem=function(key, count, value) {
      assert_scalar(key)
      assert_scalar(count)
      assert_scalar(value)
      self$context$run(c("LREM", key, count, value))
    },
    lset=function(key, index, value) {
      assert_scalar(key)
      assert_scalar(index)
      assert_scalar(value)
      self$context$run(c("LSET", key, index, value))
    },
    ltrim=function(key, start, stop) {
      assert_scalar(key)
      assert_scalar(start)
      assert_scalar(stop)
      self$context$run(c("LTRIM", key, start, stop))
    },
    mget=function(key) {
      self$context$run(c("MGET", key))
    },
    move=function(key, db) {
      assert_scalar(key)
      assert_scalar(db)
      self$context$run(c("MOVE", key, db))
    },
    mset=function(key, value) {
      key <- interleave(key, value)
      self$context$run(c("MSET", key))
    },
    msetnx=function(key, value) {
      key <- interleave(key, value)
      self$context$run(c("MSETNX", key))
    },
    multi=function() {
      self$context$run(c("MULTI"))
    },
    object=function(subcommand, arguments=NULL) {
      assert_scalar(subcommand)
      self$context$run(c("OBJECT", subcommand, arguments))
    },
    persist=function(key) {
      assert_scalar(key)
      self$context$run(c("PERSIST", key))
    },
    pexpire=function(key, milliseconds) {
      assert_scalar(key)
      assert_scalar(milliseconds)
      self$context$run(c("PEXPIRE", key, milliseconds))
    },
    pexpireat=function(key, milliseconds_timestamp) {
      assert_scalar(key)
      assert_scalar(milliseconds_timestamp)
      self$context$run(c("PEXPIREAT", key, milliseconds_timestamp))
    },
    pfadd=function(key, element) {
      assert_scalar(key)
      self$context$run(c("PFADD", key, element))
    },
    pfcount=function(key) {
      self$context$run(c("PFCOUNT", key))
    },
    pfmerge=function(destkey, sourcekey) {
      assert_scalar(destkey)
      self$context$run(c("PFMERGE", destkey, sourcekey))
    },
    ping=function() {
      self$context$run(c("PING"))
    },
    psetex=function(key, milliseconds, value) {
      assert_scalar(key)
      assert_scalar(milliseconds)
      assert_scalar(value)
      self$context$run(c("PSETEX", key, milliseconds, value))
    },
    pttl=function(key) {
      assert_scalar(key)
      self$context$run(c("PTTL", key))
    },
    randomkey=function() {
      self$context$run(c("RANDOMKEY"))
    },
    rename=function(key, newkey) {
      assert_scalar(key)
      assert_scalar(newkey)
      self$context$run(c("RENAME", key, newkey))
    },
    renamenx=function(key, newkey) {
      assert_scalar(key)
      assert_scalar(newkey)
      self$context$run(c("RENAMENX", key, newkey))
    },
    restore=function(key, ttl, serialized_value, replace=NULL) {
      assert_scalar(key)
      assert_scalar(ttl)
      assert_scalar(serialized_value)
      assert_scalar_or_null(replace)
      self$context$run(c("RESTORE", key, ttl, serialized_value, replace))
    },
    rpop=function(key) {
      assert_scalar(key)
      self$context$run(c("RPOP", key))
    },
    rpoplpush=function(source, destination) {
      assert_scalar(source)
      assert_scalar(destination)
      self$context$run(c("RPOPLPUSH", source, destination))
    },
    rpush=function(key, value) {
      assert_scalar(key)
      self$context$run(c("RPUSH", key, value))
    },
    rpushx=function(key, value) {
      assert_scalar(key)
      assert_scalar(value)
      self$context$run(c("RPUSHX", key, value))
    },
    sadd=function(key, member) {
      assert_scalar(key)
      self$context$run(c("SADD", key, member))
    },
    scard=function(key) {
      assert_scalar(key)
      self$context$run(c("SCARD", key))
    },
    sdiff=function(key) {
      self$context$run(c("SDIFF", key))
    },
    sdiffstore=function(destination, key) {
      assert_scalar(destination)
      self$context$run(c("SDIFFSTORE", destination, key))
    },
    select=function(index) {
      assert_scalar(index)
      self$context$run(c("SELECT", index))
    },
    set=function(key, value, ex=NULL, px=NULL, condition=NULL) {
      assert_scalar(key)
      assert_scalar(value)
      assert_scalar_or_null(ex)
      assert_scalar_or_null(px)
      assert_scalar_or_null(condition)
      self$context$run(c("SET", key, value, ex, px, condition))
    },
    setbit=function(key, offset, value) {
      assert_scalar(key)
      assert_scalar(offset)
      assert_scalar(value)
      self$context$run(c("SETBIT", key, offset, value))
    },
    setex=function(key, seconds, value) {
      assert_scalar(key)
      assert_scalar(seconds)
      assert_scalar(value)
      self$context$run(c("SETEX", key, seconds, value))
    },
    setnx=function(key, value) {
      assert_scalar(key)
      assert_scalar(value)
      self$context$run(c("SETNX", key, value))
    },
    setrange=function(key, offset, value) {
      assert_scalar(key)
      assert_scalar(offset)
      assert_scalar(value)
      self$context$run(c("SETRANGE", key, offset, value))
    },
    sinter=function(key) {
      self$context$run(c("SINTER", key))
    },
    sinterstore=function(destination, key) {
      assert_scalar(destination)
      self$context$run(c("SINTERSTORE", destination, key))
    },
    sismember=function(key, member) {
      assert_scalar(key)
      assert_scalar(member)
      self$context$run(c("SISMEMBER", key, member))
    },
    smembers=function(key) {
      assert_scalar(key)
      self$context$run(c("SMEMBERS", key))
    },
    smove=function(source, destination, member) {
      assert_scalar(source)
      assert_scalar(destination)
      assert_scalar(member)
      self$context$run(c("SMOVE", source, destination, member))
    },
    sort=function(key, by=NULL, limit_offset=NULL, limit_count=NULL, get=NULL, order=NULL, sorting=NULL, store=NULL) {
      assert_scalar(key)
      assert_scalar_or_null(by)
      assert_scalar_or_null(limit_offset)
      assert_scalar_or_null(limit_count)
      assert_scalar_or_null(order)
      assert_scalar_or_null(sorting)
      assert_scalar_or_null(store)
      self$context$run(c("SORT", key, by, limit_offset, limit_count, get, order, sorting, store))
    },
    spop=function(key, count=NULL) {
      assert_scalar(key)
      assert_scalar_or_null(count)
      self$context$run(c("SPOP", key, count))
    },
    srandmember=function(key, count=NULL) {
      assert_scalar(key)
      assert_scalar_or_null(count)
      self$context$run(c("SRANDMEMBER", key, count))
    },
    srem=function(key, member) {
      assert_scalar(key)
      self$context$run(c("SREM", key, member))
    },
    strlen=function(key) {
      assert_scalar(key)
      self$context$run(c("STRLEN", key))
    },
    sunion=function(key) {
      self$context$run(c("SUNION", key))
    },
    sunionstore=function(destination, key) {
      assert_scalar(destination)
      self$context$run(c("SUNIONSTORE", destination, key))
    },
    ttl=function(key) {
      assert_scalar(key)
      self$context$run(c("TTL", key))
    },
    type=function(key) {
      assert_scalar(key)
      self$context$run(c("TYPE", key))
    },
    unwatch=function() {
      self$context$run(c("UNWATCH"))
    },
    watch=function(key) {
      self$context$run(c("WATCH", key))
    },
    zadd=function(key, score, member) {
      assert_scalar(key)
      score <- interleave(score, member)
      self$context$run(c("ZADD", key, score))
    },
    zcard=function(key) {
      assert_scalar(key)
      self$context$run(c("ZCARD", key))
    },
    zcount=function(key, min, max) {
      assert_scalar(key)
      assert_scalar(min)
      assert_scalar(max)
      self$context$run(c("ZCOUNT", key, min, max))
    },
    zincrby=function(key, increment, member) {
      assert_scalar(key)
      assert_scalar(increment)
      assert_scalar(member)
      self$context$run(c("ZINCRBY", key, increment, member))
    },
    zinterstore=function(destination, numkeys, key, weights=NULL, aggregate=NULL) {
      assert_scalar(destination)
      assert_scalar(numkeys)
      assert_scalar_or_null(weights)
      assert_scalar_or_null(aggregate)
      self$context$run(c("ZINTERSTORE", destination, numkeys, key, weights, aggregate))
    },
    zlexcount=function(key, min, max) {
      assert_scalar(key)
      assert_scalar(min)
      assert_scalar(max)
      self$context$run(c("ZLEXCOUNT", key, min, max))
    },
    zrange=function(key, start, stop, withscores=NULL) {
      assert_scalar(key)
      assert_scalar(start)
      assert_scalar(stop)
      assert_scalar_or_null(withscores)
      self$context$run(c("ZRANGE", key, start, stop, withscores))
    },
    zrangebylex=function(key, min, max, limit_offset=NULL, limit_count=NULL) {
      assert_scalar(key)
      assert_scalar(min)
      assert_scalar(max)
      assert_scalar_or_null(limit_offset)
      assert_scalar_or_null(limit_count)
      self$context$run(c("ZRANGEBYLEX", key, min, max, limit_offset, limit_count))
    },
    zrangebyscore=function(key, min, max, withscores=NULL, limit_offset=NULL, limit_count=NULL) {
      assert_scalar(key)
      assert_scalar(min)
      assert_scalar(max)
      assert_scalar_or_null(withscores)
      assert_scalar_or_null(limit_offset)
      assert_scalar_or_null(limit_count)
      self$context$run(c("ZRANGEBYSCORE", key, min, max, withscores, limit_offset, limit_count))
    },
    zrank=function(key, member) {
      assert_scalar(key)
      assert_scalar(member)
      self$context$run(c("ZRANK", key, member))
    },
    zrem=function(key, member) {
      assert_scalar(key)
      self$context$run(c("ZREM", key, member))
    },
    zremrangebylex=function(key, min, max) {
      assert_scalar(key)
      assert_scalar(min)
      assert_scalar(max)
      self$context$run(c("ZREMRANGEBYLEX", key, min, max))
    },
    zremrangebyrank=function(key, start, stop) {
      assert_scalar(key)
      assert_scalar(start)
      assert_scalar(stop)
      self$context$run(c("ZREMRANGEBYRANK", key, start, stop))
    },
    zremrangebyscore=function(key, min, max) {
      assert_scalar(key)
      assert_scalar(min)
      assert_scalar(max)
      self$context$run(c("ZREMRANGEBYSCORE", key, min, max))
    },
    zrevrange=function(key, start, stop, withscores=NULL) {
      assert_scalar(key)
      assert_scalar(start)
      assert_scalar(stop)
      assert_scalar_or_null(withscores)
      self$context$run(c("ZREVRANGE", key, start, stop, withscores))
    },
    zrevrangebylex=function(key, max, min, limit_offset=NULL, limit_count=NULL) {
      assert_scalar(key)
      assert_scalar(max)
      assert_scalar(min)
      assert_scalar_or_null(limit_offset)
      assert_scalar_or_null(limit_count)
      self$context$run(c("ZREVRANGEBYLEX", key, max, min, limit_offset, limit_count))
    },
    zrevrangebyscore=function(key, max, min, withscores=NULL, limit_offset=NULL, limit_count=NULL) {
      assert_scalar(key)
      assert_scalar(max)
      assert_scalar(min)
      assert_scalar_or_null(withscores)
      assert_scalar_or_null(limit_offset)
      assert_scalar_or_null(limit_count)
      self$context$run(c("ZREVRANGEBYSCORE", key, max, min, withscores, limit_offset, limit_count))
    },
    zrevrank=function(key, member) {
      assert_scalar(key)
      assert_scalar(member)
      self$context$run(c("ZREVRANK", key, member))
    },
    zscore=function(key, member) {
      assert_scalar(key)
      assert_scalar(member)
      self$context$run(c("ZSCORE", key, member))
    },
    zunionstore=function(destination, numkeys, key, weights=NULL, aggregate=NULL) {
      assert_scalar(destination)
      assert_scalar(numkeys)
      assert_scalar_or_null(weights)
      assert_scalar_or_null(aggregate)
      self$context$run(c("ZUNIONSTORE", destination, numkeys, key, weights, aggregate))
    },
    initialize=function(path) {
      self$context <- rlite_context(path)
    },
    close=function() {
      self$context$close()
    },
    is_closed=function() {
      self$context$is_closed()
    },
    reopen=function() {
      self$context$reopen()
    }))
