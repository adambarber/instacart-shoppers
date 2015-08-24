class ValidationsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def email
    email_exists = Applicant.where(email: params[:value]).any?
    render json: !email_exists
  end

  def phone
    phone_exists = Applicant.where(phone: params[:value]).any?
    render json: !phone_exists
  end
end
