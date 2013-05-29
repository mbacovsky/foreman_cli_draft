require 'kartit/autocompletion'
require 'highline'
require 'clamp'
require 'terminal-table'
require 'awesome_print'

module Kartit
  class AbstractCommand < Clamp::Command

    extend Autocompletion

    def header(heading)
      '-'*terminal_width+"\n"+' '*((terminal_width-heading.length)/2)+heading
    end

    def table(title, data, options = {})
      if data.class >= Array && !data.empty?
        headings = table_headings data[0]
        rows = data.map do |r|
          headings.map { |h| r[r.keys[0]][h] }
        end
        output = Terminal::Table.new :title => title,
                                     :headings => headings,
                                     :rows => rows,
                                     :style => { :border_y => '', :border_i => '', :border_x => '-' }
      end

      output
    end

    def terminal_width()
      HighLine::SystemExtensions.terminal_size[0]
    end

    def table_headings(data)
      data[data.keys[0]].keys
    end

  end
end
