split = String::split;
splice = Array::splice;
join = Array::join;

class PubSub
  constructor: ->
    @events = {}
  
  suscribe: (ev, fn) ->
    if typeof ev != "string" then ev = join.call(ev,' ')
    splitted_events = split.call(ev, /\s+/)
    for event in splitted_events
      do (event) =>
        @events[event] ?= []
        @events[event].push(fn);

  unsuscribe: (ev, fn) ->
    if typeof ev != "string" then ev = join.call(ev,' ')
    splitted_events = split.call(ev, /\s+/)      
    for event in splitted_events
      do (event) =>
        if @events[event]?
          if typeof fn == "function"
            index = @events[event].indexOf(fn)
            if index != -1 
              splice.call(@events[event], index, 1)
            else
              delete @events[event]

  publish: (ev) ->
    if typeof ev != "string" then ev = join.call(ev,' ')
    splitted_events = split.call(ev, /\s+/)  
    for event in splitted_events
      do (event) =>  
        for fn in @events[event]  
          do (fn) ->
            fn.apply(null, split.call(arguments))
      
class Momento
  constructor: ->
    this

  is_valid: (date) ->
    components = @has_format date
    return false if components == null 
    [@day, @month, @year] = (~~num for num in components[1..])
    test_date = ''+ @day + @month + @year
    user_date = new Date(@year, @month-1, @day) 
    test_date == @get_full_date(user_date)

  has_format: (date) ->
    date.match /^(0?[1-9]|[12][0-9]|3[01])[\/\-](0?[1-9]|1[012])[\/\-](\d{4})$/

  get_full_date: (date, sep='') ->
    [day, month, year] = @components(date)
    ''+ day + sep + (month+1) + sep + year

  now: ->
    @get_full_date(new Date(), '/')

  components: (date) ->
    [+date.getDate(), +date.getMonth(), +date.getFullYear()]

  up: (days = 1) ->
    offset = days*24*60*60*1000
    date = new Date(Date.UTC(@year, @month-1, @day) + offset)
    @get_full_date(date, '/')

  down: (days = 1) ->
    offset = days*24*60*60*1000
    date = new Date(Date.UTC(@year, @month-1, @day) - offset)
    @get_full_date(date, '/')



class Datepicker extends PubSub

  constructor: ->
    @momento = new Momento()
    super
    this

  select: (selector)->
    @elem = document.querySelector(selector)
    @elem.value = @momento.now()
    @bind 'keyup', @handler
    this

  bind: (event,cb) ->
    if @elem.addEventListener
        @elem.addEventListener event, cb, false
    else if @elem.attachEvent
        @elem.attachEvent 'on' + event, ->
            cb.call event.srcElement, event

  handler: (event) =>
    if @momento.is_valid(@elem.value)
      @publish 'datepicker.valid'
      if event.keyCode == 38
        @elem.value = (if event.shiftKey then @momento.up(15) else @momento.up())

      if event.keyCode == 40
        @elem.value = (if event.shiftKey then @momento.down(15) else @momento.down())
    else 
      @publish 'datepicker.error'

if window? 
  window._ = new Datepicker()
  
# Expose to testing with mocha
if exports? 
  exports.Datepicker = Datepicker
  exports.Momento = Momento
  exports.PubSub = PubSub


