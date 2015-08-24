require 'rails_helper'

RSpec.describe FunnelsController, type: :controller do
  describe '#index' do
    context 'without params' do
      let(:current_time) { Time.now }
      let(:date_range_key) { "#{current_time.beginning_of_week.strftime('%Y-%m-%d')}-#{current_time.end_of_week.strftime('%Y-%m-%d')}" }

      before(:each) do
        FactoryGirl.create_list(:applicant, 1, created_at: 2.days.ago)
        FactoryGirl.create_list(:applicant, 2, created_at: 2.days.ago, workflow_state: 'quiz_started')
        FactoryGirl.create_list(:applicant, 1, created_at: 2.days.ago, workflow_state: 'quiz_completed')
        FactoryGirl.create_list(:applicant, 2, created_at: 2.days.ago, workflow_state: 'onboarding_requested')
        FactoryGirl.create_list(:applicant, 1, created_at: 2.days.ago, workflow_state: 'onboarding_completed')
        FactoryGirl.create_list(:applicant, 2, created_at: 2.days.ago, workflow_state: 'hired')
        FactoryGirl.create_list(:applicant, 1, created_at: 2.days.ago, workflow_state: 'rejected')
      end

      let(:params) { {} }
      before(:each) { get :index, params }
      it { expect(response.status).to eq 200 }
      it { expect(JSON.parse(response.body).keys).to include(date_range_key) }
      it 'returns the correct response' do
        date_group = JSON.parse(response.body)[date_range_key]
        expect(date_group['applied']).to eq 1
        expect(date_group['quiz_started']).to eq 2
        expect(date_group['quiz_completed']).to eq 1
        expect(date_group['onboarding_requested']).to eq 2
        expect(date_group['onboarding_completed']).to eq 1
        expect(date_group['hired']).to eq 2
        expect(date_group['rejected']).to eq 1
      end
    end



    context 'without params' do
      let(:start_date) { 1.week.ago.beginning_of_week.strftime('%Y-%m-%d') }
      let(:end_date) { Time.now.end_of_week.strftime('%Y-%m-%d') }
      let(:date_range_key) { "#{start_date}-#{end_date}" }
      let(:params) { { start_date: start_date, end_date: end_date } }

      before(:each) do
        FactoryGirl.create_list(:applicant, 1, created_at: 2.weeks.ago)
        FactoryGirl.create_list(:applicant, 1, created_at: 2.days.ago)
      end

      before(:each) { get :index, params }

      it { expect(response.status).to eq 200 }
      it 'returns the correct response' do
        date_group = JSON.parse(response.body)[date_range_key]
        expect(date_group['applied']).to eq 1
      end
    end
  end
end
