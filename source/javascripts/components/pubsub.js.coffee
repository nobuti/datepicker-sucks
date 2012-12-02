# split = String::split;
# splice = Array::splice;
# join = Array::join;

# class PubSub
#   constructor: ->
#     @events = {}
  
#   suscribe: (ev, fn) ->
#     if typeof ev != "string" then ev = join.call(ev,' ')
#     splitted_events = split.call(ev, /\s+/)
#     for event in splitted_events
#       do (event) =>
#         @events[event] ?= []
#         @events[event].push(fn);

#   unsuscribe: (ev, fn) ->
#     if typeof ev != "string" then ev = join.call(ev,' ')
#     splitted_events = split.call(ev, /\s+/)      
#     for event in splitted_events
#       do (event) =>
#         if @events[event]?
#           if typeof fn == "function"
#             index = @events[event].indexOf(fn)
#             if index != -1 
#               splice.call(@events[event], index, 1)
#             else
#               delete @events[event]

#   publish: (ev) ->
#     if typeof ev != "string" then ev = join.call(ev,' ')
#     splitted_events = split.call(ev, /\s+/)  
#     for event in splitted_events
#       do (event) =>  
#         for fn in @events[event]  
#           do (fn) ->
#             fn.apply(null, split.call(arguments))
      
# if window? 
#   window.PubSub = PubSub

# # Expose to testing with mocha
# if exports? 
#   exports.PubSub = PubSub