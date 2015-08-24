class HomeController < ApplicationController
  def index
    if session[:applicant]
      @applicant = Applicant.find(session[:applicant]['id'])
      redirect_to controller: 'apply', action: @applicant.application_stage
    else
      @applicant = Applicant.new
    end
  end
end
