require_relative 'test_helper'
require 'json'

describe KartitSigno::SignoAPI do

  context "login" do

    let(:signo) { KartitSigno::SignoAPI.new('signo url', 'username', 'password') }
    let(:signo_response) { JSON.parse("{\"oauth_secret\":\"Uu7mvCqssmz6KS2EMrnRkZw1OPXyiCpM3OOoPpbEoGM\",\"expiration\":\"2013-07-03T22:09:46Z\"}") }

    before :each do
      signo.stubs(:post).returns(signo_response)
    end

    it 'should init signo token' do
      token = signo.login
      assert_instance_of KartitSigno::Token, token
    end

    it 'should init signo token that has secret set' do
      token = signo.login
      assert_equal token.secret, signo_response['oauth_secret']
    end

    it 'should init signo token that has expiration set' do
      token = signo.login
      assert_equal token.expires, signo_response['expiration']
    end

    # test failures on invalid uri, invalid credentials

  end
end
