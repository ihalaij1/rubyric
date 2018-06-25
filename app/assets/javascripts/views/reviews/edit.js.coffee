#= require jquery.grumble.min
#= require jquery.crumble
#= require reviewEditor

jQuery ->
  rawRubric = $('#rubric_payload').val()
  rubric = $.parseJSON(rawRubric) if rawRubric.length > 0
  
  editor = new ReviewEditor(rubric)
  editor.loadReview()
  
  #$('#tour').crumble()

  $("#review-form").on("ajax:error", (xhr, data, status) ->
    $('#save-message').removeClass('success').removeClass('error')
    $('#save-message').text("Failed to update review. Try again later.").addClass('error').css('opacity', 1)
  )
  $("#review-form").on("ajax:success", (xhr, data, status) ->
    $('#save-message').removeClass('success').removeClass('error')
    if (data.status == 'ok')
      $('#save-message').text(data.message).addClass('success').css('opacity', 1).fadeTo(5000, 0)
    else if (data.status == 'fail')
      $('#save-message').text(data.message).addClass('error').css('opacity', 1)
  )
