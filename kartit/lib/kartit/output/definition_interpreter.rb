require 'kartit/output/adapter/base'

module Kartit::Output
  class DefinitionInterpreter

    # TODO immutable with initializer?

    def definition= definition
      @definition = definition
      clear
    end

    def records= records
      @records = records
      @records = [@records] unless @records.kind_of?(Array)
      clear
    end

    def fields
      @fields ||= @definition.fields.collect do |field|
        Kartit::Output::Field.new(field.key, field.label, field.options)
      end
    end

    def data
      @data ||= @records.collect do |record|
        @definition.fields.inject({}) do |result, field|
          result[field.key] = value_for_field(field, record)
          result
        end
      end
    end

    protected

    def clear
      @data = @fields = nil
    end

    def symbolize_hash_keys h
      h.inject({}) { |result, (k, v)| result.update k.to_sym => v }
    end

    def value_for_field field, record
      record = follow_path(record, field.path || [])

      if field.record_formatter
        field.record_formatter.call(record)
      else
        value = record[field.key.to_sym] rescue nil
        if field.formatter
          field.formatter.call(value)
        else
          value
        end
      end
    end

    def follow_path(record, path) # FIXME missing parenthesis everywhere
      record = symbolize_hash_keys(record)
      path.inject record do |record, path_key|
        if record.has_key? path_key.to_sym
          symbolize_hash_keys record[path_key.to_sym]
        else
          return nil
        end
      end
    end

  end
end
