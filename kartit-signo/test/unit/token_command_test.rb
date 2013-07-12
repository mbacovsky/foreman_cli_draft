require_relative 'test_helper'
require 'highline/import'

describe KartitSigno::TokenCommand do

  context "InitCommand" do

    let(:cmd) { KartitSigno::TokenCommand::InitCommand.new("") }
    let(:signo_response) { JSON.parse("{\"oauth_secret\":\"Uu7mvCqssmz6KS2EMrnRkZw1OPXyiCpM3OOoPpbEoGM\",\"expiration\":\"2013-07-03T22:09:46Z\"}") }

    before :each do
      KartitSigno::SignoAPI.any_instance.stubs(:post).with('/login.json', {:username => 'admin', :password => 'admin'}).returns(signo_response)
    end

    it "should get and store the token" do
      Dir.mktmpdir do |dir|
        cmd.run(["--token-dir=#{dir}", "--username=admin", "--password=admin"])
        assert_equal 1, Dir["#{dir}/*"].count
      end
    end

    it "should load token_dir from settings if not set with a param" do
      Dir.mktmpdir do |dir|
        Kartit::Settings.load :token_dir => dir
        cmd.run(["--username=admin", "--password=admin"])
        assert_equal 1, Dir["#{dir}/*"].count
      end
    end

    it "should prompt for password if not set in args" do
      Dir.mktmpdir do |dir|
        HighLine.any_instance.stubs(:ask).returns("admin")
        cmd.run(["--token-dir=#{dir}", "--username=admin"])
        assert_equal 1, Dir["#{dir}/*"].count
      end
    end

    # signo uri is loaded from settings or param
    # test token can be named a handles conflicts properly --token-name

  end

end
