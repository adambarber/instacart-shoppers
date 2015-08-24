class Applicant < ActiveRecord::Base
  PHONE_TYPES = ['iPhone 6/6 Plus', 'iPhone 6s/6s Plus', 'iPhone 5/5S', 'iPhone 4/4S', 'iPhone 3G/3GS', 'Android 4.0+ (less than 2 years old)', 'Android 2.2/2.3 (over 2 years old)', 'Windows Phone', 'Blackberry', 'Other'].freeze
  REGIONS = ['San Francisco Bay Area', 'Chicago', 'Boston', 'NYC', 'Toronto', 'Berlin', 'Delhi'].freeze
  WORKFLOW_STATES = ['applied', 'quiz_started', 'quiz_completed', 'onboarding_requested', 'onboarding_completed', 'hired', 'rejected'].freeze

  after_initialize :set_initial_state

  scope :created_range, ->(start_date, end_date) { where("created_at >= ? AND created_at <= ?", start_date, end_date) }
  scope :by_created_at_week, -> { group("strftime('%Y-%m-%d', created_at)") }
  scope :by_workflow_state, -> { group(:workflow_state) }

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true, uniqueness: true, unless: ->{ self.new_record? }
  validates :phone_type, presence: true, inclusion: { in: PHONE_TYPES }, unless: ->{ self.new_record? }
  validates :workflow_state, inclusion: { in: WORKFLOW_STATES }, presence: true
  validates :region, presence: true, inclusion: { in: REGIONS }, unless: ->{ self.new_record? }

  def request_onboarding
    if self.workflow_state == 'quiz_completed'
      self.workflow_state = 'onboarding_requested'
      self.save
    end
  end

  def application_stage
    return :details if self.workflow_state == 'applied'
    return :background_check if self.workflow_state == 'quiz_completed'
    return :confirmation if self.workflow_state == 'onboarding_requested'
  end

  private

  def set_initial_state
    if self.new_record?
      self.workflow_state = WORKFLOW_STATES[0]
    end
  end
end
