require_relative 'test_helper'

describe KartitSigno::TokenStore do

  it "should store token" do
    Dir.mktmpdir do |dir|
      store = KartitSigno::TokenStore.new(dir)
      token = KartitSigno::Token.new('secret', 'expiration')
      store.add_token token
      assert_equal 1, Dir["#{dir}/*"].count
    end
  end

end
