require 'kartit/output/adapter/base'

module Kartit::Output
  class DefinitionInterpreter

    def definition= definition
      @definition = definition
      clear
    end

    def records= records
      @records = Array(records)
      clear
    end

    def fields
      return @fields unless @fields.nil?

      @fields = @definition.fields.collect do |field|
        {
          :label => field[:label],
          :options => field[:options],
          :key => field[:key],
        }
      end
    end

    def data
      return @data unless @data.nil?

      @data = @records.collect do |record|
        @definition.fields.inject({}) do |result, field|
          result[field[:key]] = value_for_field(field, record)
          result
        end
      end
    end

    protected

    def clear
      @data = @fields = nil
    end

    def value_for_field field, record
      record = follow_path(record, field[:path] || [])

      if not field[:record_formatter].nil?
        return field[:record_formatter].call(record)

      else
        value = record[field[:key]] rescue nil
        return field[:formatter].call(value) if not field[:formatter].nil?
        return value
      end
    end

    def follow_path record, path
      path.each do |path_key|
        if record.has_key? path_key
          record = record[path_key]
        else
          return nil
        end
      end
      record
    end

  end
end
