$ ->

  removeFlashWrapperWhenEmpty = ->
    wrapper = $('.flash-messages-wrapper')
    inner = $('flash-messages-inner')
    if(wrapper && inner.children().length == 0)
      wrapper.remove()

  fadeOutAndRemoveFlashMessage = (element) ->
    setTimeout ->
      $(element).addClass('fade')
      setTimeout ->
        $(element).remove()
        removeFlashWrapperWhenEmpty()
      , 500
    , 3000

  if($('.flash-messages-wrapper'))
    if($('.flash-messages-wrapper').children().length > 0)
      $('.flash-messages-wrapper .message-wrapper').each (idx, element) ->
        fadeOutAndRemoveFlashMessage(element)
