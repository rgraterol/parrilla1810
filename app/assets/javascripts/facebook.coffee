user = ''
frame_flag = true
pic_flag = true
jQuery(document).ready ($) ->

  $('#boton_facebook').click ->
    $('#boton_facebook').hide()
    $('#boton_facebook_off').fadeIn(1000)
    $('#boton_facebook_loading').fadeIn(2000)
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
      $('#pantalla_intro').fadeOut(1500)
      user = response
      $.ajax
        url: '/load_main_frame'
        type: 'POST'
        dataType: 'HTML'
        success: (data) ->
          pantalla_2(data)
          $('select[data-dynamic-selectable-url][data-dynamic-selectable-target]').dynamicSelectable()
          $('#row_bottom').show().fadeIn(1000)
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
    snap_taked(context)

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
    $('.ci-main-canvas').show()
    pantalla_3_hide()
    return
  return

snap_taked = (context) ->
  hide_avisos()
  context.drawImage video, 0, 0, 360, 270
  the_canvas = document.getElementById("canvas");
  dataURL = the_canvas.toDataURL('image/png')
  pastedImage = new Image();
  # Convert and download as image
  pastedImage = Canvas2Image.convertToPNG the_canvas
  pastedImage.id = "snap_image"
  pastedImage.className = 'canvas'
  $('#img_container').empty()
  $('#img_container').html(pastedImage)
  canvas_cropmg()
  $('.ci-main-canvas').hide()
  $('#canvas_video_div').show()
  $('#html2canvas_col').hide()
  $('#canvas').hide()
  $('#upload_photo_button').show()
  document.getElementById('video').style.display = 'none'
  document.getElementById('retake').style.display = 'initial'
  document.getElementById('snap').style.display = 'none'
  pantalla_3()
  return

canvas_cropmg = ->
  $('#snap_image').cropimg
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

###############  CROP PIC ###############
crop_pic = ->
  $('#file-input').change ->
    $('#canvas_video_div').show()
    $('#html2canvas_col').hide()
    $('#video').hide()
    $('#retake').hide()
    $('#snap').hide()
    $('#camara_on').show()
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
      $('#img_container').prepend '<img id="uploaded_img" src="#" class="panzoom" />'
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
      if /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|ipad|iris|kindle|Android|Silk|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(navigator.userAgent) or /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(navigator.userAgent.substr(0, 4))
        $('#uploaded_img').draggable
          drag: (e, ui) ->
            $(ui.draggable).appendTo($(this));
            $(this).appendTo('#img_container');
        $('#zoom-range').fadeIn(1500)
        $section = $('#img_container')
        $panzoom = $section.find('.panzoom').panzoom
          $zoomRange: $("#zoom-range")
          contain: true
          disablePan: false
          minScale: 0.01
        $panzoom.parent().on 'mousewheel.focal', (e) ->
          e.preventDefault()
          delta = e.delta or e.originalEvent.wheelDelta
          zoomOut = if delta then delta < 0 else e.originalEvent.deltaY > 0
          $panzoom.panzoom 'zoom', zoomOut,
            increment: 0.1
            animate: false
            focal: e
          return
      else
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
    pintura_selected()


  $('#pintura02').click ->
    $('#pintura_div').removeClass()
    $('#pintura_div').addClass('pintura02')
    pintura_selected()

  $('#pintura03').click ->
    $('#pintura_div').removeClass()
    $('#pintura_div').addClass('pintura03')
    pintura_selected()

  $('#pintura04').click ->
    $('#pintura_div').removeClass()
    $('#pintura_div').addClass('pintura04')
    pintura_selected()

  $('#pintura05').click ->
    $('#pintura_div').removeClass()
    $('#pintura_div').addClass('pintura05')
    pintura_selected()

  $('#pintura06').click ->
    $('#pintura_div').removeClass()
    $('#pintura_div').addClass('pintura06')
    pintura_selected()

  $('#pintura00').click ->
    $('#pintura_div').hide()
    $('#boton_compartir').hide()
    $('#boton_compartir_off').show()
    pintura_selected()

pintura_selected = ->
  if frame_flag
    $('.bs-cuadros-modal-lg').modal('show');
    frame_flag = false
  $('#pintura_div').show()
###############  CHANGE FRAMES ###############

change_frames = ->
  $('#frame01').click ->
    $('#frame_div').removeClass()
    $('#frame_div').addClass('frame01')
    frame_selected()

  $('#frame02').click ->
    $('#frame_div').removeClass()
    $('#frame_div').addClass('frame02')
    frame_selected()

  $('#frame03').click ->
    $('#frame_div').removeClass()
    $('#frame_div').addClass('frame03')
    frame_selected()

  $('#frame04').click ->
    $('#frame_div').removeClass()
    $('#frame_div').addClass('frame04')
    frame_selected()

  $('#frame05').click ->
    $('#frame_div').removeClass()
    $('#frame_div').addClass('frame05')
    frame_selected()

  $('#frame06').click ->
    $('#frame_div').removeClass()
    $('#frame_div').addClass('frame06')
    frame_selected()

frame_selected = ->
  $('#row_continuar').fadeIn(1500)

boton_continuar = ->
  $('#boton_continuar').click ->
    $('#row_continuar').fadeOut(500)
    $('#cambiar_arte').hide()
    $('#cambiar_arte_div').hide()
    $('#navigation_1').hide()
    $('#texto_1').hide()
    $('#navigation_2').fadeIn(1000)
    $('#camara_on').fadeIn(1000)
    $('#form_div').fadeIn(1000)
    $('#texto_2').fadeIn(1000)
    if ($(window).width() < 800) && ($('#m_texto_artemarco').is(':visible'))
      $('#m_texto_artemarco').removeClass()
      $('#m_texto_foto').fadeIn(1000)
########### PANTALLA 2 #################3

pantalla_2 = (data) ->
  $('#main_div').empty().hide()
  $('#loading_div').fadeOut(500)
  $('#main_div').append(data).fadeIn(1000)
  $('#luces').hide()
  $('#main_div').show()
  $('#nombre_usuario_p').text(user.first_name.toUpperCase())
  $('#apellido_usuario_p').text(user.last_name.toUpperCase())
  $('#participante_nombre').val(user.name)
  $('#participante_email').val(user.email)
  load_video_canvas()
  crop_pic()
  change_pinturas()
  change_frames()
  upload_pic()
  validar_form()
  boton_continuar()
  $('.bs-pinturas-modal-lg').modal('show');
  #$(window).resize ->
  #  if $(window).width() > 800
  #    $('body').addClass('fadeOut animated')
  ##    $('body').removeClass()
  #    $('body').addClass('body_pantalla_2')
  #    $('body').addClass('fadeIn animated')
  #  else
  #    $('body').addClass('fadeOut animated')
  #    $('body').removeClass()
  #    $('body').addClass('body_pantalla_1')
  #    $('body').addClass('fadeIn animated')

########### PANTALLA 3 ################

pantalla_3 = ->
  $('#row_compartir').fadeIn(1000)
  $('#boton_compartir').show()
  $('#boton_compartir_off').hide()
pantalla_3_hide = ->
  $('#boton_compartir').hide()
  $('#boton_compartir_off').show()


########## COMPARTIR EN FACEBOOK ##########
facebook_share = (url_imagen) ->
  $('#loading_facebook_share').show()
  FB.ui {
    method: 'feed'
    link: 'http://nosunelaparrilla.cl'
    caption: 'La historia de Chile ya conoce mi nombre como prócer de la parrilla.'
    picture: url_imagen
    description: 'Y tú ¡qué esperas para quedar en la memoria! ingresa aquí, haz tu autoretrato y participa por un pack de productos Super Cerdo.'
  }, (response) ->
    if response and !response.error_code
      console.log(response)
      $('#row_compartir').fadeOut(1000)
      $('#navigation_2').hide()
      $('#navigation_3').fadeIn(1500)
      $('.portrait').addClass('fadeOut')
      $('.portrait').hide()
      $('.row_encender_camara').hide()
      $('#canvas_video_div').addClass('fadeOut')
      $('#canvas_video_div').hide()
      $('#formulario_div').fadeIn(1500)
      $('#form_div').fadeOut(1000)
      $('#m_adorno_form').addClass('m_adorno_form')

    else if response and response.error_code == 4201
      console.log( response )
      $('#row_compartir').fadeOut(1000)
      $('#navigation_2').hide()
      $('#navigation_3').fadeIn(1500)
      $('.portrait').addClass('fadeOut')
      $('.portrait').hide()
      $('.row_encender_camara').hide()
      $('#canvas_video_div').addClass('fadeOut')
      $('#canvas_video_div').hide()
      $('#formulario_div').fadeIn(1500)
      $('#form_div').fadeOut(1000)
      $('#m_adorno_form').addClass('m_adorno_form')
    else
      console.log 'Closed ' + JSON.stringify(response)
      $('#row_compartir').fadeOut(1000)
      $('#navigation_2').hide()
      $('#navigation_3').fadeIn(1500)
      $('.portrait').addClass('fadeOut')
      $('.portrait').hide()
      $('#canvas_video_div').addClass('fadeOut')
      $('#canvas_video_div').hide()
      $('#formulario_div').fadeIn(1500)
      $('#form_div').fadeOut(1000)
      $('.row_encender_camara').hide()
      $('#m_adorno_form').addClass('m_adorno_form')

    return


upload_pic = ->

  $('#boton_compartir').click ->
    $('#m_texto_foto').hide()
    $('#boton_compartir').hide()
    $('#boton_compartir_off').show()
    $('#loading_facebook_share').show()
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
          #if data == 'max_pics_reached'
          #  console.log 'max_pics_reached'
          #else if data == 'false'
          #  $('#canvas_video_div').show()
          #  $('#html2canvas_col').show()
          #  $('#loading_facebook_share').hide()
          #else
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
