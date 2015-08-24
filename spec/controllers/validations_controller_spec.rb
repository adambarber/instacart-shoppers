require 'rails_helper'

RSpec.describe ValidationsController, type: :controller do
  describe '#email' do
    it "returns false if applicant already exists" do
      FactoryGirl.create(:applicant, email: 'shopper@instacart.com')
      get :email, value: 'shopper@instacart.com'
      expect(response.body).to eq 'false'
    end
    it "returns true if applicant doesnt exist" do
      get :email, value: 'shopper@instacart.com'
      expect(response.body).to eq 'true'
    end
  end

  describe '#phone' do
    it "returns false if applicant already exists" do
      FactoryGirl.create(:applicant, phone: '555-555-1234')
      get :phone, value: '555-555-1234'
      expect(response.body).to eq 'false'
    end
    it "returns true if applicant doesnt exist" do
      get :phone, value: '555-555-1234'
      expect(response.body).to eq 'true'
    end
  end
end
