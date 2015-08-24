$ ->
  $(document.body).on 'click', '.existing-application', (e) ->
    $('.existing-application-modal-overlay').toggleClass('visible')
    $('.existing-application-modal').toggleClass('visible')

  $(document.body).on 'click', '.close, .existing-application-modal-overlay', (e) ->
    if($('.existing-application-modal-overlay').hasClass('visible'))
      $('.existing-application-modal-overlay').toggleClass('visible')
      $('.existing-application-modal').toggleClass('visible')

  $(document.body).on 'click', '.get-started-cta', (e) ->
    $("html, body").animate({ scrollTop:0 });
    $('.hero-form-wrapper').addClass 'highlighted'

  $('#existing_application_form').on 'blur, keyup', 'input', (e) ->
    if($('#existing_application_form').valid())
      $('#existing_application_form .button').removeClass('disabled')
    else
      $('#existing_application_form .button').addClass('disabled')

  $('#existing_application_form').on 'submit', (e) ->
    $(this).addClass('submitting')

  $('#existing_application_form').validate
    highlight: (element) ->
      containerElement = $(element).parent('.input-wrapper');
      $(containerElement).addClass('error');
    unhighlight: (element) ->
      containerElement = $(element).parent('.input-wrapper');
      $(containerElement).removeClass('error');
    rules:
      'email':
        'required': true
    messages:
      required: I18n.t("scripts.existing_application.errors.email.required")
      email: I18n.t("scripts.existing_application.errors.email.email")

  $('.new_applicant').validate
    rules:
      'applicant[first_name]': 'required'
      'applicant[last_name]': 'required'
      'applicant[email]':
        'required': true
        'remote':
          'url': '/validations/email'
          'data':
            'value': ->
              return $('#applicant_email').val()
    messages:
      'applicant[first_name]':
        required: I18n.t("scripts.new_applicant.errors.first_name.required")
      'applicant[last_name]':
        required: I18n.t("scripts.new_applicant.errors.last_name.required")
      'applicant[email]':
        required: I18n.t("scripts.new_applicant.errors.email.required")
        email: I18n.t("scripts.new_applicant.errors.email.email")
        remote: I18n.t("scripts.new_applicant.errors.email.remote")

    highlight: (element) ->
      containerElement = $(element).parent('.input-group');
      $(containerElement).addClass('error');
    unhighlight: (element) ->
      containerElement = $(element).parent('.input-group');
      $(containerElement).removeClass('error');