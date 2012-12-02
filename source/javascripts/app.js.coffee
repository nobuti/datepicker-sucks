#= require_directory ./components

_.select '.datepicker'

feedback = document.querySelector('.feedback')

_.suscribe 'datepicker.error', (event) ->
    feedback.className = 'feedback show'

_.suscribe 'datepicker.valid', (event) ->
    feedback.className = 'feedback hide'