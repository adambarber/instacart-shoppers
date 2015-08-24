$ ->
  $('.edit_applicant').validate
    rules:
      'applicant[phone]':
        required: true
        remote:
          url: '/validations/phone'
          data:
            applicant_id: window.applicant_id
            value: ->
              return $('#applicant_phone').val()
      'applicant[phone_type]': 'required'
      'applicant[region]': 'required'
    messages:
      'applicant[phone]':
        remote: "An application with this phone number already exists."
    highlight: (element) ->
      containerElement = $(element).parent('.input-group');
      $(containerElement).addClass('error');
    unhighlight: (element) ->
      containerElement = $(element).parent('.input-group');
      $(containerElement).removeClass('error');


  $(document.body).on 'click', '#background_check_agree', (e) ->
    isChecked = $(e.target)[0].checked
    if(isChecked)
      $('.background-check-continue-button .button').removeClass('disabled')
    else
      $('.background-check-continue-button .button').addClass('disabled')

