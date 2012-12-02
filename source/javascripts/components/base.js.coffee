# Avoid `console` errors in browsers that lack a console
if !(window.console and console.log)
    do ->
      noop = ->
      methods = ['assert', 'clear', 'count', 'debug', 'dir', 'dirxml', 'error', 'exception', 'group', 'groupCollapsed', 'groupEnd', 'info', 'log', 'markTimeline', 'profile', 'profileEnd', 'markTimeline', 'table', 'time', 'timeEnd', 'timeStamp', 'trace', 'warn']
      length = methods.length
      console = window.console = {}
      while (length--)
          console[methods[length]] = noop