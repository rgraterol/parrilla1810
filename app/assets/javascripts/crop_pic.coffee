jQuery(document).ready ($) ->

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
          zoomDelay: 400
          mouseWheelZoomTimes: 10
          zoomStep: 1
          textBtnTipZoomIn: 'Acercar'
          textBtnTipZoomOut: 'Alejar'
          textBtnTipRTW: 'Ajustar al ancho del contenedor'
          textBtnTipRTH: 'Ajustar a la altura del contenedor'
          onChange: ->
        return

      reader.readAsDataURL input.files[0]
    return

  reset_form_element = (e) ->
    e.wrap('<form>').closest('form').get(0).reset()
    e.unwrap()
    return

  $('#file-input').change ->
    $('#video').hide()
    $('#retake').hide()
    $('#snap').hide()
    $('#message').empty()
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
      $('#message').html '<p id=\'error\'>El archivo debe ser una imagen válida</p>' + '<h4>Nota</h4>' + '<span id=\'error_message\'>Solo los formatos .jpg, .jpeg y .png son admitidos.</span>'
    else if imagesize > 1048576
      reset_form_element $('#file-input')
      $('#message').html '<p id=\'error\'>Archivo demasiado grande!</p>'
    else
      $('#img_container').empty()
      $('#img_container').prepend '<img id="uploaded_img" src="#" />'
      $('.ci-main-canvas').hide()
      $('#upload_button').show()
      readURL this
    return
  return
