require 'rails_helper'

RSpec.describe ApplyController, type: :controller do
  describe '#index' do
    before { get :index }
    it { expect(response).to redirect_to(root_url) }
  end

  describe '#find_existing' do
    context 'with existing application' do
      let(:applicant_email) { 'found@example.com' }
      let(:applicant) { FactoryGirl.create(:applicant, email: applicant_email) }
      before(:each) { applicant }
      before(:each) { post :find_existing, { email: applicant_email }}

      it { expect(response).to redirect_to(details_apply_index_path) }
      it { expect(assigns(:applicant)).to eq(applicant) }
      it { expect(session[:applicant]).to eq(applicant) }

      it 'sets flash to correct message' do
        message = I18n.t('home.existing_application_modal.found_application', first_name: applicant.first_name)
        expect(flash[:notice]).to eq(message)
      end
    end

    context 'with no existing application' do
      let(:applicant_email) { 'notfound@example.com' }
      before(:each) { post :find_existing, { email: applicant_email }}
      it { expect(response).to redirect_to(root_url) }
      it 'sets flash to correct message' do
        message = I18n.t('home.existing_application_modal.no_such_email_error')
        expect(flash[:error]).to eq(message)
      end
    end

  end

  describe '#create' do
    context 'successfully' do
      let(:applicant_params) { {first_name: 'First', last_name: 'Last', email: 'unique@email.com'} }
      it { expect{ post :create, applicant: applicant_params }.to change{Applicant.count}.from(0).to(1) }
      it 'redirects to the details page' do
        post :create, applicant: applicant_params
        expect(response).to redirect_to(details_apply_index_path)
      end
      it 'sets the session applicant to the new applicant' do
        post :create, applicant: applicant_params
        expect(session[:applicant]).to eq Applicant.last
      end
    end

    context "unsuccessfully" do
      context 'missing first name' do
        let(:applicant_params) { {last_name: 'Last', email: 'unique@email.com'} }
        before { post :create, applicant: applicant_params }

        it { expect(flash[:error]).to include("First name can't be blank") }
        it { expect(response).to redirect_to(root_url) }
      end
      context 'missing last name' do
        let(:applicant_params) { {first_name: 'First', email: 'unique@email.com'} }
        before { post :create, applicant: applicant_params }

        it { expect(flash[:error]).to include("Last name can't be blank") }
        it { expect(response).to redirect_to(root_url) }
      end

      context 'missing email' do
        let(:applicant_params) { {first_name: 'First', last_name: 'Last'} }
        before { post :create, applicant: applicant_params }

        it { expect(flash[:error]).to include("Email can't be blank") }
        it { expect(response).to redirect_to(root_url) }
      end

      context 'duplicate email' do
        let(:applicant_params) { {first_name: 'First', last_name: 'Last', email: 'dup@example.com'} }

        before { FactoryGirl.create(:applicant, email: 'dup@example.com')}
        before { post :create, applicant: applicant_params }
        it { expect(flash[:error]).to include("Email has already been taken") }
        it { expect(response).to redirect_to(root_url) }
      end
    end
  end

  describe '#update' do
    context 'successfully' do
      let(:applicant) { FactoryGirl.create(:applicant) }
      let(:applicant_params) { {phone: '555-555-1223', phone_type: 'iPhone 6s/6s Plus', region: 'Chicago'} }
      before(:each) { applicant }
      before(:each) { session[:applicant] = applicant }
      before(:each) { put :update, id: applicant.id, applicant: applicant_params }
      it { expect(assigns(:applicant)).to eq(applicant) }
      it { expect(response).to redirect_to(quiz_apply_index_path) }
      it { expect(Applicant.last.phone).to eq '555-555-1223' }
      it { expect(Applicant.last.region).to eq 'Chicago' }
      it { expect(Applicant.last.phone_type).to eq 'iPhone 6s/6s Plus' }
    end
    context 'unsuccessfully' do
      let(:applicant) { FactoryGirl.create(:applicant, phone: '555-555-1224') }
      let(:applicant_params) { {phone: '555-555-1223', phone_type: 'iPhone 6s/6s Plus', region: 'Chicago'} }
      before(:each) { FactoryGirl.create(:applicant, phone: '555-555-1223') }
      before(:each) { applicant }
      before(:each) { session[:applicant] = applicant }
      before(:each) { put :update, id: applicant.id, applicant: applicant_params}

      it { expect(response).to redirect_to(details_apply_index_path) }

      context 'when phone already exists' do
        let(:applicant_params) { {phone: '555-555-1223', phone_type: 'iPhone 6s/6s Plus', region: 'Chicago'} }
        it { expect(flash[:error]).to include("Phone has already been taken") }
      end

      context 'when phone is missing exists' do
        let(:applicant) { FactoryGirl.create(:applicant, phone: nil) }
        let(:applicant_params) { { phone_type: 'iPhone 6s/6s Plus', region: 'Chicago'} }
        it { expect(flash[:error]).to include("Phone can't be blank") }
      end
      context 'when phone_type is missing exists' do
        let(:applicant) { FactoryGirl.create(:applicant, phone: '555-555-1224', phone_type: nil) }
        let(:applicant_params) { { region: 'Chicago'} }
        it { expect(flash[:error]).to include("Phone type can't be blank") }
      end
      context 'when region is missing exists' do
        let(:applicant) { FactoryGirl.create(:applicant, region: nil) }
        let(:applicant_params) { { phone: '555-555-1223', phone_type: 'iPhone 6s/6s Plus'} }
        it { expect(flash[:error]).to include("Region can't be blank")}
      end
    end
  end

  describe '#details' do
    context 'without session' do
      before(:each) { get :details }
      it { expect(response).to redirect_to(root_url) }
    end
    context 'with session' do
      let(:applicant) { FactoryGirl.create(:applicant) }
      before(:each) { applicant }
      before(:each) { session[:applicant] = applicant }
      before(:each) { get :details }

      it { expect(assigns[:current_step]).to eq :details }
      it { expect(response).to render_template(:details) }
    end
  end

  describe '#background_check' do
    context 'without session' do
      before(:each) { get :background_check }
      it { expect(response).to redirect_to(root_url) }
    end

    context 'with session' do
      let(:applicant) { FactoryGirl.create(:applicant) }
      before(:each) { applicant }
      before(:each) { session[:applicant] = applicant }
      before(:each) { get :background_check }

      it { expect(assigns[:current_step]).to eq :background_check }
      it { expect(response).to render_template(:background_check) }
    end
  end

  describe '#confirmation' do
    context 'without session' do
      before(:each) { get :confirmation }
      it { expect(response).to redirect_to(root_url) }
    end

    context 'with session' do
      let(:applicant) { FactoryGirl.create(:applicant) }
      before(:each) { applicant }
      before(:each) { session[:applicant] = applicant }
      before(:each) { get :confirmation }
      it { expect(assigns[:current_step]).to eq :confirmation }
      it { expect(response).to render_template(:confirmation) }
    end
  end

end