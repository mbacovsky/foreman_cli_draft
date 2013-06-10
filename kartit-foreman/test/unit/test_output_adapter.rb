require 'kartit/output/adapter/abstract'


class TestAdapter < Kartit::Output::Adapter::Abstract

  def initialize separator="#"
    @separator = separator
  end

  def print_records fields, data, heading=nil
    puts @separator+fields.collect{|f| f[:label].to_s}.join(@separator)+@separator
    data.each do |d|
      puts @separator+d.values.join(@separator)+@separator
    end
  end

end


