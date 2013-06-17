module KartitForeman
  module Formatters

    def self.date_formatter string_date
      t = DateTime.parse(string_date.to_s)
      t.strftime("%Y/%m/%d %H:%M:%S")
    rescue ArgumentError
      ""
    end

  end
end



