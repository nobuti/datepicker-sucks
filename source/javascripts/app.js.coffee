#= require_directory ./components

_.select '.datepicker'

feedback = document.querySelector('.feedback')

_.suscribe 'datepicker.error', (event) ->
    console.log "Invalid date #{feedback}"
    feedback.className = 'feedback show'

_.suscribe 'datepicker.valid', (event) ->
    console.log "Correct date"
    feedback.className = 'feedback hide'