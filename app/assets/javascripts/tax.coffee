submitForm = (data) ->
  $.ajax
    type: "POST"
    url: $("#new_tax").attr('action')
    data: data
    dataType: "json"
    success: (data) ->
      window.location = data.url
    error: (data) ->
      $('.topbar-wrapper').after('<div class="centered alert-message">'+data.responseText+'</div>')
    complete: ->
      $('#new_tax').find('input[type="submit"]').removeAttr('disabled')

stripeResponseHandler = (status, response) ->
  if response.error
    $('.topbar-wrapper').after('<div class="centered alert-message">'+response.error.message+'</div>')
    $('#new_tax').find('input[type="submit"]').removeAttr('disabled')
  else
    data = {}
    data['tax[name]'] = $('#tax_name').val()
    data['tax[description]'] = $('#tax_description').val()
    data['tax[goal]'] = $('#tax_goal').val()
    data['tax[bank_token]'] = response.id
    submitForm(data)

createToken = ->
  Stripe.bankAccount.createToken
    country: "US"
    routingNumber: $("#routing_number").val()
    accountNumber: $("#account_number").val()
  , stripeResponseHandler


$(document).ready ->
  $('#new_tax').submit (e) ->
    $(this).find('input[type="submit"]').attr('disabled', 'true')
    e.preventDefault()
    createToken()