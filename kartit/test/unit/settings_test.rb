require 'minitest/autorun'
require 'minitest/spec'

require 'kartit'


describe Kartit::Settings do

  before :each do
    Kartit::Settings.clear
  end

  it "returns nil when nothing is loaded" do
    Kartit::Settings[:a].must_be_nil
  end

  it "returns nil on unknown key" do
    Kartit::Settings.load({:a => 1})
    Kartit::Settings[:b].must_be_nil
  end

  it "returns correct value" do
    Kartit::Settings.load({:a => 1})
    Kartit::Settings[:a].must_equal 1
  end

  it "takes both strings and symbols" do
    Kartit::Settings.load({:a => 1, 'b' => 2})
    Kartit::Settings['a'].must_equal 1
    Kartit::Settings[:b].must_equal 2
  end

  it "loads all settings" do
    Kartit::Settings.load({:a => 1, :b => 2})
    Kartit::Settings[:a].must_equal 1
    Kartit::Settings[:b].must_equal 2
  end

  it "merges settings on second load" do
    Kartit::Settings.load({:a => 1, :b => 2})
    Kartit::Settings.load({:b => 'B', :c => 'C'})
    Kartit::Settings[:a].must_equal 1
    Kartit::Settings[:b].must_equal 'B'
    Kartit::Settings[:c].must_equal 'C'
  end

  it "clear wipes all settings" do
    Kartit::Settings.load({:a => 1, :b => 2})
    Kartit::Settings.clear
    Kartit::Settings[:a].must_be_nil
    Kartit::Settings[:b].must_be_nil
  end

end

