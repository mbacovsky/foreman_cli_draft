
module Kartit::Output::Adapter
  class Abstract

    def print_message msg
      puts msg
    end

    def print_error msg
      $stderr.puts msg
    end

    def print_records fields, data, heading=nil
      raise NotImplementedError
    end

  end
end
