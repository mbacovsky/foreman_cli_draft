module Kartit::Output
  class BaseAdapter


    def message msg
      puts msg
    end

    def error msg
      puts msg
    end

    def print_collection data, heading=nil
      print_heading heading unless heading.nil?
      data.each do |d|
        print_item d
      end
    end

    def print_item data, heading=nil
      print_heading heading unless heading.nil?
      puts data
    end

    protected
    def print_heading heading
      puts "-"*20
      puts heading
      puts "-"*20
    end

  end
end
