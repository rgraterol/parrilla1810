jQuery(document).ready ($) ->

  $frame = $('#frame')
  $wrap = $frame.parent()
  # Call Sly on frame
  $frame.sly
    horizontal: 1
    itemNav: 'basic'
    smart: 1
    activateOn: 'click'
    mouseDragging: 1
    touchDragging: 1
    releaseSwing: 1
    startAt: 0
    scrollBar: $wrap.find('.scrollbar')
    scrollBy: 1
    speed: 300
    elasticBounds: 1
    easing: 'easeOutExpo'
    dragHandle: 1
    dynamicHandle: 1
    clickBar: 1
    cycleBy: 'items'
    cycleInterval: 1000
    pauseOnHover: 1
    forward: $wrap.find('.forward')
    backward: $wrap.find('.backward')
    prev: $wrap.find('.prev')
    next: $wrap.find('.next')
  # Pause button
  $wrap.find('.pause').on 'click', ->
    $frame.sly 'pause'
    return
  # Resume button
  $wrap.find('.resume').on 'click', ->
    $frame.sly 'resume'
    return
  # Toggle button
  $wrap.find('.toggle').on 'click', ->
    $frame.sly 'toggle'
    return
  return
