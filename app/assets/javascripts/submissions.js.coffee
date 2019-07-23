jQuery ->
  # Attach event listeners
  $('#reviews-select-finished').click(-> $('#submissions_table input.review_check_finished').prop('checked', true))
  $('#reviews-select-all').click(-> $('#submissions_table input.review_check').prop('checked', true))
  $('#reviews-select-none').click(-> $('#submissions_table input.review_check').prop('checked', false))
  
  $('#send-reviews').click((event) => 
    countCheckedTextualGradeReview = $('#submissions_table input.review_textual_grade').filter(':checked').length
    if countCheckedTextualGradeReview > 0
      $('#modal-send-reviews').modal('show')
    else
      $('#send-reviews-form').submit()
    )
  
  $('#submit-send-reviews-modal').click((event) =>
    $('#send-reviews-form').submit()
  )
  
  # Hide grader submissions lists and show list for all submissions
  $('.grader-submissions-content').hide()
  $('#all-submissions').show()
  
  # Show the submission list whose id is stored in href and hide all others
  $('.grader-link').click(->
    $('.grader-submissions-content').hide()
    target = $( this ).attr('href')
    $(target).show()
  )
