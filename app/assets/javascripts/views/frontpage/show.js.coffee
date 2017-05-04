#= require price-calculator

jQuery ->
  $('#carousel').carousel(interval: 15000)
  new PriceCalculator()
