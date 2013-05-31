require 'minitest/autorun'
require 'minitest/spec'

require 'kartit'


describe Kartit::Settings do

  before :each do
    Kartit::Settings.clear
  end
  let(:settings) { Kartit::Settings }

  it "returns nil when nothing is loaded" do
    settings[:a].must_be_nil
  end

  it "returns nil on unknown key" do
    settings.load({:a => 1})
    settings[:b].must_be_nil
  end

  it "returns correct value" do
    settings.load({:a => 1})
    settings[:a].must_equal 1
  end

  it "takes both strings and symbols" do
    settings.load({:a => 1, 'b' => 2})
    settings['a'].must_equal 1
    settings[:b].must_equal 2
  end

  it "loads all settings" do
    settings.load({:a => 1, :b => 2})
    settings[:a].must_equal 1
    settings[:b].must_equal 2
  end

  it "merges settings on second load" do
    settings.load({:a => 1, :b => 2})
    settings.load({:b => 'B', :c => 'C'})
    settings[:a].must_equal 1
    settings[:b].must_equal 'B'
    settings[:c].must_equal 'C'
  end

  it "clear wipes all settings" do
    settings.load({:a => 1, :b => 2})
    settings.clear
    settings[:a].must_be_nil
    settings[:b].must_be_nil
  end

end

