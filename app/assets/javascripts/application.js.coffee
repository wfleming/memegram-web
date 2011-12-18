$ -> #on-dom-ready
  setup_gaevent_anchors()
  
  
# function to bind code to anchors
# to trigger configured google analytics
# events on click
setup_gaevent_anchors = ->
  $('a.gaevent').click( (evt) -> 
    if (_gaq)
      a = $(this)
      evt.preventDefault()
      _gaq.push(['_trackEvent', a.data('gaecategory'), a.data('gaeaction'), a.data('gaelabel')])
      _gaq.push( -> window.location.href = a.attr('href') )
  )