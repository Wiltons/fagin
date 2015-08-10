$(fetch).on 'ready page:load', ->

  poll = (div, callback) ->
    # Short timeout to avoid too many calls
    setTimeout ->
      console.log 'Calling...'
      $.get(div.data('status')).done (fetch) ->
        console.log 'Formatted ?', fetch.finished
        if fetch.finished
          # Yay, its imported, we can update the content
          callback()
        else
          # Not finished yet, lets make another request...
          poll(div, callback)
    , 2000

  $('[data-status]').each ->
    div = $(this)

    # Initiate the polling
    poll div, ->
      div.children('p').html('Formatted successfully.')
      div.children('a').show()
