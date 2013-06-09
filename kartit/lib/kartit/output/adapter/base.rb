
module Kartit::Output::Adapter
  class Base < Abstract

    def print_records fields, data, heading=nil
      print_heading heading unless heading.nil?

      data.each do |d|
        fields.each do |f|
          puts f[:label].to_s + ": " + d[f[:key]].to_s
        end
        puts
      end
    end

    protected

    def print_heading heading
      puts "-"*20
      puts heading
      puts "-"*20
    end

  end
end
