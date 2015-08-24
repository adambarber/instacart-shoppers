class ValidationsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def email
    email_exists = Applicant.where(email: params[:value]).exists?
    render json: !email_exists
  end

  def phone
    applicant = Applicant.find(params[:applicant_id])
    applicant.assign_attributes(phone: params[:value])
    applicant.valid?
    render json: applicant.errors[:phone].empty?
  end
end
