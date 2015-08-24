class ApplyController < ApplicationController
  before_action :find_applicant_from_session_or_redirect, only: [:update, :quiz, :background_check, :confirmation, :details]

  def index
    redirect_to root_url
  end

  def find_existing
    @applicant = Applicant.where(email: params[:email]).first
    if @applicant
      session[:applicant] = @applicant
      flash[:notice] = t('home.existing_application_modal.found_application', first_name: @applicant.first_name)
      redirect_to action: @applicant.application_stage
    else
      flash[:error] = t('home.existing_application_modal.no_such_email_error')
      redirect_to root_url
    end
  end

  def create
    @applicant = Applicant.new(applicant_params)
    if @applicant.save
      session[:applicant] = @applicant
      session[:application_step] = :details
      redirect_to details_apply_index_path
    else
      flash[:error] = @applicant.errors.full_messages if @applicant.errors.any?
      redirect_to root_url
    end
  end

  def update
    @applicant.assign_attributes(applicant_params)
    if @applicant.save
      session[:applicant] = @applicant
      session[:application_step] = :quiz
      redirect_to action: :quiz
    else
      flash[:error] = @applicant.errors.full_messages if @applicant.errors.any?
      redirect_to details_apply_index_path
    end
  end

  def save_quiz
    @applicant = Applicant.find(params[:id])
    if(params[:workflow_state] == 'quiz_started')
      @applicant.update_attributes(workflow_state: 'quiz_started')
      render json: true
    elsif(params[:workflow_state] == 'quiz_completed')
      @applicant.update_attributes(workflow_state: 'quiz_completed')
      render json: true
    else
      render json: ''
    end
  end

  def details
    @current_step = :details
  end

  def quiz
    @current_step = :quiz
  end

  def background_check
    @current_step = :background_check
  end

  def confirmation
    @current_step = :confirmation
    # change the applicants workflow_state from 'quiz_completed' to 'onboarding_requested'
    @applicant.request_onboarding
  end

  private

  def find_applicant_from_session_or_redirect
    if session[:applicant]
      @applicant = Applicant.find(session[:applicant]['id'])
    else
      redirect_to root_url
    end
  end

  def applicant_params
    params.require(:applicant).permit(:first_name, :last_name, :email, :phone, :phone_type, :region, :over_21)
  end
end
