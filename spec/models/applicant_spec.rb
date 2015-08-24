require 'rails_helper'

RSpec.describe Applicant, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:workflow_state) }
    it { should validate_inclusion_of(:workflow_state).in_array(Applicant::WORKFLOW_STATES) }

    context 'new record' do
      before { allow(subject).to receive(:new_record?) { true } }
      it { should_not validate_presence_of(:phone) }
      it { should_not validate_uniqueness_of(:phone) }
      it { should_not validate_presence_of(:phone_type) }
      it { should_not validate_presence_of(:region) }
    end

    context 'existing record' do
      before { allow(subject).to receive(:new_record?) { false } }
      it { should validate_presence_of(:phone) }
      it { should validate_presence_of(:phone_type) }
      it { should validate_presence_of(:region) }

      it { should validate_inclusion_of(:phone_type).in_array(Applicant::PHONE_TYPES) }
      it { should validate_inclusion_of(:region).in_array(Applicant::REGIONS) }
    end
  end

  describe 'initialization' do
    subject{ Applicant.new }
    before { allow(subject).to receive(:new_record?) { true } }
    it { expect(subject.workflow_state).to eq 'applied' }
  end

  describe 'scopes' do
    it '.created_range' do
      out_of_range_record = FactoryGirl.create(:applicant, created_at: 1.month.ago)
      in_range_record = FactoryGirl.create(:applicant, created_at: 1.week.ago)
      expect(Applicant.created_range(2.weeks.ago, Time.now).count).to eq 1
      expect(Applicant.created_range(2.weeks.ago, Time.now)).to include(in_range_record)
      expect(Applicant.created_range(2.weeks.ago, Time.now)).to_not include(out_of_range_record)
    end

    it '.by_created_at_week' do
      first_applicant = FactoryGirl.create(:applicant, created_at: 1.month.ago)
      second_applicant = FactoryGirl.create(:applicant, created_at: 1.week.ago)
      expect(Applicant.by_created_at_week.count(:created_at).keys).to include(first_applicant.created_at.strftime('%Y-%m-%d'))
      expect(Applicant.by_created_at_week.count(:created_at).keys).to include(second_applicant.created_at.strftime('%Y-%m-%d'))
    end
    it '.by_workflow_state' do
      first_applicant = FactoryGirl.create(:applicant, workflow_state: 'applied')
      second_applicant = FactoryGirl.create(:applicant, workflow_state: 'quiz_started')
      expect(Applicant.by_workflow_state.count(:workflow_state).keys).to include(first_applicant.workflow_state)
      expect(Applicant.by_workflow_state.count(:workflow_state).keys).to include(second_applicant.workflow_state)
    end
  end

  describe '#application_stage' do
    context 'when workflow_state is applied' do
      before { allow(subject).to receive(:workflow_state) { 'applied' } }
      it { expect(subject.application_stage).to eq :details }
    end
    context 'when workflow_state is applied' do
      before { allow(subject).to receive(:workflow_state) { 'quiz_completed' } }
      it { expect(subject.application_stage).to eq :background_check }
    end
    context 'when workflow_state is applied' do
      before { allow(subject).to receive(:workflow_state) { 'onboarding_requested' } }
      it { expect(subject.application_stage).to eq :confirmation }
    end
  end

  describe '#request_onboarding' do
    context 'quiz_completed state' do
      subject { FactoryGirl.create(:applicant, workflow_state: 'quiz_completed') }
      it 'changes workflow_state to onboarding_requested' do
        subject.request_onboarding
        subject.reload
        expect(subject.workflow_state).to eq 'onboarding_requested'
      end
    end
    context 'not quiz_completed state' do
      subject { FactoryGirl.create(:applicant) }
      it 'doesnt change workflow_state to onboarding_requested' do
        subject.request_onboarding
        subject.reload
        expect(subject.workflow_state).to eq 'applied'
      end
    end
  end
end
