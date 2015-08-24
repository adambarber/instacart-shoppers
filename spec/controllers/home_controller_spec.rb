require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe "#index" do
    context 'without session' do
      before(:each) { get :index }
      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:index) }
      it { expect(assigns(:applicant)).to be_a_new(Applicant)  }
    end
    context 'with session' do
      let(:applicant) { FactoryGirl.create(:applicant) }
      before(:each) do
        session[:applicant] = applicant
        session[:application_step] = :details
        get :index
      end
      it { expect(response.status).to eq 302 }
      it { expect(response).to redirect_to(details_apply_index_path) }
    end
  end

end
