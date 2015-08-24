require 'rails_helper'

RSpec.describe "Routes", type: :routing do
  # Default route
  it { should route(:get, "/").to('home#index') }

  # Application routing
  it { should route(:get, "/apply").to('apply#index') }
  it { should route(:post, "/apply").to('apply#create') }
  it { should route(:put, "/apply/1").to('apply#update', id: '1') }
  it { should route(:get, "/apply/details").to('apply#details') }
  it { should route(:get, "/apply/quiz").to('apply#quiz') }
  it { should route(:get, "/apply/background-check").to('apply#background_check') }
  it { should route(:get, "/apply/confirmation").to('apply#confirmation') }
  it { should route(:post, "/apply/find-existing-application").to('apply#find_existing') }

  # Funnels routing
  it { should route(:get, "/funnels").to('funnels#index') }

  # Validation Routing
  it { should route(:get, "/validations/email").to('validations#email') }
  it { should route(:get, "/validations/phone").to('validations#phone') }
end