#= require price-calculator

jQuery ->
  new PriceCalculator()

  # Shows input fields for lti params if radio button lti is chosen
  # otherwise hides them
  $('input[type="radio"]').click ->
    if ( $(this).val() == "lti" )
      $("#lti-params").css("display", "block")
    else
      $("#lti-params").css("display", "none")
