include ApplicationHelper

def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end

def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara
    remember_token=User.new_remember_token
    cookies[:remember_token]=remember_token
    user.update_attribute(:remember_token, User.hash(remember_token))
  else
    OmniAuth.config.mock_auth[:pocket] = OmniAuth::AuthHash.new(
                                       { provider: 'pocket',
                                         uid: '123',
                                         credentials:
                                          {token: '111'}
                                       })
    click_link "Sign in with Pocket"
  end
end

def fake_one_article
  body = "{\"status\":1,
    \"complete\":1,
    \"list\":
    {\"237938806\":
      {\"item_id\":\"237938806\",
      \"resolved_id\":\"237938806\",
      \"given_url\":\"http:\\/\\/getpocket.com\\/developer\\/docs\\/v3\\/retrieve\",
      \"given_title\":\"\",
      \"favorite\":\"0\",
      \"status\":\"0\",
      \"time_added\":\"1400690783\",
      \"time_updated\":\"1400703984\",
      \"time_read\":\"0\",
      \"time_favorited\":\"0\",
      \"sort_id\":0,
      \"resolved_title\":\"Retrieve\",
      \"resolved_url\":\"http:\\/\\/getpocket.com\\/developer\\/docs\\/v3\\/retrieve\",
      \"excerpt\":\"Pocket's \\/v3\\/get endpoint is a single call that is incredibly versatile. A few examples of the types of requests you can make: In order to use the \\/v3\\/get endpoint, your consumer key must have the \\\"Retrieve\\\" permission.\",
      \"is_article\":\"1\",
      \"is_index\":\"0\",
      \"has_video\":\"0\",
      \"has_image\":\"0\",
      \"word_count\":\"855\"}
    }
  }"
  FakeWeb.register_uri(:post, "https://getpocket.com/v3/get", body: body)
end

def fake_new_article
  body = "{\"status\":1,
    \"complete\":1,
    \"list\":
    {\"1111111\":
      {\"item_id\":\"1111111\",
      \"given_url\":\"http:\\/\\/getpocket.com\\/developer\\/docs\\/v3\\/retrieve\",
      \"given_title\":\"\", \"favorite\":\"0\",
      \"status\":\"0\", 
      \"time_added\":\"1400690783\",
      \"time_updated\":\"1400703984\",
      \"resolved_title\":\"Retrieve\",
      \"resolved_url\":\"http:\\/\\/getpocket.com\\/developer\\/docs\\/v3\\/retrieve\",
      \"is_article\":\"1\", \"word_count\":\"855\"}
    }
  }"
  FakeWeb.register_uri(:post, "https://getpocket.com/v3/get", body: body)
end
