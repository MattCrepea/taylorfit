
class ME

  constructor: ( ) ->
    @listeners = { }
    undefined

  on: ( target, listener ) ->
    (@listeners[target] or= [ ]).push listener
    undefined

  fire: ( target, message ) ->
    if listeners = @listeners[target]
      for listener in listeners
        listener.call this, message
    undefined

# eventually have Adapter class extending ME

module.exports = new class WorkerAdapter extends ME

  constructor: ( ) ->
    super

    @worker = new Worker "engine-worker.js"

    @worker.onerror = ( error ) =>
      console.debug "Worker/res [error]", error
      @fire "error", error

    @worker.onmessage = ( { type, data } ) =>
      console.debug "Worker/res [#{type}]", data
      @fire type, data

  post: ( target, message ) ->
    console.debug "Worker/req [#{target}]", message
    @worker.postMessage
      type: target
      data: message

  for target in [
    "dataset", "dependent",
    "multiplicands", "exponents"
  ]
    do ( target ) ->
      WorkerAdapter::["post_#{target}"] = ( message ) ->
        m = { }; m[target] = message
        @post "update", m

