jQuery(document).ready ($) ->

  $('#upload_photo_button').click ->
    html2canvas $('#canvas_container'), onrendered: (canvas) ->
      theCanvas = canvas
      document.body.appendChild canvas
      # Convert and download as image
      Canvas2Image.convertToPNG canvas
      $('#img_canvas_output').append canvas
      $('#img_canvas_output').show()
      # Clean up
      #document.body.removeChild(canvas);
      return
    return

  UploadPic = ->
    # Generate the image data
    Pic = document.getElementById('canvas').toDataURL('image/png')
    Pic = Pic.replace(/^data:image\/(png|jpg);base64,/, '')
    console.log Pic
    # Sending the image data to Server

    ###$.ajax({
        type: 'POST',
        url: 'Save_Picture.aspx/UploadPic',
        data: '{ "imageData" : "' + Pic + '" }',
        contentType: 'application/json; charset=utf-8',
        dataType: 'json',
        success: function (msg) {
            alert("Done, Picture Uploaded.");
        }
    });
    ###

    return

  reset_form_element = (e) ->
    e.wrap('<form>').closest('form').get(0).reset()
    e.unwrap()
    return

  window.addEventListener 'DOMContentLoaded', (->
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
      $('#message').empty()
      document.getElementById('video').style.display = 'initial'
      document.getElementById('retake').style.display = 'none'
      document.getElementById('snap').style.display = 'initial'
      #document.getElementById("canvas").style.display="none";
      $('.ci-main-canvas').hide()
      reset_form_element $('#file-input')
      $('#upload_button').hide()
      $('#img_container').empty()
      $('#upload_photo_button').hide()
      return

    ###$('#file-input').change(function(e) {
    	document.getElementById("video").style.display="none";
           document.getElementById("retake").style.display="none";
           document.getElementById("snap").style.display="none";
           var file = e.target.files[0],
               imageType = /image.;

           if (!file.type.match(imageType))
               return;

           var reader = new FileReader();
           reader.onload = fileOnload;
           reader.readAsDataURL(file);

       });
    ###

    document.getElementById('snap').addEventListener 'click', ->
      $('#message').empty()
      context.drawImage video, 0, 0, 640, 480
      document.getElementById('video').style.display = 'none'
      document.getElementById('retake').style.display = 'initial'
      document.getElementById('snap').style.display = 'none'
      $('.ci-main-canvas').show()
      $('#img_container').empty()
      $('#upload_photo_button').show()
      return
    document.getElementById('retake').addEventListener 'click', ->
      $('#message').empty()
      document.getElementById('video').style.display = 'initial'
      document.getElementById('retake').style.display = 'none'
      document.getElementById('snap').style.display = 'initial'
      $('.ci-main-canvas').hide()
      $('#upload_button').hide()
      $('#img_container').empty()
      $('#upload_photo_button').hide()
      return
    return
  ), false
  return


