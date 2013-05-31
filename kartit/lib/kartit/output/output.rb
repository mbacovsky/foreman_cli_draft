require 'kartit/output/base_adapter'

module Kartit::Output
  class Output

    def adapter= adapter
      @adapter = adapter
    end

    def adapter
      @adapter ||= Kartit::Output::BaseAdapter.new
      @adapter
    end

    def message msg
      adapter.message(msg.to_s)
    end

    def error msg
      adapter.error(msg.to_s)
    end

    def print_data data, heading=nil
      if data.kind_of?(Array)
        adapter.print_collection(data, heading)
      else
        adapter.print_item(data, heading)
      end
    end

  end
end
