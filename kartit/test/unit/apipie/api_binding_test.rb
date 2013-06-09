require_relative '../test_helper'
require_relative 'fake_api'

describe Kartit::Apipie::ApipieBinding do

  let(:binding) { Kartit::Apipie::ApipieBinding.new(FakeApi::Resources) }

  let(:host) { "http://some.host.org/" }
  let(:username) { "admin_user" }
  let(:password) { "secret_password" }

  before :each do
    Kartit::Settings.load({ :host => host, :username => username, :password => password })
  end

  it "should create method for binding classes with simple name" do
    binding.must_be :respond_to?, :architecture
  end

  it "should create method for binding classes with camel case name" do
    binding.must_be :respond_to?, :camel_case_name
  end

  it "should return foreman bindings" do
    binding.architecture.must_be_instance_of FakeApi::Resources::Architecture
  end

  it "should take values from settings by default" do
    expected_attrs = {:base_url => host, :username => username, :password => password}

    FakeApi::Resources::Architecture.expects(:new).with(expected_attrs)
    binding.architecture
  end


end

