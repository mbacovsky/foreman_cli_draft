require 'terminal-table'

module Kartit::Output::Adapter
  class Base < Abstract

    def print_records fields, records, heading=nil

      spacer = [nil, nil, nil]

      rows = data.inject([spacer]) do |rows, record|
        field_rows = fields.map do |field|
          key   = field.label.to_s
          value = record[field.key].to_s

          [key, ":", value]
        end

        rows + field_rows + [spacer]
      end

      table = Terminal::Table.new :title => heading,
                                  :rows  => rows,
                                  :style => { :border_y => '', :border_i => '', :border_x => '-' }
      puts table
    end

  end
end
