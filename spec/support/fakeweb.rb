RSpec.configure do |config|
  config.before(:each) do
    FakeWeb.allow_net_connect = false
  end

  config.after(:each) do
    FakeWeb.clean_registry
  end
end
