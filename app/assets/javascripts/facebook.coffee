jQuery(document).ready ($) ->
  $('#boton_facebook').click ->
    FB.getLoginStatus (response) ->
      if response.status == 'connected'
        facebook_functions()
      else
        FB.login ((response) ->
          if response.authResponse
            facebook_functions()
          else
            console.log 'Dont Got Permissions'
          return
        ), scope: 'email,public_profile,user_friends'
      return
    return


facebook_functions = ->

  FB.api '/me?fields=id,name,email,age_range', (response) ->
    if response and !response.error
      $('#loading_div').show()
      $('#main_div').hide()
      $.ajax
        url: '/load_main_frame'
        type: 'POST'
        dataType: 'HTML'
        success: (data) ->
          $('#main_div').empty()
          $('#main_div').append data
          $('#loading_div').hide()
          $('body').addClass('fadeOut animated')
          $('body').removeClass()
          $('body').addClass('body_pantalla_2')
          $('body').addClass('fadeIn animated')
          $('#luces_row').hide()
          $('#main_div').show()
          console.log data
        error: (data) ->
          console.log 'SOMETHING HAPPENED'
      return

    return


