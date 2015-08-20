jQuery(document).ready ($) ->

  $('#upload_photo_button').click ->
    $('#html2canvas_output').empty()
    $('#retake').hide()
    $('#snap').hide()
    html2canvas $('#canvas_video_div'), onrendered: (canvas) ->
      theCanvas = canvas
      document.body.appendChild canvas
      dataURL = canvas.toDataURL('image/png')
      console.log(dataURL)
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
        success: (data) ->
          console.log 'HOLA'
        error: (data) ->
          console.log 'SOMETHING HAPPENED'
      return
    return