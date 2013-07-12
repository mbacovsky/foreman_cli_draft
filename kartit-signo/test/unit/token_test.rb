require 'digest/sha1'
require_relative 'test_helper'

describe KartitSigno::Token do

  it "should have secret" do
    token = KartitSigno::Token.new('secret', 'exp')
    assert_equal 'secret', token.secret
  end

  it "should have secret that is read-only" do
    token = KartitSigno::Token.new('secret', 'exp')
    assert_raises(NoMethodError) { token.secret = 'x' }
  end

  it "should have expiration" do
    token = KartitSigno::Token.new('secret', 'exp')
    assert_equal 'exp', token.expires
  end

  it "should have secret that is read-only" do
    token = KartitSigno::Token.new('secret', 'exp')
    assert_raises(NoMethodError) { token.expires = 'x' }
  end

  it "should have name that is read-only" do
    token = KartitSigno::Token.new('secret', 'exp', name='name')
    assert_raises(NoMethodError) { token.name = 'x' }
  end

  it "should have name" do
    token = KartitSigno::Token.new('secret', 'exp', name='name')
    assert_equal 'name', token.name
  end

  it "should have default name set to sha1 of the secret" do
    token = KartitSigno::Token.new('secret', 'exp')
    assert_equal Digest::SHA1.hexdigest('secret'), token.name
  end

  it "should have default name with proper encoding" do
    # important for proper YAML serialization
    token = KartitSigno::Token.new('secret', 'exp')
    assert_equal 'UTF-8', token.name.encoding.name
  end
end
