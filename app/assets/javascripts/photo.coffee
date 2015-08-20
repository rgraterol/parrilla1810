jQuery(document).ready ($) ->

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
      context.drawImage video, 0, 0, 355, 265
      document.getElementById('video').style.display = 'none'
      document.getElementById('retake').style.display = 'initial'
      document.getElementById('snap').style.display = 'none'
      $('#img_container').empty()
      $('#canvas').show()
      $('#upload_photo_button').show()
      $('#canvas_video_col').show()
      $('#html2canvas_col').hide()
      return
    document.getElementById('retake').addEventListener 'click', ->
      $('#message').empty()
      document.getElementById('video').style.display = 'initial'
      document.getElementById('retake').style.display = 'none'
      document.getElementById('snap').style.display = 'initial'
      $('#canvas').hide()
      $('#upload_button').hide()
      $('#img_container').empty()
      $('#upload_photo_button').hide()
      $('#canvas_video_col').show()
      $('#html2canvas_col').hide()
      return
    return
  ), false
  return


