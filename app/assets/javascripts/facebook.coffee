user = ''
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

  FB.api '/me?fields=id,name,email,age_range,first_name,last_name', (response) ->
    if response and !response.error
      $('#loading_div').show()
      $('#main_div').hide()
      user = response
      $.ajax
        url: '/load_main_frame'
        type: 'POST'
        dataType: 'HTML'
        success: (data) ->
          pantalla_2(data)
          $('select[data-dynamic-selectable-url][data-dynamic-selectable-target]').dynamicSelectable()
          $('#imagen_costillas').show()
        error: (data) ->
          console.log 'ERROR EXECUTING FIRST AJAX'
      return

    return

###############  PHOTO ###############

reset_form_element = (e) ->
  e.wrap('<form>').closest('form').get(0).reset()
  e.unwrap()
  return

load_video_canvas = ->

  # Grab elements, create settings, etc.
  canvas = document.getElementById('canvas')
  context = canvas.getContext('2d')
  video = document.getElementById('video')
  videoObj = 'video': true

  errBack = (error) ->
    console.log 'Video capture error: ', error.code
    return

  # Put video listeners into place
  if navigator.getUserMedia
    # Standard
    navigator.getUserMedia videoObj, ((stream) ->
      video.src = stream
      video.play()
      return
    ), errBack
  else if navigator.webkitGetUserMedia
    # WebKit-prefixed
    navigator.webkitGetUserMedia videoObj, ((stream) ->
      video.src = window.webkitURL.createObjectURL(stream)
      video.play()
      return
    ), errBack
  else if navigator.mozGetUserMedia
    # Firefox-prefixed
    navigator.mozGetUserMedia videoObj, ((stream) ->
      video.src = window.URL.createObjectURL(stream)
      video.play()
      return
    ), errBack
  document.getElementById('video').style.display = 'none'
  $('#camara_on').click ->
    $(this).hide()
    hide_avisos()
    document.getElementById('video').style.display = 'initial'
    document.getElementById('retake').style.display = 'none'
    document.getElementById('snap').style.display = 'initial'
    #document.getElementById("canvas").style.display="none";
    $('#canvas').hide()
    reset_form_element $('#file-input')
    $('#upload_button').hide()
    $('#img_container').empty()
    $('#canvas_container').show()
    $('.ci-main-canvas').show()
    $('#upload_photo_button').hide()
    $('#canvas_video_div').show()
    $('#html2canvas_col').hide()
    return

  document.getElementById('snap').addEventListener 'click', ->
    hide_avisos()
    context.drawImage video, 0, 0, 360, 270
    document.getElementById('video').style.display = 'none'
    document.getElementById('retake').style.display = 'initial'
    document.getElementById('snap').style.display = 'none'
    $('#img_container').empty()
    $('#canvas').show()
    $('#upload_photo_button').show()
    $('#canvas_video_col').show()
    $('#html2canvas_col').hide()
    pantalla_3()
    return
  document.getElementById('retake').addEventListener 'click', ->
    hide_avisos()
    document.getElementById('video').style.display = 'initial'
    document.getElementById('retake').style.display = 'none'
    document.getElementById('snap').style.display = 'initial'
    $('#canvas').hide()
    $('#upload_button').hide()
    $('#img_container').empty()
    $('#upload_photo_button').hide()
    $('#canvas_video_col').show()
    $('#html2canvas_col').hide()
    pantalla_3_hide()
    return
  return

###############  DRAGGABLE ###############

draggable = ->
  $('#canvas').draggable()
  return

###############  CROP PIC ###############
crop_pic = ->
  $('#file-input').change ->
    $('#canvas_video_div').show()
    $('#html2canvas_col').hide()
    $('#video').hide()
    $('#retake').hide()
    $('#snap').hide()
    hide_avisos()
    file = @files[0]
    imagefile = file.type
    imagesize = file.size
    match = [
      'image/jpeg'
      'image/png'
      'image/jpg'
    ]
    if !(imagefile == match[0] or imagefile == match[1] or imagefile == match[2])
      reset_form_element $('#file-input')
      $('#aviso_tamano').hide()
      $('#aviso_formato').show()
    else if imagesize > 2097152
      reset_form_element $('#file-input')
      $('#aviso_formato').hide()
      $('#aviso_tamano').show()
    else
      $('#img_container').empty()
      $('#img_container').prepend '<img id="uploaded_img" src="#" />'
      $('.ci-main-canvas').hide()
      $('#upload_photo_button').show()
      $('#snap').hide()
      $('#retake').hide()

      pantalla_3()
      readURL this
    return

  return
hide_avisos = ->
  $('#aviso_formato').hide()
  $('#aviso_tamano').hide()


readURL = (input) ->
  if input.files and input.files[0]
    reader = new FileReader

    reader.onload = (e) ->
      $('#uploaded_img').attr 'src', e.target.result
      $('.ci-image-wrapper img').show()
      $('#uploaded_img').cropimg
        maxContainerWidth: 600
        resultWidth: 600
        resultHeight: 600
        showBtnTips: false
        zoomDelay: 100
        mouseWheelZoomTimes: 10
        zoomStep: 3
        textBtnTipZoomIn: 'Acercar'
        textBtnTipZoomOut: 'Alejar'
        textBtnTipRTW: 'Ajustar al ancho del contenedor'
        textBtnTipRTH: 'Ajustar a la altura del contenedor'
        onChange: ->
      return

    reader.readAsDataURL input.files[0]
  return

###############  CHANGE PINTURAS  ###############

change_pinturas = ->
  $('#pintura01').click ->
    $('#pintura_div').removeClass()
    $('#pintura_div').addClass('pintura01')
    $('#pintura_div').show()
    $('#boton_compartir').show()
    $('#boton_compartir_off').hide()

  $('#pintura02').click ->
    $('#pintura_div').removeClass()
    $('#pintura_div').addClass('pintura02')
    $('#pintura_div').show()
    $('#boton_compartir').show()
    $('#boton_compartir_off').hide()

  $('#pintura03').click ->
    $('#pintura_div').removeClass()
    $('#pintura_div').addClass('pintura03')
    $('#pintura_div').show()
    $('#boton_compartir').show()
    $('#boton_compartir_off').hide()

  $('#pintura04').click ->
    $('#pintura_div').removeClass()
    $('#pintura_div').addClass('pintura04')
    $('#pintura_div').show()
    $('#boton_compartir').show()
    $('#boton_compartir_off').hide()

  $('#pintura05').click ->
    $('#pintura_div').removeClass()
    $('#pintura_div').addClass('pintura05')
    $('#pintura_div').show()
    $('#boton_compartir').show()
    $('#boton_compartir_off').hide()

  $('#pintura06').click ->
    $('#pintura_div').removeClass()
    $('#pintura_div').addClass('pintura06')
    $('#pintura_div').show()
    $('#boton_compartir').show()
    $('#boton_compartir_off').hide()

  $('#pintura00').click ->
    $('#pintura_div').hide()
    $('#boton_compartir').hide()
    $('#boton_compartir_off').show()

###############  CHANGE FRAMES ###############

change_frames = ->
  $('#frame01').click ->
    $('#frame_div').removeClass()
    $('#frame_div').addClass('frame01')

  $('#frame02').click ->
    $('#frame_div').removeClass()
    $('#frame_div').addClass('frame02')

  $('#frame03').click ->
    $('#frame_div').removeClass()
    $('#frame_div').addClass('frame03')

  $('#frame04').click ->
    $('#frame_div').removeClass()
    $('#frame_div').addClass('frame04')

  $('#frame05').click ->
    $('#frame_div').removeClass()
    $('#frame_div').addClass('frame05')

  $('#frame06').click ->
    $('#frame_div').removeClass()
    $('#frame_div').addClass('frame06')

########### PANTALLA 2 #################3

pantalla_2 = (data) ->
  $('#main_div').empty()
  $('#main_div').append data
  $('#loading_div').hide()
  $('body').addClass('fadeOut animated')
  $('body').removeClass()
  $('body').addClass('body_pantalla_2')
  $('body').addClass('fadeIn animated')
  $('#luces').hide()
  $('#main_div').show()
  $('#nombre_usuario_p').text(user.first_name.toUpperCase())
  $('#apellido_usuario_p').text(user.last_name.toUpperCase())
  $('#participante_nombre').val(user.name)
  $('#participante_email').val(user.email)
  load_video_canvas()
  crop_pic()
  draggable()
  change_pinturas()
  change_frames()
  upload_pic()
  validar_form()

########### PANTALLA 3 ################

pantalla_3 = ->
  $('#form_div').hide()
  $('#cambiar_arte_div').show()
  $('#camara_on').hide()
  $('#cambiar_marco').show()
  $('#row_compartir').show()

pantalla_3_hide = ->
  $('#row_compartir').hide()


########## COMPARTIR EN FACEBOOK ##########
facebook_share = (url_imagen) ->
  FB.ui {
    method: 'feed'
    link: url_imagen
    caption: 'La historia de Chile ya conoce mi nombre como prócer de la parrilla.'
    picture: url_imagen
    description: 'Y tú ¡qué esperas para quedar en la memoria! ingresa aquí, haz tu autoretrato y participa por un pack de productos Super Cerdo.'
  }, (response) ->
    if response and !response.error_code
      $('#canvas_video_div').addClass('fadeOut')
      $('#canvas_video_div').hide()
      $('#formulario_div').show()
      $('#formulario_div').addClass('fadeIn')

    else if response and response.error_code == 4201
      #$('#canvas_video_div').show()
      #$('#html2canvas_output').empty()
      #$('#html2canvas_col').hide()
      #console.log 'User cancelled: ' + decodeURIComponent(response.error_message)
    else
      #$('#canvas_video_div').show()
      #$('#html2canvas_output').empty()
      #$('#html2canvas_col').hide()
      console.log 'Closed ' + JSON.stringify(response)
      $('.portrait').addClass('fadeOut')
      $('.portrait').hide()
      $('#formulario_div').show()
      $('#formulario_div').addClass('fadeIn')

    return


upload_pic = ->

  $('#boton_compartir').click ->
    $('#html2canvas_output').empty()
    $('#retake').hide()
    $('#snap').hide()
    html2canvas $('#canvas_video_div'), onrendered: (canvas) ->
      theCanvas = canvas
      document.body.appendChild canvas
      dataURL = canvas.toDataURL('image/png')
      # Convert and download as image
      Canvas2Image.convertToPNG canvas
      $('#canvas_video_div').hide()
      $('#html2canvas_output').append canvas
      $('#html2canvas_col').show()
      $.ajax
        url: '/upload_img'
        type: 'POST'
        dataType: 'json'
        data:
          img: dataURL
          email: user.email
        success: (data) ->
          if data == 'max_pics_reached'
            console.log 'max_pics_reached'
          else if data == 'false'
            console.log 'error on upload'
          else
            img_url =  data
            facebook_share(img_url)
        error: (data) ->
          console.log 'ERROR 2AJX'
      return
    return

################# VALIDACION DE FORMULARIO ###############
validar_form = ->

  $('#participante_fecha_nacimiento').datepicker(

    format: 'dd/mm/yyyy'
    language: 'es',
    startView: 'decade',
    startDate: '01/01/1930',
    endDate: '30/12/2015'
    changeMonth: true
    changeYear: true
    yearRange: '-90:+0'
    daysShort: ["Dom", "Lun", "Mar", "Mie", "Jue", "Vie", "Sab", "Dom"],
    daysMin: ["Do", "Lu", "Ma", "Mi", "Ju", "Vi", "Sa", "Do"],
    months: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
                 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
    monthsShort: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
                      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dec']).on 'changeDate', (e) ->
                          $('#form_participante').bootstrapValidator 'revalidateField', 'participante[fecha_nacimiento]'


  $('#form_participante').bootstrapValidator
    feedbackIcons:
      valid: 'fa fa-check ',
      invalid: 'fa fa-times',
      validating: 'fa fa-refresh'
    live: 'submitted'
    fields:
      'participante[fecha_nacimiento]':
        validators:
          notEmpty:
            message: 'Debe seleccionar una fecha de nacimiento.'
          date: {
            format: 'DD/MM/YYYY',
            min: '01/01/1920',
            max: '30/12/2015',
            message: 'Fecha no válida'
          }
      "participante[provincia_id]":
        validators:
          notEmpty:
            message: 'Debe seleccionar una provincia.'
