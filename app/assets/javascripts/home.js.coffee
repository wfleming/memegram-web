#= require bgpos.js 

$ ->  # on dom ready
  $('div.screenshot').bgcarousel({
    step_time: 2000
    total_steps: 3
  })
  
  
  
$.fn.bgcarousel = (opts) ->
  $elem = $(this)
  $elem.bgcarousel_opts = {
    step_time: opts.step_time || 2000
    total_steps: opts.total_steps
    current_step: 0
    animate_duration: 500
  }
  $elem.bg_x = ->
    parseInt($elem.css('background-position').split(' ')[0], 10)
  $elem.bgcarousel_step = ->
    $elem.bgcarousel_opts.current_step++
    if $elem.bgcarousel_opts.total_steps == $elem.bgcarousel_opts.current_step
      $elem.bgcarousel_opts.current_step = 0
      next_x = 0
    else
      next_x = $elem.bg_x() - $elem.width()
    $elem.stop().animate(
      {backgroundPosition: '(' + next_x + 'px 0px)'}
      {duration: $elem.bgcarousel_opts.animate_duration}
    )
  $elem.bgcarousel_timer = ->
    $elem.bgcarousel_step();
    setTimeout((-> $elem.bgcarousel_timer()), $elem.bgcarousel_opts.step_time)
  # end func defs/opt setup
  # now setup the first relevant timer
  $elem.backgroundPosition = "0px 0px"
  setTimeout((-> $elem.bgcarousel_timer()), $elem.bgcarousel_opts.step_time)